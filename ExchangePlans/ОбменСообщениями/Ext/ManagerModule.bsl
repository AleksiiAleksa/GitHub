﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет настройки, влияющие на использование плана обмена.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию.
//            - см. ОбменДаннымиСервер.НастройкиПланаОбмена
//
Процедура ПриПолученииНастроек(Настройки) Экспорт	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  ОписаниеВарианта - Структура - описание варианта настройки по умолчанию
//					 - см. ОбменДаннымиСервер.ОписаниеВариантаНастройки
//  ИдентификаторНастройки - Строка - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки,
	ПараметрыКонтекста) Экспорт
КонецПроцедуры

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
//  
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт	
КонецФункции

#КонецОбласти

#КонецЕсли