﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый Массив;
	ПараметрыРазмещения.Источники.Добавить(Метаданные.Справочники.УчетныеЗаписиDSS);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	МобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	ПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	УстановитьКартинку("Записать");

	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СервисКриптографииDSSСлужебныйКлиент.ПриОткрытииФормы(ЭтотОбъект, ПрограммноеЗакрытие);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ТекущийЭлемент = Элементы.Логин;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму();
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если Изменен Тогда
		Изменен = Ложь;
		Если НЕ ОтказОтПроверки И ПараметрыЗаписи.Количество() = 0 Тогда
			ОповещениеСледующее = Новый ОписаниеОповещения("ПроверитьПодключениеКлиент", ЭтотОбъект);
			ПоказатьВопрос(ОповещениеСледующее, 
						НСтр("ru = 'Данные учетной записи были изменены, проверить подключение к серверу?'", СервисКриптографииDSSСлужебныйКлиент.КодЯзыка()), 
						РежимДиалогаВопрос.ДаНет, 30);
		Иначе
			НастройкиПользователя = ОбновитьНастройкиПользователя(Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	Оповестить("Запись_УчетнойЗаписиDSS", Новый Структура, Объект.Ссылка);
	ОтказОтПроверки = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Изменен = Модифицированность;
	Объект.Наименование = СокрЛП(Объект.Логин) + " на " + СокрЛП(Объект.Владелец);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СсылкаНового = Справочники.УчетныеЗаписиDSS.ПолучитьСсылку(ИдентификаторСправочника);
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаНового);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	Если Изменен Тогда
		НастройкиПользователя = ОбновитьНастройкиПользователя(Объект.Ссылка);
		КонфиденциальныеДанные = ПолучитьДанныеХранилища(ИдентификаторСправочника);
		Если Объект.ПервичнаяАутентификация = Перечисления.СпособыАвторизацииDSS.Первичный_СертификатАвторизации Тогда
			Если ЗначениеЗаполнено(ДанныеСертификата) Тогда
				КонфиденциальныеДанные.СертификатАвторизации = ДанныеСертификата;
			Иначе
				КонфиденциальныеДанные.СертификатАвторизации = Неопределено;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ПинКод) Тогда
				КонфиденциальныеДанные.ПарольСертификата = СервисКриптографииDSSКлиентСервер.ОбъектПароля(ПинКод, 1);
			Иначе
				КонфиденциальныеДанные.ПарольСертификата = СервисКриптографииDSSКлиентСервер.ОбъектПароля("", 3);
			КонецЕсли;
			
		ИначеЕсли ЗначениеЗаполнено(Пароль) Тогда
			КонфиденциальныеДанные.Пароль = СервисКриптографииDSSКлиентСервер.ОбъектПароля(Пароль, 1);
			
		Иначе
			КонфиденциальныеДанные.Пароль = СервисКриптографииDSSКлиентСервер.ОбъектПароля("", 3);
			
		КонецЕсли;	
		
		ЗаписатьВХранилищеСервер(ИдентификаторСправочника, КонфиденциальныеДанные);
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Пароль) Тогда
		Пароль = ЗакрытьДанныеПользователя(Пароль);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПинКодПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ПинКод) Тогда
		ПинКод = ЗакрытьДанныеПользователя(ПинКод);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПервичнаяАутентификацияПриИзменении(Элемент)
	
	ОбновитьСтатусЗащищенногоХранилищаСервер();

КонецПроцедуры

&НаКлиенте
Процедура ПервичнаяАутентификацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВторичнаяАвторизацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	ДанныеСертификата = Неопределено;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ПриИзмененииСервисаПодписиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеСледующее	= Новый ОписаниеОповещения("ВыбратьСертификатПослеПолучения", ЭтотОбъект);
	ПараметрыОперации	= СервисКриптографииDSSСлужебныйКлиент.ПодготовитьПараметрыОперации();
	СервисКриптографииDSSКлиент.ЗагрузитьДанныеИзФайла(ОписаниеСледующее, ".pfx", , Истина, ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛичныйКабинетНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СервисКриптографииDSSКлиент.ПерейтиПоСсылке(АдресЛичногоКабинета, "MSIE");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СервисКриптографииDSS_ЗаписьЗащищенныхДанных" Тогда
		ОбновитьСтатусЗащищенногоХранилищаСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	ПроверитьПодключениеКлиент(КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаРаботоспособности(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда  
		СервисКриптографииDSSКлиент.ПроверитьРаботоспособностьСервиса(Неопределено, Объект.Ссылка);
	Иначе
		СервисКриптографииDSSКлиент.ВывестиОшибку(Неопределено, 
					НСтр("ru = 'Необходимо записать информацию о новой учетной записи.'", СервисКриптографииDSSСлужебныйКлиент.КодЯзыка()));
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьСертификат(Команда)
	
	Если ДанныеСертификата = Неопределено Тогда
		ДанныеСертификата = ПолучитьДанныеХранилища(ИдентификаторСправочника, "СертификатАвторизации");
	КонецЕсли;
	
	ПараметрыОперации = СервисКриптографииDSSСлужебныйКлиент.ПодготовитьПараметрыОперации();
	СервисКриптографииDSSКлиент.СохранитьДанныеВФайл(Неопределено, ДанныеСертификата, ".pfx", Истина, ПараметрыОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояние(Команда)
	
	ОповещениеСледующее = Новый ОписаниеОповещения("ОбновитьСостояниеПослеПроверки", ЭтотОбъект);
	ПроверитьМодифицированность(ОповещениеСледующее);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПодключения(Команда)
	
	ОповещениеСледующее = Новый ОписаниеОповещения("ИзменитьРеквизитыПодключенияПослеПроверки", ЭтотОбъект);
	ПроверитьМодифицированность(ОповещениеСледующее);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредыдущееЗаявление(Команда)
	
	ОповещениеСледующее = Новый ОписаниеОповещения("ОткрытьОформленноеЗаявление", ЭтотОбъект);
	ПроверитьМодифицированность(ОповещениеСледующее);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗакрытьФорму(ПараметрыЗакрытия = Неопределено)
	
	ПрограммноеЗакрытие = Истина;
	
	Если ПараметрыЗакрытия = Неопределено Тогда
		ПараметрыЗакрытия = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Изменен);
	КонецЕсли;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьМодифицированность(ОписаниеЗавершения)
	
	Если Модифицированность Тогда
		ОписаниеСледующее = Новый ОписаниеОповещения("ПроверитьМодифицированностьЗапись", ЭтотОбъект, ОписаниеЗавершения);
		ПоказатьВопрос(
			ОписаниеСледующее,
			НСтр("ru = 'Данные учетной записи были изменены, они будут сохранены. Продолжить?'", СервисКриптографииDSSСлужебныйКлиент.КодЯзыка()),
			РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеЗавершения, КодВозвратаДиалога.Да);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция ЗакрытьДанныеПользователя(ВведенноеЗначение) 
	
	ОбъектПароля = СервисКриптографииDSSКлиент.ПодготовитьОбъектПароля(ВведенноеЗначение);
	Возврат ОбъектПароля.Значение;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(КонтекстФормы)
	
	ОбъектСправочника   = КонтекстФормы.Объект;
	ЭлементыФормы 		= КонтекстФормы.Элементы;

	ВидимостьСертификата= ОбъектСправочника.ПервичнаяАутентификация = ПредопределенноеЗначение("Перечисление.СпособыАвторизацииDSS.Первичный_СертификатАвторизации");
	ВидимостьПароля		= ОбъектСправочника.ПервичнаяАутентификация = ПредопределенноеЗначение("Перечисление.СпособыАвторизацииDSS.Первичный_ДвухФакторная")
							ИЛИ ОбъектСправочника.ПервичнаяАутентификация = ПредопределенноеЗначение("Перечисление.СпособыАвторизацииDSS.Первичный_УчетныеДанные");
							
	ЭлементыФормы.ГруппаСертификат.Видимость = ВидимостьСертификата;
	ЭлементыФормы.ВыгрузитьСертификат.Видимость = ЗначениеЗаполнено(КонтекстФормы.ДанныеСертификата);
	КонтекстФормы.Сертификат = ?(ЗначениеЗаполнено(КонтекстФормы.ДанныеСертификата),
							НСтр("ru = 'Загружен'"), 
							НСтр("ru = 'Загрузите файл'"));
	
	ЭлементыФормы.Пароль.ТолькоПросмотр = НЕ ВидимостьПароля;
	ЭлементыФормы.Пароль.ПодсказкаВвода = ?(ВидимостьПароля, "", НСтр("ru = 'Не требуется'"));
	ЭлементыФормы.Сертификат.Доступность = НЕ КонтекстФормы.МобильныйКлиент;
	ЭлементыФормы.Автор.ТолькоПросмотр = НЕ КонтекстФормы.ПолноправныйПользователь;
	ЭлементыФормы.ГруппаЛичныйКабинет.Видимость = ЗначениеЗаполнено(КонтекстФормы.АдресЛичногоКабинета);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинку(ИмяКартинки)
	
	НашлиКартинку = СервисКриптографииDSS.ПолучитьКартинкуПодсистемы(ИмяКартинки);
	
	Если НашлиКартинку.Вид <> ВидКартинки.Пустая Тогда
		Элементы.ВыгрузитьСертификат.Картинка = НашлиКартинку;
	Иначе
		Элементы.ВыгрузитьСертификат.Отображение = ОтображениеКнопки.Текст;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеСсылок()
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	ЛичныйКабинет   = "";
	АдресЛичногоКабинета = "";
	
	Если НЕ СервисКриптографииDSSСлужебный.ПроверитьПраво("ЭкземплярыСервераDSS") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса 	= 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭкземплярыСервераDSS.АдресЛичногоКабинета КАК АдресЛичногоКабинета
	|ИЗ
	|	Справочник.ЭкземплярыСервераDSS КАК ЭкземплярыСервераDSS
	|ГДЕ
	|	ЭкземплярыСервераDSS.Ссылка = &СсылкаСервера";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СсылкаСервера", Объект.Владелец);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		АдресЛичногоКабинета = Выборка.АдресЛичногоКабинета;
		ОбщаяСтрока = "<a href = """ + АдресЛичногоКабинета + """" + ">" + НСтр("ru = 'Открыть'", КодЯзыка) + "</a>";
		ЛичныйКабинет = СтроковыеФункции.ФорматированнаяСтрока(ОбщаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ПриИзмененииСервисаПодписиСервер()
	
	ОбновитьДанныеСсылок();
	ДоступныеСпособыАвторизации = ПодготовитьСписки(Объект.Владелец);
	Элементы.ВторичнаяАвторизация.СписокВыбора.ЗагрузитьЗначения(ДоступныеСпособыАвторизации.ВторичнаяАвторизация);
	СервисКриптографииDSSКлиентСервер.ПолучитьПредставлениеСпособовАвторизации(Элементы.ВторичнаяАвторизация.СписокВыбора);
	Элементы.ПервичнаяАутентификация.СписокВыбора.ЗагрузитьЗначения(ДоступныеСпособыАвторизации.ПервичнаяАутентификация);
	СервисКриптографииDSSКлиентСервер.ПолучитьПредставлениеСпособовАвторизации(Элементы.ПервичнаяАутентификация.СписокВыбора);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры	

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПриИзмененииСервисаПодписиСервер();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ИдентификаторСправочника = Объект.Ссылка.УникальныйИдентификатор();
		НастройкиПользователя = СервисКриптографииDSSСлужебныйВызовСервера.ПолучитьНастройкиПользователя(Объект.Ссылка);
	Иначе	
		ИдентификаторСправочника = Новый УникальныйИдентификатор;
		Если ДоступныеСпособыАвторизации.ПервичнаяАутентификация.Количество() > 0 Тогда
			Объект.ПервичнаяАутентификация = ДоступныеСпособыАвторизации.ПервичнаяАутентификация[0];
		КонецЕсли;	
		Если ДоступныеСпособыАвторизации.ВторичнаяАвторизация.Количество() > 0 Тогда
			Объект.ВторичнаяАвторизация = ДоступныеСпособыАвторизации.ВторичнаяАвторизация[0];
		КонецЕсли;	
	КонецЕсли;
	
	ОбновитьСтатусЗащищенногоХранилища();
	ОбновитьСостояниеЗаявления();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСостояниеЗаявления(ПринудительноПоказать = Ложь)
	
	ДанныеЗаявления = Обработки.УправлениеПодключениемDSS.ПолучитьДанныеИзПредыдущегоЗаявленияНаСертификат(Объект.Ссылка);
	ПоставляемыйСервер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ВнутреннийИдентификатор", Истина);
	ЗаявлениеПодключено = ЗначениеЗаполнено(ПоставляемыйСервер) 
							И ЗначениеЗаполнено(ДанныеЗаявления.ИдентификаторАбонента)
							И СервисКриптографииDSS.ИспользоватьРасширенныеВозможности();
	НовоеЗаявление = Истина;
	ЕстьЗаявление = Истина;
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	Если ТекущийОбъект.СодержаниеЗаявления.Получить() = Неопределено Тогда
		ЕстьЗаявление = Ложь
	КонецЕсли;
	
	Если Объект.СостояниеЗаявления = Перечисления.СостоянияЗаявленияУчетнойЗаписиDSS.Исполнено Тогда
		СостояниеОбработкиЗаявления = НСтр("ru = 'Заявление на изменение параметров подключения исполнено.'");	
	ИначеЕсли Объект.СостояниеЗаявления = Перечисления.СостоянияЗаявленияУчетнойЗаписиDSS.Отклонено Тогда
		СостояниеОбработкиЗаявления = НСтр("ru = 'Заявление на изменение параметров подключения отклонено.'");
	ИначеЕсли Объект.СостояниеЗаявления = Перечисления.СостоянияЗаявленияУчетнойЗаписиDSS.Отправлено Тогда
		СостояниеОбработкиЗаявления = НСтр("ru = 'Заявление на изменение параметров подключения отправлено. Проверьте статус.'");
		НовоеЗаявление = Ложь;
	Иначе
		СостояниеОбработкиЗаявления = НСтр("ru = 'Заявление на изменение параметров подключения не отправлено.'");
		НовоеЗаявление = Ложь;
	КонецЕсли;	
	
	Элементы.ГруппаСостояниеЗаявления.Видимость = ЗаявлениеПодключено И (ПринудительноПоказать ИЛИ НЕ НовоеЗаявление);
	Элементы.ИзменитьРеквизитыПодключения.Видимость = ЗаявлениеПодключено И НовоеЗаявление И НЕ ПринудительноПоказать;
	Элементы.ОткрытьПредыдущееЗаявление.Видимость = ЗаявлениеПодключено И ЕстьЗаявление И ЗаявлениеПодключено;
	
КонецПроцедуры	

&НаСервере
Процедура БлокироватьДляРедактирования()
	
	ЗаблокироватьДанныеФормыДляРедактирования();
	
КонецПроцедуры

&НаСервере
Процедура РазблокироватьДляРедактирования()
	
	РазблокироватьДанныеФормыДляРедактирования();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзмененияЗаявления(ДанныеЗаявления)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.СостояниеЗаявления = ДанныеЗаявления.СостояниеЗаявления;
	ТекущийОбъект.СодержаниеЗаявления = Новый ХранилищеЗначения(ДанныеЗаявления.СодержаниеЗаявления);
	ТекущийОбъект.Записать();
	
	Прочитать();
	
КонецПроцедуры	

&НаСервере
Процедура ОбновитьСтатусЗащищенногоХранилищаСервер()
	
	ОбновитьСтатусЗащищенногоХранилища();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусЗащищенногоХранилища()
	
	ПинКод = "";
	Пароль = "";
	Сертификат = Неопределено;
	
	Если Объект.ПервичнаяАутентификация = Перечисления.СпособыАвторизацииDSS.Первичный_СертификатАвторизации Тогда
		ПинКод = ПодготовитьЗакрытыеДанные(ПолучитьДанныеХранилища(ИдентификаторСправочника, "ПарольСертификата"));
		ДанныеСертификата = ПолучитьДанныеХранилища(ИдентификаторСправочника, "СертификатАвторизации");
	ИначеЕсли Объект.ПервичнаяАутентификация <> Перечисления.СпособыАвторизацииDSS.Первичный_КодАвторизации Тогда
		Пароль = ПодготовитьЗакрытыеДанные(ПолучитьДанныеХранилища(ИдентификаторСправочника, "Пароль"));
	КонецЕсли;	
		
КонецПроцедуры
	
&НаСервереБезКонтекста
Функция ПодготовитьСписки(СерверПодписи)
	
	Результат = Новый Структура("ПервичнаяАутентификация, ВторичнаяАвторизация");
	Результат.ПервичнаяАутентификация = СервисКриптографииDSS.СписокПервичнойАвторизации(СерверПодписи);
	Результат.ВторичнаяАвторизация = СервисКриптографииDSS.СписокВторичнойАвторизации(СерверПодписи);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОбновитьНастройкиПользователя(ТекущийПользователь)
	
	СервисКриптографииDSSСлужебныйВызовСервера.СброситьПараметрыСеансаУчетнойЗаписи(ТекущийПользователь);
	Результат = СервисКриптографииDSSСлужебныйВызовСервера.ПолучитьНастройкиПользователя(ТекущийПользователь);
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПодготовитьЗакрытыеДанные(ТекущиеДанные)
	
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	Результат = СервисКриптографииDSSКлиентСервер.ПолучитьЗначениеПароля(ТекущиеДанные, АвторизованныйПользователь);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеХранилища(ИдентификаторСправочника, ПараметрДанных = "")
	
	Результат = СервисКриптографииDSSСлужебный.ПолучитьЗакрытыеДанные(Строка(ИдентификаторСправочника), ПараметрДанных);
	
	Возврат Результат;
	
КонецФункции	

&НаСервереБезКонтекста
Процедура ЗаписатьВХранилищеСервер(ИдентификаторСправочника, НовоеЗначение)
	
	СервисКриптографииDSSСлужебный.СохранитьЗакрытыеДанные(СокрЛП(ИдентификаторСправочника), НовоеЗначение);
	
КонецПроцедуры	

#Область АсинхронныеВызовы

&НаКлиенте
Процедура ПроверитьМодифицированностьЗапись(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементЗаписан = Истина;
	Если Модифицированность Тогда
		ОтказОтПроверки = Истина;
		ЭлементЗаписан = Записать();
	КонецЕсли;
	
	Если ЭлементЗаписан Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры, КодВозвратаДиалога.Да);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеКлиент(РезультатВыбора = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		ОписаниеСледующее = Новый ОписаниеОповещения("ПроверитьПодключениеСервиса", ЭтотОбъект);
		ПроверитьМодифицированность(ОписаниеСледующее);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеСервиса(РезультатВыбора = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		НастройкиПользователя = ОбновитьНастройкиПользователя(Объект.Ссылка);
		ОписаниеСледующее 	= Новый ОписаниеОповещения("РезультатАвторизации", ЭтотОбъект);
		ПараметрыОперации	= Новый Структура();
		ПараметрыОперации.Вставить("ИдентификаторОперации", УникальныйИдентификатор);
		ПараметрыОперации.Вставить("Принудительно", Истина);
		ПараметрыОперации.Вставить("ОжидатьВыполнения", Истина);
		СервисКриптографииDSSКлиент.ПроверкаАутентификацииПользователя(ОписаниеСледующее, Объект.Ссылка, ПараметрыОперации);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура РезультатАвторизации(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	КодЯзыка = СервисКриптографииDSSСлужебныйКлиент.КодЯзыка();
	Если РезультатВызова.Выполнено Тогда
		СервисКриптографииDSSКлиент.ВывестиИнформацию(Неопределено, 
														НСтр("ru = 'Проверка авторизации выполнена успешно.'", КодЯзыка), 
														30);
		ОбновитьСтатусЗащищенногоХранилищаСервер();
	ИначеЕсли СервисКриптографииDSSКлиентСервер.ЭтоОшибкаАутентификации(РезультатВызова.Ошибка) Тогда
		СервисКриптографииDSSКлиент.ВывестиОшибку(Неопределено, РезультатВызова.Ошибка);
	ИначеЕсли НЕ СервисКриптографииDSSКлиентСервер.ЭтоОшибкаОтказа(РезультатВызова.Ошибка) Тогда
		СервисКриптографииDSSКлиент.ВывестиОшибку(Неопределено, РезультатВызова.Ошибка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСертификатПослеПолучения(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	Если РезультатВызова.Выполнено Тогда
		ДанныеСертификата = РезультатВызова.Результат.ДанныеФайла;
		Модифицированность = Истина;
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеПослеПроверки(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура;
		Если Объект.СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Отправлено") Тогда
			ПараметрыФормы.Вставить("ОбновитьАвтоматически", Истина);
		Иначе
			ПараметрыФормы.Вставить("ОбновитьАвтоматически", Ложь);
		КонецЕсли;
		ПараметрыФормы.Вставить("УчетнаяЗапись", Объект.Ссылка);
		ПараметрыФормы.Вставить("СостояниеЗаявления", Объект.СостояниеЗаявления);
		ОписаниеСледующее 	= Новый ОписаниеОповещения("ОбновитьСостояниеЗавершение", ЭтотОбъект);
		БлокироватьДляРедактирования();
		СервисКриптографииDSSКлиент.ОткрытьЗаявлениеНаИзменение(ОписаниеСледующее, ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора.Выполнено Тогда
		СохранитьИзмененияЗаявления(РезультатВыбора.Результат);
	КонецЕсли;
	РазблокироватьДляРедактирования();
	ОбновитьСостояниеЗаявления(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПодключенияПослеПроверки(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("УчетнаяЗапись", Объект.Ссылка);
		ПараметрыФормы.Вставить("СостояниеЗаявления", ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.НеПодготовлено"));
		ОписаниеСледующее = Новый ОписаниеОповещения("ИзменитьРеквизитыПодключенияЗавершение", ЭтотОбъект);
		БлокироватьДляРедактирования();
		СервисКриптографииDSSКлиент.ОткрытьЗаявлениеНаИзменение(ОписаниеСледующее, ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПодключенияЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора.Выполнено Тогда
		СохранитьИзмененияЗаявления(РезультатВыбора.Результат);
	КонецЕсли;
	РазблокироватьДляРедактирования();
	УправлениеФормой(ЭтотОбъект);
	ОбновитьСостояниеЗаявления();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОформленноеЗаявление(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("УчетнаяЗапись", Объект.Ссылка);
		ПараметрыФормы.Вставить("СостояниеЗаявления", ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Исполнено"));
		СервисКриптографииDSSКлиент.ОткрытьЗаявлениеНаИзменение(Неопределено, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

