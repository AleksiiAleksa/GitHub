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
	
	// заполнение списка форматов
	Для Каждого ФорматСохранения Из УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента() Цикл
		ВыбранныеФорматыСохранения.Добавить(Строка(ФорматСохранения.ТипФайлаТабличногоДокумента), ФорматСохранения.Представление, Ложь, ФорматСохранения.Картинка);
	КонецЦикла;
	ВыбранныеФорматыСохранения[0].Пометка = Истина; // По умолчанию выбран только первый формат из списка.
	
	// Заполнение списка выбора для присоединения файлов к объекту.
	Для Каждого ОбъектПечати Из Параметры.ОбъектыПечати Цикл
		Если КОбъектуМожноПрисоединятьФайлы(ОбъектПечати.Значение) Тогда
			Элементы.ВыбранныйОбъект.СписокВыбора.Добавить(ОбъектПечати.Значение);
		КонецЕсли;
	КонецЦикла;
	
	// Место сохранения по умолчанию.
	ВариантСохранения = "СохранитьВПапку";
	
	// настройка видимости
	ЕстьВозможностьПрисоединения = Элементы.ВыбранныйОбъект.СписокВыбора.Количество() > 0;
	Элементы.ВыборМестаСохраненияФайла.Видимость = Параметры.РасширениеДляРаботыСФайламиПодключено Или ЕстьВозможностьПрисоединения;
	Элементы.ВариантСохранения.Видимость = ЕстьВозможностьПрисоединения;
	Если Не ЕстьВозможностьПрисоединения Тогда
		Элементы.ПапкаДляСохраненияФайлов.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	Элементы.ПапкаДляСохраненияФайлов.Видимость = Параметры.РасширениеДляРаботыСФайламиПодключено;
	
	// Объект для присоединения по умолчанию.
	Если ЕстьВозможностьПрисоединения Тогда
		ВыбранныйОбъект = Элементы.ВыбранныйОбъект.СписокВыбора[0].Значение;
	КонецЕсли;
	Элементы.ВыбранныйОбъект.ТолькоПросмотр = Элементы.ВыбранныйОбъект.СписокВыбора.Количество() = 1;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		Элементы.КнопкаСохранить.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ФорматыСохраненияИзНастроек = Настройки["ВыбранныеФорматыСохранения"];
	Если ФорматыСохраненияИзНастроек <> Неопределено Тогда
		Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл 
			ФорматИзНастроек = ФорматыСохраненияИзНастроек.НайтиПоЗначению(ВыбранныйФормат.Значение);
			Если ФорматИзНастроек <> Неопределено Тогда
				ВыбранныйФормат.Пометка = ФорматИзНастроек.Пометка;
			КонецЕсли;
		КонецЦикла;
		Настройки.Удалить("ВыбранныеФорматыСохранения");
	КонецЕсли;
	
	Если Элементы.ВыбранныйОбъект.СписокВыбора.Количество() = 0 Тогда
		НастройкаВариантСохранения = Настройки["ВариантСохранения"];
		Если НастройкаВариантСохранения <> Неопределено Тогда
			Настройки.Удалить("ВариантСохранения");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьСтраницуМестаСохранения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантСохраненияПриИзменении(Элемент)
	УстановитьСтраницуМестаСохранения();
	ОчиститьСообщения();
КонецПроцедуры

&НаКлиенте
Процедура ПапкаДляСохраненияФайловНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ВыбраннаяПапка = Элемент.ТекстРедактирования;
	ФайловаяСистемаКлиент.ВыбратьКаталог(Новый ОписаниеОповещения("ПапкаДляСохраненияФайловЗавершениеВыбора", ЭтотОбъект), , ВыбраннаяПапка);
	
КонецПроцедуры

// Обработчик завершения выбора каталога сохраненных файлов.
//  См. Синтакс-помощник: ДиалогВыбораФайла.Показать().
//
&НаКлиенте
Процедура ПапкаДляСохраненияФайловЗавершениеВыбора(Папка, ДополнительныеПараметры) Экспорт 
	Если Не ПустаяСтрока(Папка) Тогда 
		ВыбраннаяПапка = Папка;
		ОчиститьСообщения();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныйОбъектОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если Элементы.ПапкаДляСохраненияФайлов.Видимость Тогда
		Если ВариантСохранения = "СохранитьВПапку" И ПустаяСтрока(ВыбраннаяПапка) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Необходимо указать папку.'"),,"ВыбраннаяПапка");
			Возврат;
		КонецЕсли;
	КонецЕсли;
		
	ФорматыСохранения = Новый Массив;
	
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			ФорматыСохранения.Добавить(ВыбранныйФормат.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ФорматыСохранения.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Необходимо указать как минимум один из предложенных форматов.'"));
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("УпаковатьВАрхив", УпаковатьВАрхив);
	РезультатВыбора.Вставить("ФорматыСохранения", ФорматыСохранения);
	РезультатВыбора.Вставить("ВариантСохранения", ВариантСохранения);
	РезультатВыбора.Вставить("ПапкаДляСохранения", ВыбраннаяПапка);
	РезультатВыбора.Вставить("ОбъектДляПрикрепления", ВыбранныйОбъект);
	РезультатВыбора.Вставить("ПереводитьИменаФайловВТранслит", ПереводитьИменаФайловВТранслит);

	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСтраницуМестаСохранения()
	
	Если Элементы.ПапкаДляСохраненияФайлов.Видимость Тогда
		Если ВариантСохранения = "Присоединить" Тогда
			Элементы.ГруппаМестаСохранения.ТекущаяСтраница = Элементы.СтраницаПрисоединениеКОбъекту;
		Иначе
			Элементы.ГруппаМестаСохранения.ТекущаяСтраница = Элементы.СтраницаСохранениеВПапку;
		КонецЕсли;
	Иначе
		Элементы.ВыбранныйОбъект.Доступность = ВариантСохранения = "Присоединить";
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция КОбъектуМожноПрисоединятьФайлы(СсылкаНаОбъект)
	МожноПрисоединять = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		МожноПрисоединять = МодульРаботаСФайлами.КОбъектуМожноПрисоединятьФайлы(СсылкаНаОбъект);
	КонецЕсли;
	
	Если МожноПрисоединять = Неопределено Тогда
		МожноПрисоединять = Ложь;
	КонецЕсли;
	
	Возврат МожноПрисоединять;
КонецФункции

#КонецОбласти
