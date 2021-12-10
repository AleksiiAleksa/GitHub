﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// Возвращает сведения о внешней обработке.
//
// Возвращаемое значение:
//   см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке
//
Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Информация = НСтр("ru = 'Обработка сервисных функций полнотекстового поиска. Используется для демонстрации возможностей подсистемы ""Дополнительные отчеты и обработки"".'");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Версия = "3.0.2.1";
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Обновить индекс полнотекстового поиска'");
	Команда.Идентификатор = "ОбновитьИндекс";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.ПоказыватьОповещение = Истина;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Вывод ошибки'");
	Команда.Идентификатор = "Исключение";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Управление полнотекстовым поиском'");
	Команда.Идентификатор = "ОткрытиеФормы";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	Команда.ПоказыватьОповещение = Истина;
	
	Описание = НСтр("ru = 'Для управления индексом полнотекстового поиска требуется установка привилегированного режима.'");
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеПривилегированногоРежима(Описание);
	ПараметрыРегистрации.Разрешения.Добавить(Разрешение);
	
	Возврат ПараметрыРегистрации;
КонецФункции

// Обработчик серверных команд.
//
// Параметры:
//   ИмяКоманды           - Строка    - имя команды, определенное в функции СведенияОВнешнейОбработке().
//   ПараметрыВыполнения  - Структура - контекст выполнения команды:
//       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка обработки.
//           Может использоваться для чтения параметров обработки.
//           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//
Процедура ВыполнитьКоманду(Знач ИмяКоманды, Знач ПараметрыВыполнения) Экспорт
	Если ИмяКоманды = "Исключение" Тогда
		ВызватьИсключение НСтр("ru = 'Вызвано исключение'");
	КонецЕсли;
	Если ИмяКоманды = "ОткрытиеФормы" Тогда
		ИмяКоманды = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыВыполнения, "ИмяКоманды");
	КонецЕсли;
	
	// Общие действия перед началом выполнения команд.
	УстановитьПривилегированныйРежим(Истина);
	
	// Диспетчеризация обработчиков команд.
	Если ИмяКоманды = "ОбновитьИндекс" Тогда
		Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() <> РежимПолнотекстовогоПоиска.Разрешить Тогда 
			ВызватьИсключение НСтр("ru = 'Полнотекстовый поиск запрещен. Обратитесь к администратору.'");
		КонецЕсли;	
		Попытка
			ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Демо: управление полнотекстовым поиском'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Предупреждение,,, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;	
	ИначеЕсли ИмяКоманды = "ОчиститьИндекс" Тогда
		Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() <> РежимПолнотекстовогоПоиска.Разрешить Тогда 
			ВызватьИсключение НСтр("ru = 'Полнотекстовый поиск запрещен. Обратитесь к администратору.'");
		КонецЕсли;	
		Попытка
			ПолнотекстовыйПоиск.ОчиститьИндекс();
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Демо: управление полнотекстовым поиском'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Предупреждение,,, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;	
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Команда ""%1"" не поддерживается обработкой ""%2""'"), ИмяКоманды, Метаданные().Представление());
	КонецЕсли;
	
	// Имитация длительной операции для демонстрации запуска фонового задания в клиент-серверном режиме.
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ДатаОкончания = ТекущаяДатаСеанса() + 4;
		Пока ДатаОкончания > ТекущаяДатаСеанса() Цикл
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли