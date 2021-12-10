﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа И ПометкаУдаления Тогда
		Использование = Ложь;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроверкаВеденияУчетаИзменена = ОбъектБылИзменен();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбъектБылИзменен()
	
	Если ЭтоНовый() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПроверкаВеденияУчетаИзменена Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПроверятьИзмененность") И Не ДополнительныеСвойства.ПроверятьИзмененность Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("Наименование");
	
	Если Не ЭтоГруппа Тогда
		
		Реквизиты = Метаданные().Реквизиты;
		Для Каждого Реквизит Из Реквизиты Цикл
			
			Если Реквизит.Имя = "ДополнительныеПараметры"
				Или Реквизит.Имя = "РасписаниеВыполненияПроверки"
				Или Реквизит.Имя = "ПроверкаВеденияУчетаИзменена" Тогда
				Продолжить;
			КонецЕсли;
			
			ПроверяемыеРеквизиты.Добавить(Реквизит.Имя);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для Каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
		
		Если Ссылка[ПроверяемыйРеквизит] <> ЭтотОбъект[ПроверяемыйРеквизит] Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли