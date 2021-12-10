﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Формирует манифест дополнительного отчета или обработки.
// Для вызова из внешней обработки ПодготовкаДополнительныхОтчетовИОбработокКПубликацииВМоделиСервиса.epf,
// входящей в комплект поставки Менеджера сервиса.
//
// Параметры:
//  ОбъектОбработки - СправочникОбъект.ДополнительныеОтчетыИОбработки - дополнительная обработка.
//  ОбъектВерсии - СправочникОбъект.ДополнительныеОтчетыИОбработки - дополнительная обработка.
//  ВариантыОтчета - ТаблицаЗначений:
//    * КлючВарианта - Строка - ключ варианта дополнительного отчета.
//    * Представление - Строка - представление варианта дополнительного отчета.
//    * Назначение - ТаблицаЗначений:
//       ** РазделИлиГруппа - Строка - для сопоставления с элементом справочника ИдентификаторыОбъектовМетаданных.
//       ** Важный - Булево - Истина, если выводится в группе важных.
//       ** СмТакже - Булево - Истина, если выводится в группе "См. также".
//  РасписанияКоманд - Структура - в ключах идентификаторы команд, а в значениях - расписание.
//  РазрешенияОбработки - Массив из ОбъектXDTO
//                      - СправочникТабличнаяЧасть.ДополнительныеОтчетыИОбработки.Разрешения
//                      - Неопределено
//
// Возвращаемое значение:
//  ОбъектXDTO - ОбъектXDTO {http://www.1c.ru/1cFresh/ApplicationExtensions/Manifest/a.b.c.d}ExtensionManifest -
//    манифест дополнительного отчета или обработки.
//
Функция СформироватьМанифест(Знач ОбъектОбработки, Знач ОбъектВерсии, Знач ВариантыОтчета = Неопределено, 
	Знач РасписанияКоманд = Неопределено, Знач РазрешенияОбработки = Неопределено) Экспорт
	
	Попытка
		РежимСовместимостиРазрешений = ОбъектОбработки.РежимСовместимостиРазрешений;
	Исключение
		РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3;
	КонецПопытки;
	
	Если РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3 Тогда
		Пакет = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.Пакет("1.0.0.1");
	Иначе
		Пакет = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.Пакет();
	КонецЕсли;
	
	Манифест = ФабрикаXDTO.Создать(
		ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипМанифест(Пакет));
	
	Манифест.Name = ОбъектОбработки.Наименование;
	Манифест.ObjectName = ОбъектВерсии.ИмяОбъекта;
	Манифест.Version = ОбъектВерсии.Версия;
	
	Если РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3 Тогда
		Манифест.SafeMode = ОбъектВерсии.БезопасныйРежим;
	КонецЕсли;
	
	Манифест.Description = ОбъектВерсии.Информация;
	Манифест.FileName = ОбъектВерсии.ИмяФайла;
	Манифест.UseReportVariantsStorage = ОбъектВерсии.ИспользуетХранилищеВариантов;
	
	ВидXDTO = Неопределено;
	СловарьПреобразованияВидовОбработок =
		ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьВидыДополнительныхОтчетовИОбработок();
	Для Каждого ФрагментСловаря Из СловарьПреобразованияВидовОбработок Цикл
		Если ФрагментСловаря.Значение = ОбъектВерсии.Вид Тогда
			ВидXDTO = ФрагментСловаря.Ключ;
		КонецЕсли;
	КонецЦикла;
	Если Не ЗначениеЗаполнено(ВидXDTO) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Вид дополнительных отчетов и обработок %1 не поддерживается в модели сервиса.'"),
			ОбъектВерсии.Вид);
	КонецЕсли;
	Манифест.Category = ВидXDTO;
	
	Если ОбъектВерсии.Команды.Количество() > 0 Тогда
		
		Если ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка 
			Или	ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
			
			// Обработка назначения разделам
			ВыбранныеРазделы = ОбъектВерсии.Разделы.Выгрузить();
			
			Если ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Тогда
				ВозможныеРазделы = ДополнительныеОтчетыИОбработки.РазделыДополнительныхОбработок();
			Иначе
				ВозможныеРазделы = ДополнительныеОтчетыИОбработки.РазделыДополнительныхОтчетов();
			КонецЕсли;
			
			ИмяНачальнойСтраницы = ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы();
			
			НазначениеXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеРазделам(Пакет)); // см. ПакетXDTO.ApplicationExtensionsManifest_1_0_0_2
			
			Для Каждого Раздел Из ВозможныеРазделы Цикл
				
				Если Раздел = ИмяНачальнойСтраницы Тогда
					ИмяРаздела = ИмяНачальнойСтраницы;
					ИдентификаторОбъектаМетаданных = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
				Иначе
					ИмяРаздела = Раздел.ПолноеИмя();
					ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Раздел);
				КонецЕсли;
				ПредставлениеОбъектаМетаданных = ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(Раздел);
				
				ОбъектНазначенияXDTO = ФабрикаXDTO.Создать(
					ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипОбъектНазначения(Пакет));
				ОбъектНазначенияXDTO.ObjectName = ИмяРаздела;
				ОбъектНазначенияXDTO.ObjectType = "SubSystem";
				ОбъектНазначенияXDTO.Representation = ПредставлениеОбъектаМетаданных;
				ОбъектНазначенияXDTO.Enabled = ВыбранныеРазделы.Найти(ИдентификаторОбъектаМетаданных, "Раздел") <> Неопределено;
				Объекты = НазначениеXDTO.Objects; // СписокXDTO
				Объекты.Добавить(ОбъектНазначенияXDTO);
				
			КонецЦикла;
			
		Иначе
			
			// Обработка назначения объектам метаданных
			ВыбранныеОбъектыНазначения = ОбъектВерсии.Назначение.Выгрузить();
			
			ВозможныеОбъектыНазначения = Новый Массив();
			ПодключенныеОбъектыМетаданных = ДополнительныеОтчетыИОбработки.ПодключенныеОбъектыМетаданных(ОбъектОбработки.Вид);
			Для Каждого ПодключенныйОбъектМетаданных Из ПодключенныеОбъектыМетаданных Цикл
				ВозможныеОбъектыНазначения.Добавить(ПодключенныйОбъектМетаданных.Метаданные);
			КонецЦикла;
			
			НазначениеXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеСправочникамИДокументам(Пакет));
			
			Для Каждого ОбъектНазначения Из ВозможныеОбъектыНазначения Цикл
				
				ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектНазначения);
				
				ОбъектНазначенияXDTO = ФабрикаXDTO.Создать(
					ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипОбъектНазначения(Пакет));
				ОбъектНазначенияXDTO.ObjectName = ОбъектНазначения.ПолноеИмя();
				Если ОбщегоНазначения.ЭтоСправочник(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "Catalog";
				ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "Document";
				ИначеЕсли ОбщегоНазначения.ЭтоБизнесПроцесс(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "BusinessProcess";
				ИначеЕсли ОбщегоНазначения.ЭтоЗадача(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "Task";
				КонецЕсли;
				ОбъектНазначенияXDTO.Representation = ОбъектНазначения.Представление();
				ОбъектНазначенияXDTO.Enabled = ВыбранныеОбъектыНазначения.Найти(ИдентификаторОбъектаМетаданных, "ОбъектНазначения") <> Неопределено;
				
				Объекты = НазначениеXDTO.Objects; // СписокXDTO
				Объекты.Добавить(ОбъектНазначенияXDTO);
				
			КонецЦикла;
			
			НазначениеXDTO.UseInListsForms = ОбъектВерсии.ИспользоватьДляФормыСписка;
			НазначениеXDTO.UseInObjectsForms = ОбъектВерсии.ИспользоватьДляФормыОбъекта;
			
		КонецЕсли;
		
		Манифест.Assignment = НазначениеXDTO;
		
		Для Каждого ОписаниеКоманды Из ОбъектВерсии.Команды Цикл
			
			КомандаXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипКоманда(Пакет));
			КомандаXDTO.Id = ОписаниеКоманды.Идентификатор;
			КомандаXDTO.Representation = ОписаниеКоманды.Представление;
			
			ТипЗапускаXDTO = Неопределено;
			СловарьПреобразованияСпособовВызова =
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьСпособыВызоваДополнительныхОтчетовИОбработок();
			Для Каждого ФрагментСловаря Из СловарьПреобразованияСпособовВызова Цикл
				Если ФрагментСловаря.Значение = ОписаниеКоманды.ВариантЗапуска Тогда
					ТипЗапускаXDTO = ФрагментСловаря.Ключ;
				КонецЕсли;
			КонецЦикла;
			Если Не ЗначениеЗаполнено(ТипЗапускаXDTO) Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Способ запуска дополнительных отчетов и обработок %1 не поддерживается в модели сервиса.'"),
					ОписаниеКоманды.ВариантЗапуска);
			КонецЕсли;
			КомандаXDTO.StartupType = ТипЗапускаXDTO;
			КомандаXDTO.ShowNotification = ОписаниеКоманды.ПоказыватьОповещение;
			КомандаXDTO.Modifier = ОписаниеКоманды.Модификатор;
			
			Если ЗначениеЗаполнено(РасписанияКоманд) Тогда
				РасписаниеКоманды = Неопределено;
				Если РасписанияКоманд.Свойство(ОписаниеКоманды.Идентификатор, РасписаниеКоманды) Тогда
					КомандаXDTO.DefaultSettings = ФабрикаXDTO.Создать(
						ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНастройкиКоманды(Пакет));
					КомандаXDTO.DefaultSettings.Schedule = СериализаторXDTO.ЗаписатьXDTO(РасписаниеКоманды);
				КонецЕсли;
			КонецЕсли;
			Команды = Манифест.Commands; // СписокXDTO
			Команды.Добавить(КомандаXDTO);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВариантыОтчета) Тогда
		
		Для Каждого ВариантОтчета Из ВариантыОтчета Цикл
			
			ВариантXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипВариантОтчета(Пакет));
			ВариантXDTO.VariantKey = ВариантОтчета.КлючВарианта;
			ВариантXDTO.Representation = ВариантОтчета.Представление;
			
			Если ВариантОтчета.Назначение <> Неопределено Тогда
				
				Для Каждого НазначениеВариантаОтчета Из ВариантОтчета.Назначение Цикл
					
					НазначениеXDTO = ФабрикаXDTO.Создать(
						ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеВариантаОтчета(Пакет));
					
					НазначениеXDTO.ObjectName = НазначениеВариантаОтчета.ПолноеИмя;
					НазначениеXDTO.Representation = НазначениеВариантаОтчета.Представление;
					НазначениеXDTO.Parent = НазначениеВариантаОтчета.ПолноеИмяРодителя;
					НазначениеXDTO.Enabled = НазначениеВариантаОтчета.Использование;
					
					Если НазначениеВариантаОтчета.Важный Тогда
						НазначениеXDTO.Importance = "High";
					ИначеЕсли НазначениеВариантаОтчета.СмТакже Тогда
						НазначениеXDTO.Importance = "Low";
					Иначе
						НазначениеXDTO.Importance = "Ordinary";
					КонецЕсли;
					
					Задания = ВариантXDTO.Assignments; // СписокXDTO
					Задания.Добавить(НазначениеXDTO);
					
				КонецЦикла;
				
			КонецЕсли;
			
			ВариантыОтчета = Манифест.ReportVariants; // СписокXDTO
			ВариантыОтчета.Добавить(ВариантXDTO);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если РазрешенияОбработки = Неопределено Тогда
		
		РазрешенияОбработки = ОбъектОбработки.Разрешения;
		
	КонецЕсли;
	
	Для Каждого Разрешение Из РазрешенияОбработки Цикл
		
		Если ТипЗнч(Разрешение) = Тип("ОбъектXDTO") Тогда
			Разрешения = Манифест.Permissions; // СписокXDTO
			Разрешения.Добавить(Разрешение);
		Иначе
			
			Если РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3 Тогда
				РазрешениеXDTO = ФабрикаXDTO.Создать(
					ФабрикаXDTO.Тип(
						"http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1",
						Разрешение.ВидРазрешения));
			Иначе
				РазрешениеXDTO = ФабрикаXDTO.Создать(
					ФабрикаXDTO.Тип(
						"http://www.1c.ru/1cFresh/Application/Permissions/1.0.0.1",
						Разрешение.ВидРазрешения));
			КонецЕсли;
			
			Параметры = Разрешение.Параметры.Получить();
			Если Параметры <> Неопределено Тогда
				Для Каждого Параметр Из Параметры Цикл
					РазрешениеXDTO[Параметр.Ключ] = Параметр.Значение;
				КонецЦикла;
			КонецЕсли;
			Разрешения = Манифест.Permissions; // СписокXDTO
			Разрешения.Добавить(РазрешениеXDTO);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Манифест;
	
КонецФункции

// Заполняет объекты ОбъектОбработки, ОбъектВерсии и ВариантыОтчета данными, считываемыми из манифеста
// дополнительного отчета или обработки.
//
// Параметры:
//  Манифест - ОбъектXDTO - ОбъектXDTO {http://www.1c.ru/1cFresh/ApplicationExtensions/Manifest/a.b.c.d}ExtensionManifest - манифест
//    дополнительного отчета или обработки.
//  ОбъектОбработки - СправочникОбъект.ДополнительныеОтчетыИОбработки - объект, значения свойств которого будет установлены
//    значениями свойств дополнительного отчета или обработки из манифеста.
//  ОбъектВерсии - СправочникОбъект.ДополнительныеОтчетыИОбработки - объект, значения свойств которого будет установлены
//    значениями свойств версии дополнительного отчета или обработки из манифеста.
//  ВариантыОтчета - ТаблицаЗначений - сведения о вариантах отчета:
//    * КлючВарианта - Строка - ключ варианта дополнительного отчета.
//    * Представление - Строка - представление варианта дополнительного отчета.
//    * Назначение - ТаблицаЗначений:
//       ** РазделИлиГруппа - Строка - для сопоставления с элементом справочника ИдентификаторыОбъектовМетаданных,
//       ** Важный - Булево  - Истина, если выводится в группе важных.
//       ** СмТакже - Булево - Истина, если выводится в группе "См. также".
//
Процедура ПрочитатьМанифест(Знач Манифест, ОбъектОбработки, ОбъектВерсии, ВариантыОтчета) Экспорт
	
	Если Манифест.Тип().URIПространстваИмен = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.Пакет("1.0.0.1") Тогда
		ОбъектОбработки.РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3;
	ИначеЕсли Манифест.Тип().URIПространстваИмен = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.Пакет("1.0.0.2") Тогда
		ОбъектОбработки.РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_2_2;
	КонецЕсли;
	
	ОбъектОбработки.Наименование = Манифест.Name;
	ОбъектВерсии.ИмяОбъекта = Манифест.ObjectName;
	ОбъектВерсии.Версия = Манифест.Version;
	Если ОбъектОбработки.РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3 Тогда
		ОбъектВерсии.БезопасныйРежим = Манифест.SafeMode;
	Иначе
		ОбъектВерсии.БезопасныйРежим = Истина;
	КонецЕсли;
	ОбъектВерсии.Информация = Манифест.Description;
	ОбъектВерсии.ИмяФайла = Манифест.FileName;
	ОбъектВерсии.ИспользуетХранилищеВариантов = Манифест.UseReportVariantsStorage;
	
	СловарьПреобразованияВидовОбработок = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьВидыДополнительныхОтчетовИОбработок();
	ОбъектВерсии.Вид = СловарьПреобразованияВидовОбработок[Манифест.Category];
	
	ОбъектВерсии.Команды.Очистить();
	Для Каждого Command Из Манифест.Commands Цикл
		
		СтрокаКоманды = ОбъектВерсии.Команды.Добавить();
		СтрокаКоманды.Идентификатор = Command.Id;
		СтрокаКоманды.Представление = Command.Representation;
		СтрокаКоманды.ПоказыватьОповещение = Command.ShowNotification;
		СтрокаКоманды.Модификатор = Command.Modifier;
		
		СловарьПреобразованияСпособовВызова =
			ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьСпособыВызоваДополнительныхОтчетовИОбработок();
		СтрокаКоманды.ВариантЗапуска = СловарьПреобразованияСпособовВызова[Command.StartupType];
		
	КонецЦикла;
	
	ОбъектВерсии.Разрешения.Очистить();
	Для Каждого Permission Из Манифест.Permissions Цикл
		
		ТипXDTO = Permission.Тип(); // ТипОбъектаXDTO
		
		Разрешение = ОбъектВерсии.Разрешения.Добавить();
		Разрешение.ВидРазрешения = ТипXDTO.Имя;
		
		Параметры = Новый Структура();
		
		Для Каждого СвойствоXDTO Из ТипXDTO.Свойства Цикл
			
			Контейнер = Permission.ПолучитьXDTO(СвойствоXDTO.Имя);
			
			Если Контейнер <> Неопределено Тогда
				Параметры.Вставить(СвойствоXDTO.Имя, Контейнер.Значение);
			Иначе
				Параметры.Вставить(СвойствоXDTO.Имя);
			КонецЕсли;
			
		КонецЦикла;
		
		Разрешение.Параметры = Новый ХранилищеЗначения(Параметры);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти