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
	Если НЕ ОценкаПроизводительностиСлужебный.ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность") Тогда
		ЭтотОбъект.Элементы.КаталогЭкспорта.КнопкаВыбора = Ложь;
		ЕстьБСП = Ложь;
	Иначе
		ЕстьБСП = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбратьКаталогЭкспортаПредложено(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеРаботыСФайламиПодключено Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ВыборФайла.МножественныйВыбор = Ложь;
		ВыборФайла.Заголовок = НСтр("ru = 'Выбор каталога экспорта'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогВыбораКаталогаЗавершение", ЭтотОбъект, Неопределено);
		Если ЕстьБСП Тогда 
			МодульФайловаяСистемаКлиент = Вычислить("ФайловаяСистемаКлиент");
			Если ТипЗнч(МодульФайловаяСистемаКлиент) = Тип("ОбщийМодуль") Тогда
				МодульФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещения, ВыборФайла);
			КонецЕсли;
		Иначе
			ВыборФайла.Показать(ОписаниеОповещения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЭкспортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЕстьБСП Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКаталогЭкспортаПредложено", ЭтотОбъект);
		МодульФайловаяСистемаКлиент = Вычислить("ФайловаяСистемаКлиент");
		Если ТипЗнч(МодульФайловаяСистемаКлиент) = Тип("ОбщийМодуль") Тогда
			МодульФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЭкспорт(Команда)
    
    ЕстьОшибки = Ложь;
    
    Если НЕ ЗначениеЗаполнено(ДатаНачалаПериодаЭкспорта) Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "ДатаНачалаПериодаЭкспорта";
        СообщениеПользователю.Текст = НСтр("ru = 'Значение параметра ""Дата начала"" не заполнено.
			|Экспорт невозможен.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
    
    Если НЕ ЗначениеЗаполнено(ДатаОкончанияПериодаЭкспорта) Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "ДатаОкончанияПериодаЭкспорта";
        СообщениеПользователю.Текст = НСтр("ru = 'Значение параметра ""Дата окончания"" не заполнено.
			|Экспорт невозможен.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
    
    Если НЕ ЗначениеЗаполнено(КаталогЭкспорта) Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "КаталогЭкспорта";
        СообщениеПользователю.Текст = НСтр("ru = 'Значение параметра ""Каталог экспорта"" не заполнено.
			|Экспорт невозможен.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
    
     Если НЕ ЗначениеЗаполнено(ИмяАрхива) Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "ИмяАрхива";
        СообщениеПользователю.Текст = НСтр("ru = 'Значение параметра ""Имя архива"" не заполнено.
			|Экспорт невозможен.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
        
    Если ЗначениеЗаполнено(ДатаНачалаПериодаЭкспорта) И ЗначениеЗаполнено(ДатаОкончанияПериодаЭкспорта) И ДатаНачалаПериодаЭкспорта >= ДатаОкончанияПериодаЭкспорта Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "ДатаНачалаПериодаЭкспорта";
        СообщениеПользователю.Текст = НСтр("ru = 'Значение параметра ""Дата начала"" больше или равно значения параметры ""Дата окончания"".
			|Экспорт невозможен.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
    
    Если ЕстьОшибки Тогда
        Возврат;
    КонецЕсли;
            
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыЭкспорта = Новый Структура;
	ПараметрыЭкспорта.Вставить("ДатаНачала", ЭтотОбъект.ДатаНачалаПериодаЭкспорта);
	ПараметрыЭкспорта.Вставить("ДатаОкончания", ЭтотОбъект.ДатаОкончанияПериодаЭкспорта);
	ПараметрыЭкспорта.Вставить("АдресХранилища", АдресХранилища);
	ПараметрыЭкспорта.Вставить("Профиль", Профиль);
	ВыполнитьЭкспортНаСервере(ПараметрыЭкспорта);
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища); // ДвоичныеДанные
	УдалитьИзВременногоХранилища(АдресХранилища);
    
    Если ДвоичныеДанные <> Неопределено Тогда
        ДвоичныеДанные.Записать(ЭтотОбъект.КаталогЭкспорта + ПолучитьРазделительПутиКлиента() + ЭтотОбъект.ИмяАрхива + ".zip");
    Иначе
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Текст = НСтр("ru = 'За указанный период нет замеров. Файл архива не сформирован.'") + Символы.ПС;
        СообщениеПользователю.Сообщить();
    КонецЕсли;
    	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ВыполнитьЭкспортНаСервере(Параметры)
	ОценкаПроизводительности.ЭкспортОценкиПроизводительности(Неопределено, Параметры);	
КонецПроцедуры

&НаКлиенте
Процедура ДиалогВыбораКаталогаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
    
    Если ВыбранныеФайлы <> Неопределено Тогда
		ЭтотОбъект.КаталогЭкспорта = ВыбранныеФайлы[0];
	КонецЕсли;
		
КонецПроцедуры


#КонецОбласти