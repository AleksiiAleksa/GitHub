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

	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники._ДемоПартнеры);
	ПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	Элементы.СписокКонтекстноеМенюЗаменитьИУдалить.Видимость = ПолноправныйПользователь;
	Элементы.ФормаИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.ФормаЗаменитьИУдалить.Видимость = МожноРедактировать;
	Элементы.ФормаОбъединитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюОбъединитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	ВнешниеПользователи.НастроитьОтображениеСпискаВнешнихПользователей(ЭтотОбъект);

	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаКоманднойПанели", "КоманднаяПанель");
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ПроизвольныйОбъект", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства


	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УдалениеПомеченныхОбъектов
	Элементы.ПерейтиКПомеченнымНаУдаление.Видимость = ПолноправныйПользователь;
	НастройкиОтображенияПомеченных = УдалениеПомеченныхОбъектов.НастройкиОтображенияПомеченныхОбъектов();
	Настройка = НастройкиОтображенияПомеченных.Добавить();
	Настройка.ИмяЭлементаФормы = Элементы.Список.Имя;
	УдалениеПомеченныхОбъектов.ПриСозданииНаСервере(ЭтотОбъект, НастройкиОтображенияПомеченных);
	УдалениеПомеченныхОбъектов.УстановитьПометкуКомандыПоказатьПомеченные(ЭтотОбъект, Элементы.Список, Элементы.ПоказатьПомеченныеНаУдаление);
	// Конец СтандартныеПодсистемы.УдалениеПомеченныхОбъектов

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ПодключитьОбработчикОжидания("СписокПослеАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
	
	Если ИмяСобытия = "Запись__ДемоПартнеры"
	   И Элементы.Список.ТекущаяСтрока = Источник Тогда
		
		ПодключитьОбработчикОжидания("СписокПослеАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если СсылкаНаОбъект <> Элементы.Список.ТекущаяСтрока Тогда
		СсылкаНаОбъект = Элементы.Список.ТекущаяСтрока;
		
		ПодключитьОбработчикОжидания("СписокПослеАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.УдалениеПомеченныхОбъектов

&НаКлиенте
Процедура ПерейтиКПомеченнымНаУдаление(Команда)
	УдалениеПомеченныхОбъектовКлиент.ПерейтиКПомеченнымНаУдаление(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПомеченныеНаУдаление(Команда)
	КнопкаФормы = Элементы.ПоказатьПомеченныеНаУдаление;
	УдалениеПомеченныхОбъектовКлиент.ПоказатьПомеченныеНаУдаление(ЭтотОбъект, Элементы.Список, КнопкаФормы);
КонецПроцедуры

// Конец СтандартныеПодсистемы.УдалениеПомеченныхОбъектов

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ПоискИУдалениеДублей

&НаКлиенте
Процедура ОбъединитьВыделенные(Команда)
	
	ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьМестаИспользования(Команда)
	
	ПоискИУдалениеДублейКлиент.ПоказатьМестаИспользования(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьИУдалить(Команда)
    
    
    // СтандартныеПодсистемы.ОценкаПроизводительности
    ЦентрМониторингаКлиент.ЗаписатьОперациюБизнесСтатистики("_ДемоИнформацияКлиента._ДемоНоменклатура.ЗаменитьИУдалить.Нажатие", 1);
    // Конец СтандартныеПодсистемы.ОценкаПроизводительности
    
	ПоискИУдалениеДублейКлиент.ЗаменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура СписокПослеАктивизацииСтроки()
	
	ЗаполнитьДополнительныеРеквизитыВФорме();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДополнительныеРеквизитыВФорме()
	
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(
			ЭтотОбъект, СсылкаНаОбъект.ПолучитьОбъект(), Истина);
	Иначе
		УправлениеСвойствами.УдалитьСтарыеРеквизитыИЭлементы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры


// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
