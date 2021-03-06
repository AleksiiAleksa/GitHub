///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает признак Истина у свойства Гиперссылка декорации формы.
// 
// Параметры:
//   Надпись - Надпись - декорация формы.
//
Процедура УстановитьПризнакГиперссылки(Надпись) Экспорт
	
	Надпись.Гиперссылка = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли  