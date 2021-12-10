﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Попытка
		
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
			ВызватьИсключение НСтр("ru = 'Недостаточно прав для завершения сеанса'");
		КонецЕсли;
		
		Если ТипЗнч(Параметры.НомераСеансов) = Тип("Массив") Тогда
			НомераСеансов.ЗагрузитьЗначения(Параметры.НомераСеансов);
		КонецЕсли;
		
		ПерейтиКШагуМастера(1);
		
	Исключение
		
		ОбработатьИсключение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция НачатьЗавершениеСеансов()
	
	Если ПустаяСтрока(Пароль) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не указан пароль для доступа к сервису'"), ,
			"Пароль");
		
		Возврат Ложь;
		
	Иначе
		
		Попытка
			
			НачатьЗавершениеСеансовНаСервере();
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеФоновогоЗадания", 5, Истина);
			
			Возврат Истина;
			
		Исключение
			
			ОбработатьИсключение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			Возврат Ложь;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура НачатьЗавершениеСеансовНаСервере()
	
	ПараметрыЗадания = Новый Массив();
	ПараметрыЗадания.Добавить(НомераСеансов.ВыгрузитьЗначения());
	ПараметрыЗадания.Добавить(Пароль);
	
	Задание = ФоновыеЗадания.Выполнить(
		"УдаленноеАдминистрированиеБТССлужебный.ЗавершитьСеансыОбластиДанных",
		ПараметрыЗадания,
		,
		НСтр("ru = 'Завершение активного сеанса'"));
	
	ИдентификаторЗадания = Задание.УникальныйИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеФоновогоЗадания()
	
	Попытка
		
		Если ФоновоеЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			
			Закрыть(КодВозвратаДиалога.ОК);
			
		Иначе
			
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеФоновогоЗадания", 2, Истина);
			
		КонецЕсли;
		
	Исключение
		
		ОбработатьИсключение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФоновоеЗаданиеВыполнено(ИдентификаторЗадания)
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Задание = Неопределено Тогда
		
		ВызватьИсключение НСтр("ru = 'Фоновое задание не найдено'");
		
	Иначе
		
		Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			
			ВызватьИсключение КраткоеПредставлениеОшибки(Задание.ИнформацияОбОшибке);
			
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			
			ВызватьИсключение НСтр("ru = 'Фоновое задание отменено администратором'");
			
		Иначе
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура Далее(Команда)
	
	Если ВыполнитьОбработчикПереходаМеждуШагами(ОбработчикПереходаСТекущегоШага) Тогда
		ПерейтиКШагуМастера(ТекущийШаг + 1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ВыполнитьОбработчикПереходаМеждуШагами(Знач Обработчик)
	
	Результат = Ложь;
	
	Если ЗначениеЗаполнено(Обработчик) Тогда
		
		Попытка
			
			Если Обработчик = "НачатьЗавершениеСеансов" Тогда
				Результат = НачатьЗавершениеСеансов();
			КонецЕсли;
			
		Исключение
			
			ОбработатьИсключение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбработатьИсключение(Знач ТекстИсключения)
	
	ТекстОшибки = ТекстИсключения;
	ПерейтиКШагуМастера(3);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКШагуМастера(Знач Шаг)
	
	Сценарий = СценарийМастера();
	
	ОписаниеШага = Сценарий.Найти(Шаг, "НомерШага");
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы[ОписаниеШага.Страница];
	Элементы.ГруппаКомандыСтраницы.ТекущаяСтраница = Элементы[ОписаниеШага.СтраницаКоманд];
	
	ОбработчикПереходаСТекущегоШага = ОписаниеШага.Обработчик;
	ТекущийШаг = Шаг;
	
КонецПроцедуры

&НаСервере
Функция СценарийМастера()
	
	Результат = Новый ТаблицаЗначений();
	
	Результат.Колонки.Добавить("НомерШага", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("Страница", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("СтраницаКоманд", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Обработчик", Новый ОписаниеТипов("Строка"));
	
	// Ввод пароля
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 1;
	НоваяСтрока.Страница = Элементы.СтраницаВводПароля.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыВводПароля.Имя;
	НоваяСтрока.Обработчик = "НачатьЗавершениеСеансов";
	
	// Ожидание завершения
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 2;
	НоваяСтрока.Страница = Элементы.СтраницаОжидание.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыОжидание.Имя;
	
	// Просмотр ошибки
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.НомерШага = 3;
	НоваяСтрока.Страница = Элементы.СтраницаОшибка.Имя;
	НоваяСтрока.СтраницаКоманд = Элементы.СтраницаКомандыОшибка.Имя;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти


