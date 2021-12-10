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
	
	ВыдаватьПредупреждениеПриЗакрытииФормы = Истина;
	
	// Проверка, что форма открыта программно.
	Если Не Параметры.Свойство("ИмяФайлаСообщенияОбмена") Тогда
		
		НСтрока = НСтр("ru = 'Форма не может быть открыта интерактивно.'");
		ОбщегоНазначения.СообщитьПользователю(НСтрока,,,, Отказ);
		Возврат;
		
	КонецЕсли;
	
	// Инициализируем обработку переданными параметрами.
	ЗаполнитьЗначенияСвойств(Объект, Параметры,, "СписокИспользуемыхПолей, СписокПолейТаблицы");
	
	МаксимальноеКоличествоПользовательскихПолей         = Параметры.МаксимальноеКоличествоПользовательскихПолей;
	АдресВременногоХранилищаТаблицыНеутвержденныхСвязей = Параметры.АдресВременногоХранилищаТаблицыНеутвержденныхСвязей;
	СписокИспользуемыхПолей  = Параметры.СписокИспользуемыхПолей;
	СписокПолейТаблицы       = Параметры.СписокПолейТаблицы;
	СписокПолейСопоставления = Параметры.СписокПолейСопоставления;
	
	Параметры.Свойство("Заголовок", Заголовок);
	
	СценарийАвтоматическогоСопоставленияОбъектов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПорядковыйНомерПерехода = 0;
	
	// Позиционируемся на втором шаге помощника.
	УстановитьПорядковыйНомерПерехода(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Объект.ТаблицаАвтоматическиСопоставленныхОбъектов.Количество() = 0
		Или ВыдаватьПредупреждениеПриЗакрытииФормы <> Истина Тогда
		Возврат;
	КонецЕсли;
			
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ПоказатьПредупреждение(, НСтр("ru = 'Форма содержит данные автоматического сопоставления. Действие отменено.'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	ВыдаватьПредупреждениеПриЗакрытииФормы = Ложь;
	
	// контекстный вызов сервера
	ОповеститьОВыборе(ПоместитьТаблицуАвтоматическиСопоставленныхОбъектовВоВременноеХранилище());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ВыдаватьПредупреждениеПриЗакрытииФормы = Ложь;
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	
	УстановитьПометкиНаСервере(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	УстановитьПометкиНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	ВыдаватьПредупреждениеПриЗакрытииФормы = Ложь;
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		РезультатВычисления = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации.
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		РезультатВычисления = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода,
									ИмяОсновнойСтраницы,
									ИмяОбработчикаПриОткрытии = "",
									ДлительнаяОперация = Ложь,
									ИмяОбработчикаДлительнойОперации = "")
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы = ИмяОсновнойСтраницы;
	
	НоваяСтрока.ИмяОбработчикаПриОткрытии = ИмяОбработчикаПриОткрытии;
	
	НоваяСтрока.ДлительнаяОперация = ДлительнаяОперация;
	НоваяСтрока.ИмяОбработчикаДлительнойОперации = ИмяОбработчикаДлительнойОперации;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТаблицуАвтоматическиСопоставленныхОбъектовВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ТаблицаАвтоматическиСопоставленныхОбъектов.Выгрузить(Новый Структура("Пометка", Истина), "УникальныйИдентификаторПриемника, УникальныйИдентификаторИсточника, ТипИсточника, ТипПриемника"));
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьПолейТаблицы(Знач ИмяТаблицыФормы, Знач МаксКоличествоПользовательскихПолей)
	
	ИмяПоляИсточника = СтрЗаменить("#ИмяТаблицыФормы#ИсточникПолеNN","#ИмяТаблицыФормы#", ИмяТаблицыФормы);
	ИмяПоляПриемника = СтрЗаменить("#ИмяТаблицыФормы#ПриемникПолеNN","#ИмяТаблицыФормы#", ИмяТаблицыФормы);
	
	// Снимаем видимость всех полей таблицы сопоставления.
	Для НомерПоля = 1 По МаксКоличествоПользовательскихПолей Цикл
		
		ПолеИсточника = СтрЗаменить(ИмяПоляИсточника, "NN", Строка(НомерПоля));
		ПолеПриемника = СтрЗаменить(ИмяПоляПриемника, "NN", Строка(НомерПоля));
		
		ЭлементПолеИсточника = Элементы[ПолеИсточника]; // ПолеФормы
		ЭлементПолеПриемника = Элементы[ПолеПриемника]; // ПолеФормы
		
		ЭлементПолеИсточника.Видимость = Ложь;
		ЭлементПолеПриемника.Видимость = Ложь;
		
	КонецЦикла;
	
	// Устанавливаем видимость полей таблицы сопоставления выбранных пользователем.
	Для Каждого Элемент Из Объект.СписокИспользуемыхПолей Цикл
		
		НомерПоля = Объект.СписокИспользуемыхПолей.Индекс(Элемент) + 1;
		
		ПолеИсточника = СтрЗаменить(ИмяПоляИсточника, "NN", Строка(НомерПоля));
		ПолеПриемника = СтрЗаменить(ИмяПоляПриемника, "NN", Строка(НомерПоля));
		
		ЭлементПолеИсточника = Элементы[ПолеИсточника]; // ПолеФормы
		ЭлементПолеПриемника = Элементы[ПолеПриемника]; // ПолеФормы
		
		// Устанавливаем видимость полей.
		ЭлементПолеИсточника.Видимость = Элемент.Пометка;
		ЭлементПолеПриемника.Видимость = Элемент.Пометка;
		
		// Устанавливаем заголовки полей.
		ЭлементПолеИсточника.Заголовок = Элемент.Представление;
		ЭлементПолеПриемника.Заголовок = Элемент.Представление;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкиНаСервере(Пометка)
	
	ТаблицаЗначений = Объект.ТаблицаАвтоматическиСопоставленныхОбъектов.Выгрузить();
	
	ТаблицаЗначений.ЗаполнитьЗначения(Пометка, "Пометка");
	
	Объект.ТаблицаАвтоматическиСопоставленныхОбъектов.Загрузить(ТаблицаЗначений);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиДалее()
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНазад()
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики ожидания

&НаКлиенте
Процедура ОбработчикОжиданияФоновогоЗадания()
	
	ДлительнаяОперацияЗавершена = Ложь;
	
	Состояние = ОбменДаннымиВызовСервера.СостояниеЗадания(ИдентификаторЗадания);
	
	Если Состояние = "Активно" Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияФоновогоЗадания", 5, Истина);
		
	ИначеЕсли Состояние = "Завершено" Тогда
		
		ДлительнаяОперация = Ложь;
		ДлительнаяОперацияЗавершена = Истина;
		
		ПерейтиДалее();
		
	Иначе // ЗавершеноАварийно
		
		ДлительнаяОперация = Ложь;
		
		ПерейтиНазад();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий переходов.

// Страница 1: Ошибка автоматического сопоставления.
//
&НаКлиенте
Функция Подключаемый_ОшибкаСопоставленияОбъектов_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.Закрыть1.КнопкаПоУмолчанию = Истина;
	
	Возврат Неопределено;
	
КонецФункции

// Страница 2 (ожидание): Сопоставление объектов.
//
&НаКлиенте
Функция Подключаемый_ОжиданиеСопоставленияОбъектов_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ДлительнаяОперация          = Ложь;
	ДлительнаяОперацияЗавершена = Истина;
	ИдентификаторЗадания        = Неопределено;
	АдресВременногоХранилища    = "";
	
	Результат = ФоновоеЗаданиеЗапуститьНаСервере(Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Результат.Статус = "Выполняется" Тогда
		
		ПерейтиДалее                = Ложь;
		ДлительнаяОперация          = Истина;
		ДлительнаяОперацияЗавершена = Ложь;
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.ВыводитьСообщения    = Истина;
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершениеФоновогоЗадания", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, ОповещениеОЗавершении, ПараметрыОжидания);
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Страница 2 Обработчик оповещения о завершении фонового задания.
&НаКлиенте
Процедура ЗавершениеФоновогоЗадания(Результат, ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперация          = Ложь;
	ДлительнаяОперацияЗавершена = Истина;
	
	Если Результат = Неопределено Тогда
		ПерейтиНазад();
	ИначеЕсли Результат.Статус = "Ошибка" Или Результат.Статус = "Отменено" Тогда
		ЗафиксироватьОшибку(Результат.ПодробноеПредставлениеОшибки);
		ПерейтиНазад();
	Иначе
		ПерейтиДалее();
	КонецЕсли;
	
КонецПроцедуры

// Страница 3 (ожидание): Сопоставление объектов.
//
&НаКлиенте
Функция Подключаемый_ОжиданиеСопоставленияОбъектовДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Если ДлительнаяОперацияЗавершена Тогда
		
		ВыполнитьСопоставлениеОбъектовОкончание(Отказ);
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Страница 4: Работа с результатом автоматического сопоставления.
//
&НаКлиенте
Функция Подключаемый_СопоставлениеОбъектов_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.Применить.КнопкаПоУмолчанию = Истина;
	
	Если ПустойРезультат Тогда
		ПропуститьСтраницу = Истина;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Страница 5: Пустой результат автоматического сопоставления.
//
&НаКлиенте
Функция Подключаемый_ПустойРезультатСопоставленияОбъектовПустойРезультатСопоставленияОбъектов_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
	
	Возврат Неопределено;
	
КонецФункции

// Страница 2: Сопоставление объектов.
//
&НаСервере
Функция ФоновоеЗаданиеЗапуститьНаСервере(Отказ)
	
	РеквизитыФормы = Новый Структура;
	РеквизитыФормы.Вставить("СписокИспользуемыхПолей",  СписокИспользуемыхПолей);
	РеквизитыФормы.Вставить("СписокПолейТаблицы",       СписокПолейТаблицы);
	РеквизитыФормы.Вставить("СписокПолейСопоставления", СписокПолейСопоставления);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("КонтекстОбъекта",             ОбменДаннымиСервер.ПолучитьКонтекстОбъекта(РеквизитФормыВЗначение("Объект")));
	ПараметрыЗадания.Вставить("РеквизитыФормы",              РеквизитыФормы);
	ПараметрыЗадания.Вставить("ТаблицаНеутвержденныхСвязей", ПолучитьИзВременногоХранилища(АдресВременногоХранилищаТаблицыНеутвержденныхСвязей));
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Автоматическое сопоставление объектов'");
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.СопоставлениеОбъектовИнформационныхБаз.ВыполнитьАвтоматическоеСопоставлениеОбъектов",
		ПараметрыЗадания,
		ПараметрыВыполнения);
		
	Если Результат = Неопределено Тогда
		Отказ = Истина;
		Возврат Неопределено;
	КонецЕсли;
	
	ИдентификаторЗадания     = Результат.ИдентификаторЗадания;
	АдресВременногоХранилища = Результат.АдресРезультата;
	
	Если Результат.Статус = "Ошибка" Или Результат.Статус = "Отменено" Тогда
		Отказ = Истина;
		ЗафиксироватьОшибку(Результат.ПодробноеПредставлениеОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Страница 3: Сопоставление объектов.
//
&НаСервере
Процедура ВыполнитьСопоставлениеОбъектовОкончание(Отказ)
	
	Попытка
		ПослеСопоставленияОбъектов(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
	Исключение
		Отказ = Истина;
		ЗафиксироватьОшибку(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ПослеСопоставленияОбъектов(Знач РезультатСопоставления)
	
	ОбработкаОбъект = Обработки.СопоставлениеОбъектовИнформационныхБаз.Создать();
	ОбменДаннымиСервер.ЗагрузитьКонтекстОбъекта(РезультатСопоставления.КонтекстОбъекта, ОбработкаОбъект);
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	
	ПустойРезультат = РезультатСопоставления.ПустойРезультат;
	
	Если Не ПустойРезультат Тогда
		
		Модифицированность = Истина;
		
		// Устанавливаем заголовки и видимость полей таблицы на форме.
		УстановитьВидимостьПолейТаблицы("ТаблицаАвтоматическиСопоставленныхОбъектов", МаксимальноеКоличествоПользовательскихПолей);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗафиксироватьОшибку(ПодробноеПредставлениеОшибки)
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Помощник сопоставления объектов.Автоматическое сопоставление'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,ПодробноеПредставлениеОшибки);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Инициализация переходов помощника.

&НаСервере
Процедура СценарийАвтоматическогоСопоставленияОбъектов()
	
	ТаблицаПереходов.Очистить();
	
	ТаблицаПереходовНоваяСтрока(1, "ОшибкаСопоставленияОбъектов", "Подключаемый_ОшибкаСопоставленияОбъектов_ПриОткрытии");
	
	// Ожидание сопоставления объектов.
	ТаблицаПереходовНоваяСтрока(2, "ОжиданиеСопоставленияОбъектов",, Истина, "Подключаемый_ОжиданиеСопоставленияОбъектов_ОбработкаДлительнойОперации");
	ТаблицаПереходовНоваяСтрока(3, "ОжиданиеСопоставленияОбъектов",, Истина, "Подключаемый_ОжиданиеСопоставленияОбъектовДлительнаяОперацияОкончание_ОбработкаДлительнойОперации");
	
	// Работа с результатом автоматического сопоставления.
	ТаблицаПереходовНоваяСтрока(4, "СопоставлениеОбъектов", "Подключаемый_СопоставлениеОбъектов_ПриОткрытии");
	ТаблицаПереходовНоваяСтрока(5, "ПустойРезультатСопоставленияОбъектов", "Подключаемый_ПустойРезультатСопоставленияОбъектовПустойРезультатСопоставленияОбъектов_ПриОткрытии");
	
КонецПроцедуры

#КонецОбласти
