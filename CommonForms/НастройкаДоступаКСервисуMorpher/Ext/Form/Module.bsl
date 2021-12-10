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
	
	УстановитьПривилегированныйРежим(Истина);
	ВладелецТокена = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.СклоненияПредставленийОбъектов");
	Токен = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ВладелецТокена, "ТокенДоступаКСервисуMorpher", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	ВидДоступаКСервисуMorher = 0;
	Если ЗначениеЗаполнено(Токен) Тогда
		ВидДоступаКСервисуMorher = 1;
		Токен = ЭтотОбъект.УникальныйИдентификатор;
	КонецЕсли;
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДоступаКСервисуMorherПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементов();
			
	Если ВидДоступаКСервисуMorher = 0 Тогда
		Токен = Неопределено;
		ТокенИзменен = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТокенПриИзменении(Элемент)
	ТокенИзменен = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	ПроверитьТокен(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьИзмененияНаСервере();
	Закрыть();
			
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьИзмененияНаСервере()
	
	Если Не ТокенИзменен Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ВладелецТокена = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.СклоненияПредставленийОбъектов");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ВладелецТокена, Токен, "ТокенДоступаКСервисуMorpher");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(Токен) Тогда
		Токен = ЭтотОбъект.УникальныйИдентификатор;
	КонецЕсли;
	
	ТокенИзменен = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Токен",
		"Доступность",
		ВидДоступаКСервисуMorher = 1);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Токен",
		"АвтоОтметкаНезаполненного",
		ВидДоступаКСервисуMorher = 1);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Токен",
		"ОтметкаНезаполненного",
		Не ЗначениеЗаполнено(Токен));

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьТокен(Отказ)
	
	Если ВидДоступаКСервисуMorher = 1 И Не ЗначениеЗаполнено(Токен) Тогда
		ТекстСообщения = НСтр("ru = 'Токен доступа не заполнен.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , "Токен", Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти



