﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает версию интерфейса обработчиков выгрузки / загрузки данных 1.0.0.0.
// Возвращаемое значение:
//  Строка - версия.
//
Функция ВерсияОбработчиков1_0_0_0() Экспорт
	
	Возврат "1.0.0.0";
	
КонецФункции

// Возвращает версию интерфейса обработчиков выгрузки / загрузки данных 1.0.0.1.
// Возвращаемое значение:
//  Строка - версия.
//
Функция ВерсияОбработчиков1_0_0_1() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация событий при выгрузке данных

// Формирует массив метаданных, требующих аннотацию ссылок при выгрузке.
//
// Возвращаемое значение:
//  ФиксированныйМассив из ОбъектМетаданных - массив метаданных.
//
Функция ПолучитьТипыТребующиеАннотациюСсылокПриВыгрузке() Экспорт
	
	Типы = Новый Массив();
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	
	// Интегрированные обработчики
	ВыгрузкаЗагрузкаНеразделенныхДанных.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаСовместноРазделенныхДанных.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаПредопределенныхДанных.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаУзловПлановОбменов.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

// Формирует массив метаданных, поддерживающих сопоставление ссылок при загрузке.
//
// Возвращаемое значение:
//  ФиксированныйМассив из ОбъектМетаданных - массив метаданных:
//   * СтандартныеРеквизиты - ОписанияСтандартныхРеквизитов - стандартные реквизиты:
//    ** Ссылка - ОбъектМетаданных - метаданные реквизита.
//
Функция ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке() Экспорт
	
	Типы = Новый Массив();
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

// Формирует массив метаданных, не требующих сопоставление ссылок при загрузке.
//
// Возвращаемое значение:
//  ФиксированныйМассив из ОбъектМетаданных - массив метаданных.
//
Функция ПолучитьТипыОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке() Экспорт
	
	Типы = Новый Массив();
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

// Формирует массив метаданных, исключаемых из загрузки/выгрузки.
//
// Возвращаемое значение:
//  ФиксированныйМассив из ОбъектМетаданных - массив метаданных.
//
Функция ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки() Экспорт
	
	Типы = Новый Массив();
	
	РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		МодульИнформационныйЦентрСлужебный = ОбщегоНазначения.ОбщийМодуль("ИнформационныйЦентрСлужебный");
		МодульИнформационныйЦентрСлужебный.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		МодульОбменДаннымиВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиВМоделиСервиса");
		МодульОбменДаннымиВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РасширенияВМоделиСервиса") Тогда
		МодульРасширенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РасширенияВМоделиСервиса");
		МодульРасширенияВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если РаботаВМоделиСервиса.РазделениеВключено()
		И ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ЦентрКонтроляКачества") Тогда
		МодульИнцидентыЦККСервер = ОбщегоНазначения.ОбщийМодуль("ИнцидентыЦККСервер");
		МодульИнцидентыЦККСервер.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.УправлениеТарифами") Тогда
		МодульТарификация = ОбщегоНазначения.ОбщийМодуль("Тарификация");
		МодульТарификация.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ПроверкаИКорректировкаДанных") Тогда
		МодульПроверкаИКорректировкаДанных = ОбщегоНазначения.ОбщийМодуль("ПроверкаИКорректировкаДанных");
		МодульПроверкаИКорректировкаДанных.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.МиграцияПриложений") Тогда
		МодульМиграцияПриложений = ОбщегоНазначения.ОбщийМодуль("МиграцияПриложений");
		МодульМиграцияПриложений.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданийВнешнийИнтерфейс") Тогда
		МодульОчередьЗаданийВнешнийИнтерфейс = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийВнешнийИнтерфейс");
		МодульОчередьЗаданийВнешнийИнтерфейс.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ФайлыОбластейДанных") Тогда
		МодульПоставляемыеДанныеАбонентов = ОбщегоНазначения.ОбщийМодуль("ФайлыОбластейДанных");
		МодульПоставляемыеДанныеАбонентов.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ИнтеграцияОбъектовОбластейДанных") Тогда
		МодульИнтеграцияОбъектовОбластейДанных = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияОбъектовОбластейДанных");
		МодульИнтеграцияОбъектовОбластейДанных.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ПоставляемыеДанные") Тогда
		МодульПоставляемыеДанные = ОбщегоНазначения.ОбщийМодуль("ПоставляемыеДанные");
		МодульПоставляемыеДанные.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация событий при загрузке данных


// Возвращает зависимости типов при замене ссылок.
//
// Возвращаемое значение:
//  ФиксированноеСоответствие из КлючИЗначение:
//   * Ключ - Строка - полное имя зависимого объекта метаданных,
//   * Значение - Массив из Строка - полные имена объектов метаданных, от которых зависит данный объект метаданных.
//
Функция ПолучитьЗависимостиТиповПриЗаменеСсылок() Экспорт
	
	// Интегрированные обработчики
	Возврат ВыгрузкаЗагрузкаНеразделенныхДанных.ЗависимостиТиповПриЗаменеСсылок();
	
КонецФункции

// Выполняет ряд действий после загрузки данных
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//  Сериализация - ОбъектXDTO - ОбъектXDTO {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}InfoBaseUser,
//    сериализация пользователя информационной базы.
//  ПользовательИБ - ПользовательИнформационнойБазы -  десериализованный из выгрузки,
//  Отказ - Булево -  при установке значения данного параметры внутри этой процедуры в
//    значение Ложь загрузка пользователя информационной базы будет пропущена.
//
Процедура ВыполнитьДействияПриЗагрузкеПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ, Отказ) Экспорт
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗагрузкеПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ, Отказ);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗагрузкеПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ, Отказ);
	
КонецПроцедуры

// Выполняет ряд действий после загрузки пользователя информационной базы.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//  Сериализация - ОбъектXDTO - ОбъектXDTO {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}InfoBaseUser,
//    сериализация пользователя информационной базы.
//  ПользовательИБ - ПользовательИнформационнойБазы - десериализованный из выгрузки.
//
Процедура ВыполнитьДействияПослеЗагрузкиПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ) Экспорт
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПослеЗагрузкиПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ);
	
КонецПроцедуры

// Выполняет ряд действий после загрузки пользователей информационной базы.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ВыполнитьДействияПослеЗагрузкиПользователейИнформационнойБазы(Контейнер) Экспорт
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПослеЗагрузкиПользователейИнформационнойБазы(Контейнер);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиПользователейИнформационнойБазы(Контейнер);
	
КонецПроцедуры

#КонецОбласти