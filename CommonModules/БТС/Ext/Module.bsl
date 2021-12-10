﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// @strict-types
#Область ПрограммныйИнтерфейс

#Область СтатистикаРасширений

// Выполняет фиксацию события работы расширения, в группе событий "Пользовательское"
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторСобытия - Строка - идентификатор события полученный в личном кабинете Менеджера сервиса (длинна 36).
//
// Пример:
//	БТС.ЗафиксироватьСобытиеСтатистикиРасширения("2f1df77a-9f07-11e9-9d8c-0242ac1d0004")
//
Процедура ЗафиксироватьСобытиеСтатистикиРасширения(Знач ИдентификаторСобытия) Экспорт
КонецПроцедуры

#КонецОбласти

#КонецОбласти