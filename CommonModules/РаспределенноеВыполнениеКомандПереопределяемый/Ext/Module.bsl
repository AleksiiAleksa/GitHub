﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// @strict-types

#Область ПрограммныйИнтерфейс

// Вызывается при получении сообщения о передаче файла из другой области данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//  ИмяФайла - Строка - полное имя к передаваемому файлу.
//  ИдентификаторВызова - УникальныйИдентификатор - для идентификации конкретного вызова
//  КодОтправителя - Число - код области данных, откуда был передан файл.
//  ПараметрыВызова - Структура - дополнительные параметры вызова:
//            *Код - Число
//            *Тело - Строка.
//  Обработан - Булево - признак успешной обработки сообщения.
//
Процедура ОбработатьЗапросНаПередачуФайла(ИмяФайла, ИдентификаторВызова, КодОтправителя, ПараметрыВызова, Обработан) Экспорт

КонецПроцедуры

// Вызывается при получении квитанции "Успех" на передачу файла из другой области данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//  ИдентификаторВызова - УникальныйИдентификатор - для идентификации конкретного вызова
//  КодОтправителя - Число - код области данных, откуда был передан файл.
//  ПараметрыВызова - Структура - дополнительные параметры вызова:
//            *Код - Число
//            *Тело - Строка.
//  Обработан - Булево - признак успешной обработки сообщения.
//
Процедура ОбработатьОтветНаПередачуФайла(ИдентификаторВызова, КодОтправителя, ПараметрыВызова, Обработан) Экспорт

КонецПроцедуры

// Вызывается при получении квитанции "Ошибка" на передачу файла из другой области данных.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//  ИдентификаторВызова - УникальныйИдентификатор - для идентификации конкретного вызова
//  КодОтправителя - Число - код области данных, откуда был передан файл.
//  ТекстОшибки - Строка - описание возникшей ошибки 
//  Обработан - Булево - признак успешной обработки сообщения.
//
Процедура ОбработатьОшибкуПередачиФайла(ИдентификаторВызова, КодОтправителя, ТекстОшибки, Обработан) Экспорт

КонецПроцедуры

#КонецОбласти