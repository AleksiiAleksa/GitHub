﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АдресНастроек") Тогда
		ЗагрузитьНастройки(ПолучитьИзВременногоХранилища(Параметры.АдресНастроек));
	КонецЕсли;
	
	РегламентноеЗадание = УдалениеПомеченныхОбъектовСлужебныйВызовСервера.РежимУдалятьПоРасписанию();
	АвтоматическиУдалятьПомеченныеОбъекты = РегламентноеЗадание.Использование;
	УдалениеПомеченныхРасписание    = РегламентноеЗадание.Расписание;
	
	УстановитьСостояниеФормыПоНастройкамРегламентногоЗадания(ЭтотОбъект);
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.УдалениеПомеченныхНастроитьРасписание.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СтандартныеПодсистемыКлиент.РазвернутьУзлыДерева(ЭтотОбъект, "НастройкиОтображенияОбъектов");
	ПодключитьОбработчикОжидания("НачатьПроверкаБлокировкиУдаляемыхОбъектов",0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьРегламентноеУдалениеПриИзменении(Элемент)
	ОповещениеОбИзменении = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект);
	УдалениеПомеченныхОбъектовКлиент.ПриИзмененииФлажкаУдалятьПоРасписанию(АвтоматическиУдалятьПомеченныеОбъекты, ОповещениеОбИзменении);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиРегламентногоЗадания(Команда)
	ОповещениеОбИзменении = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект);
	УдалениеПомеченныхОбъектовКлиент.НачатьИзменениеРасписанияРегламентногоЗадания(ОповещениеОбИзменении);
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Изменения, ПараметрыВыполнения) Экспорт
	Если Изменения = Неопределено Тогда
		АвтоматическиУдалятьПомеченныеОбъекты = Ложь;
	Иначе	
		УдалениеПомеченныхРасписание = Изменения.Расписание;
		АвтоматическиУдалятьПомеченныеОбъекты = Изменения.Использование;
	КонецЕсли;
	
	УстановитьСостояниеФормыПоНастройкамРегламентногоЗадания(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбычноеУдалениеПриИзменении(Элемент)
	УстановитьРежим("ОбычноеУдаление");
КонецПроцедуры

&НаКлиенте
Процедура БезопасноеУдалениеПриИзменении(Элемент)
	УстановитьРежим("БезопасноеУдаление");
КонецПроцедуры

&НаКлиенте
Процедура МонопольноеУдалениеПриИзменении(Элемент)
	УстановитьРежим("МонопольноеУдаление");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьНастройку(Команда)
	КоллекцияВыбираемыхОбъектов = Новый СписокЗначений;

	КоллекцияВыбираемыхОбъектов.Добавить("Справочники");
	КоллекцияВыбираемыхОбъектов.Добавить("Документы");
	КоллекцияВыбираемыхОбъектов.Добавить("ПланыВидовХарактеристик");
	КоллекцияВыбираемыхОбъектов.Добавить("ПланыСчетов");
	КоллекцияВыбираемыхОбъектов.Добавить("ПланыСчетов");
	КоллекцияВыбираемыхОбъектов.Добавить("ПланыВидовРасчета");
	КоллекцияВыбираемыхОбъектов.Добавить("БизнесПроцессы");
	КоллекцияВыбираемыхОбъектов.Добавить("Задачи");

	ВыбранныеОбъекты = Новый СписокЗначений;
	Для Каждого МестоПоиска Из НастройкиОтображенияОбъектов.ПолучитьЭлементы() Цикл
		ВыбранныеОбъекты.Добавить(МестоПоиска.МестоПоискаРеквизит);
	КонецЦикла;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КоллекцииВыбираемыхОбъектовМетаданных", КоллекцияВыбираемыхОбъектов);
	ПараметрыФормы.Вставить("ТолькоПодсистемыСКИ", Истина);
	ПараметрыФормы.Вставить("ВыбранныеОбъектыМетаданных", ВыбранныеОбъекты);

	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ДобавитьНастройкуПродолжение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектовМетаданных", ПараметрыФормы, ЭтотОбъект, , , , ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПолеНастройки(Команда)
	Если НастройкиОтображенияОбъектов.ПолучитьЭлементы().Количество() = 0 Тогда
		ДобавитьНастройку(Команда);
	КонецЕсли;

	ТекущиеДанные = Элементы.НастройкиОтображенияОбъектов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	МестоПоиска = ТекущиеДанные.МестоПоискаРеквизит;
	РодительЭлемента = ТекущиеДанные.ПолучитьРодителя();
	Если РодительЭлемента <> Неопределено И ЗначениеЗаполнено(РодительЭлемента.МестоПоискаРеквизит) Тогда
		МестоПоиска = РодительЭлемента.МестоПоискаРеквизит;
	КонецЕсли;

	РеквизитыДляВыбора = РеквизитыДляВыбора(РеквизитыМетаданных(МестоПоиска), ТекущиеДанные);
	
	ОповещениеОВыборе = Новый ОписаниеОповещения("ДобавитьПолеНастройкиЗавершение",
												 ЭтотОбъект,
												 Новый Структура("МестоПоиска", МестоПоиска));
	РеквизитыДляВыбора.ПоказатьОтметкуЭлементов(ОповещениеОВыборе);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	АдресХранилища = ПодготовитьНастройки(ВладелецФормы.УникальныйИдентификатор);
	Закрыть(АдресХранилища);
КонецПроцедуры

&НаКлиенте
Процедура УдаляемыеОбъекты(Команда)
	ОткрытьФорму("РегистрСведений.УдаляемыеОбъекты.ФормаСписка");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция РеквизитыДляВыбора(РеквизитыМетаданных,Знач ТекущиеДанные)
	Результат = РеквизитыМетаданных.Скопировать();
	
	РодительЭлемента = ТекущиеДанные.ПолучитьРодителя();
	Если РодительЭлемента = Неопределено Тогда
		РодительЭлемента = ТекущиеДанные;
	КонецЕсли;
	
	Для Каждого ВыбранныйРеквизит Из РодительЭлемента.ПолучитьЭлементы() Цикл
		РеквизитСписка = Результат.НайтиПоЗначению(ВыбранныйРеквизит.МестоПоискаРеквизит);
		
		Если РеквизитСписка <> Неопределено Тогда
			РеквизитСписка.Пометка = Истина;			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Параметры:
//   Настройки - см. НастройкиИзДанныхФормы
//
&НаСервере
Процедура ЗагрузитьНастройки(Настройки)
	ОбычноеУдаление = 0;
	Если Настройки.РежимУдаления = "Монопольный" Тогда
		МонопольноеУдаление = 1;
	ИначеЕсли Настройки.РежимУдаления = "Упрощенный" Тогда
		БезопасноеУдаление = 1;
	Иначе
		ОбычноеУдаление = 1;
	КонецЕсли;
	
	ВыбранныеРеквизиты = Настройки.ВыбранныеРеквизиты;
	ВыбранныеРеквизиты.Сортировать("Метаданные");
	
	ДеревоНастроек = РеквизитФормыВЗначение("НастройкиОтображенияОбъектов");
	
	ТекущиеМетаданные = "";
	МестоПоиска = Неопределено;
	КартинкаПапка = БиблиотекаКартинок.Папка;
	КартинкаРеквизит = БиблиотекаКартинок.Реквизит;
	Для Каждого МестоПоискаРеквизит Из ВыбранныеРеквизиты Цикл
		Если ТекущиеМетаданные <> МестоПоискаРеквизит.Метаданные Тогда
			МестоПоиска = ДеревоНастроек.Строки.Добавить();
			МестоПоиска.МестоПоискаРеквизитПредставление = Метаданные.НайтиПоПолномуИмени(
				МестоПоискаРеквизит.Метаданные).Представление();
			МестоПоиска.Картинка = КартинкаПапка;
			МестоПоиска.МестоПоискаРеквизит = МестоПоискаРеквизит.Метаданные;
			ТекущиеМетаданные = МестоПоискаРеквизит.Метаданные;
		КонецЕсли;

		Реквизит = МестоПоиска.Строки.Добавить();
		Реквизит.МестоПоискаРеквизитПредставление = МестоПоискаРеквизит.Представление;
		Реквизит.МестоПоискаРеквизит = МестоПоискаРеквизит.Реквизит;
		Реквизит.Картинка = КартинкаРеквизит;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоНастроек, "НастройкиОтображенияОбъектов");
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыМетаданных(Знач ОбъектМетаданных)
	Результат = Новый СписокЗначений;

	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных);
	Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		Результат.Добавить(Реквизит.Имя, Реквизит.Синоним);
	КонецЦикла;

	Возврат Результат;
КонецФункции

&НаСервере
Процедура ДобавитьПолеНастройкиЗавершениеСервер(Результат, ДополнительныеПараметры)

	ДеревоМестПоиска = РеквизитФормыВЗначение("НастройкиОтображенияОбъектов");

	ИдентификаторМестаПоиска = ДополнительныеПараметры.МестоПоиска;
	Фильтр = Новый Структура("МестоПоискаРеквизит", ИдентификаторМестаПоиска);
	ПодгруппаМестаПоиска = ДеревоМестПоиска.Строки.НайтиСтроки(Фильтр)[0];
	ПодгруппаМестаПоиска.Строки.Очистить();
	Картинка = БиблиотекаКартинок.Реквизит;
	Для Каждого Элемент Из Результат Цикл

		Если Элемент.Пометка Тогда
			МестоПоиска = ПодгруппаМестаПоиска.Строки.Добавить();
			МестоПоиска.МестоПоискаРеквизит = Элемент.Значение;
			МестоПоиска.МестоПоискаРеквизитПредставление = Элемент.Представление;
			МестоПоиска.Картинка = Картинка;
		КонецЕсли;

	КонецЦикла;

	ЗначениеВРеквизитФормы(ДеревоМестПоиска, "НастройкиОтображенияОбъектов");
КонецПроцедуры

// Возвращаемое значение:
//   Структура:
//   * РежимУдаления - Строка
//   * ВыбранныеРеквизиты - ТаблицаЗначений:
//     ** Метаданные - Строка
//     ** Реквизит - Строка
//     ** Представление - Строка
//
&НаСервере
Функция НастройкиИзДанныхФормы()
	Настройки = Новый Структура;
	Настройки.Вставить("ВыбранныеРеквизиты");
	Настройки.Вставить("РежимУдаления");
	
	Если БезопасноеУдаление > 0 Тогда
		Настройки.РежимУдаления = "Упрощенный";
	ИначеЕсли МонопольноеУдаление > 0 Тогда 
		Настройки.РежимУдаления = "Монопольный";
	Иначе	
		Настройки.РежимУдаления = "Стандартный";
	КонецЕсли;
	
	ВыбранныеРеквизиты = Новый ТаблицаЗначений;
	ВыбранныеРеквизиты.Колонки.Добавить("Метаданные");
	ВыбранныеРеквизиты.Колонки.Добавить("Реквизит");
	ВыбранныеРеквизиты.Колонки.Добавить("Представление");
	
	ДеревоРеквизитов = РеквизитФормыВЗначение("НастройкиОтображенияОбъектов");
	Для Каждого СтрокаМетаданных Из ДеревоРеквизитов.Строки Цикл
		ОбъектМетаданных = СтрокаМетаданных.МестоПоискаРеквизит;
		Для Каждого Элемент Из СтрокаМетаданных.Строки Цикл
			Реквизит = ВыбранныеРеквизиты.Добавить();
			Реквизит.Метаданные = ОбъектМетаданных;
			Реквизит.Представление = Элемент.МестоПоискаРеквизитПредставление;
			Реквизит.Реквизит = Элемент.МестоПоискаРеквизит;
		КонецЦикла;	
	КонецЦикла;
	
	Настройки.ВыбранныеРеквизиты = ВыбранныеРеквизиты;
	
	Возврат Настройки;
КонецФункции

&НаСервере
Функция ПодготовитьНастройки(УникальныйИдентификатор)
	Возврат ПоместитьВоВременноеХранилище(НастройкиИзДанныхФормы(),
		УникальныйИдентификатор); 
КонецФункции

&НаКлиенте
Процедура ДобавитьНастройкуПродолжение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДобавитьНастройкуПродолжениеСервер(Результат);
КонецПроцедуры

&НаСервере
Процедура ДобавитьНастройкуПродолжениеСервер(Результат)
	ДеревоМестПоиска = РеквизитФормыВЗначение("НастройкиОтображенияОбъектов");

	Картинка = БиблиотекаКартинок.Папка; 
	Для Каждого Элемент Из Результат Цикл
		Фильтр = Новый Структура("МестоПоискаРеквизит", Элемент.Значение);

		Если ДеревоМестПоиска.Строки.НайтиСтроки(Фильтр).Количество() = 0 Тогда
			МестоПоиска = ДеревоМестПоиска.Строки.Добавить();
			МестоПоиска.МестоПоискаРеквизит = Элемент.Значение;
			МестоПоиска.МестоПоискаРеквизитПредставление = Элемент.Представление;
			МестоПоиска.Картинка = Картинка;
		КонецЕсли;
	КонецЦикла;

	ЗначениеВРеквизитФормы(ДеревоМестПоиска, "НастройкиОтображенияОбъектов");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПолеНастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ДобавитьПолеНастройкиЗавершениеСервер(Результат, ДополнительныеПараметры);	
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.РазвернутьУзлыДерева(ЭтотОбъект, "НастройкиОтображенияОбъектов");
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСостояниеФормыПоНастройкамРегламентногоЗадания(Форма)
	Форма.Элементы.УдалениеПомеченныхНастроитьРасписание.Доступность =  Форма.АвтоматическиУдалятьПомеченныеОбъекты;
	Форма.Элементы.УдалениеПомеченныхПредставлениеРасписания.Видимость = Форма.АвтоматическиУдалятьПомеченныеОбъекты;
	
	Если Форма.АвтоматическиУдалятьПомеченныеОбъекты Тогда
		Расписание = Новый РасписаниеРегламентногоЗадания;
		ЗаполнитьЗначенияСвойств(Расписание, Форма.УдалениеПомеченныхРасписание);
		РасписаниеПредставление = Строка(Расписание);
		Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
	Иначе
		Представление = НСтр("ru = '<Отключено>'");
	КонецЕсли;
	
	Форма.Элементы.УдалениеПомеченныхПредставлениеРасписания.Заголовок = Представление;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРежим(Режим)
	ОбычноеУдаление = 0;
	БезопасноеУдаление = 0;
	МонопольноеУдаление = 0;
	ЭтотОбъект[Режим] = 1;
КонецПроцедуры

&НаКлиенте
Процедура НачатьПроверкаБлокировкиУдаляемыхОбъектов()

	Оповещение = Новый ОписаниеОповещения("ЗавершитьПроверкаБлокировкиУдаляемыхОбъектов", ЭтотОбъект);
	ДлительнаяОперация = НачатьПроверкаБлокировкиУдаляемыхОбъектовСервер();
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект));

КонецПроцедуры

&НаСервере
Функция НачатьПроверкаБлокировкиУдаляемыхОбъектовСервер()

	ПараметрыФоновогоЗадания = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(
		ПараметрыФоновогоЗадания, 
		"УдалениеПомеченныхОбъектовСлужебный.ПроверкаАктивностиСеансаУдаленияОбъектов");

КонецФункции

&НаКлиенте
Процедура ЗавершитьПроверкаБлокировкиУдаляемыхОбъектов(Результат, ДополнительныеПараметры) Экспорт
	ЗавершитьПроверкаБлокировкиУдаляемыхОбъектовСервер();
КонецПроцедуры

&НаСервере
Процедура ЗавершитьПроверкаБлокировкиУдаляемыхОбъектовСервер()
	Элементы.УдаляемыеОбъекты.Доступность = Истина;
	Элементы.УдаляемыеОбъекты.Картинка = БиблиотекаКартинок.ВосклицательныйЗнакКрасный;
КонецПроцедуры

#КонецОбласти

