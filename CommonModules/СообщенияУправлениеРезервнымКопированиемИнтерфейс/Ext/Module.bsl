﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  Строка - наименование пакета.
//
Функция Пакет() Экспорт
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  Строка - версия пакета.
//
Функция Версия() Экспорт
КонецФункции

// Возвращает название программного интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  Строка - идентификатор программного интерфейса.
//
Функция ПрограммныйИнтерфейс() Экспорт
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - массив обработчиков.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - массив обработчиков.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}PlanZoneBackup.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - сообщение.
//
Функция СообщениеПланироватьАрхивациюОбласти(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}CancelZoneBackup.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - сообщение.
//
Функция СообщениеОтменитьАрхивациюОбласти(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}UpdateScheduledZoneBackupSettings
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - сообщение.
//
Функция СообщениеОбновитьНастройкиПериодическогоРезервногоКопирования(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}CancelScheduledZoneBackup
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - сообщение.
//
Функция СообщениеОтменитьПериодическоеРезервноеКопирование(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

#КонецОбласти
