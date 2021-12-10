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
	
	УстановитьУсловноеОформление();
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиВМоделиСервиса.ПриСозданииАвтономногоРабочегоМеста();
	
	ОбменДаннымиВМоделиСервисаПереопределяемый.ПриСозданииАвтономногоРабочегоМеста();
	
	ИмяПланаОбмена = АвтономнаяРаботаСлужебный.ПланОбменаАвтономнойРаботы();
	
	// получаем значения по умолчанию для плана обмена	
	НастройкаОтборовНаУзле = ОбменДаннымиСервер.НастройкаОтборовНаУзле(ИмяПланаОбмена, "");
	
	Элементы.ОписаниеОграниченийПередачиДанных.Заголовок = ОписаниеОграниченийПередачиДанных(ИмяПланаОбмена, НастройкаОтборовНаУзле);
	
	ИнструкцияПоНастройкеАвтономногоРабочегоМеста = АвтономнаяРаботаСлужебный.ТекстИнструкцииИзМакета("ИнструкцияПоНастройкеАРМ");
	
	Элементы.ПоясняющаяНадписьОВерсииПлатформы.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для автономной работы на Вашем компьютере должна быть установлена
		|платформа ""1С:Предприятие"" версии %1.'"),
		ОбменДаннымиВМоделиСервиса.ТребуемаяВерсияПлатформы());
	
	Объект.НаименованиеАвтономногоРабочегоМеста = АвтономнаяРаботаСлужебный.СформироватьНаименованиеАвтономногоРабочегоМестаПоУмолчанию();
	
	// Устанавливаем текущую таблицу переходов
	СценарийСозданияАвтономногоРабочегоМеста();
	
	ЗакрытьФормуБезусловно = Ложь;
	
	СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста = АвтономнаяРаботаСлужебный.СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста();
	
	ПоддерживаетсяПередачаБольшихФайлов = АвтономнаяРаботаСлужебный.ПоддерживаетсяПередачаБольшихФайлов();
	
	// Настройка прав пользователей на выполнение синхронизации данных
	
	Элементы.НастройкаПравПользователей.Видимость = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		
		ПользователиСинхронизации.Загрузить(ПользователиСинхронизации());
		
		Элементы.НастройкаПравПользователей.Видимость = ПользователиСинхронизации.Количество() > 1;
		
	КонецЕсли;
	
	// Подсказка о тонком клиенте
	АдресИнструкцииПоНастройкеТонкогоКлиента = ОбменДаннымиВМоделиСервиса.АдресИнструкцииПоНастройкеТонкогоКлиента();
	Если ПустаяСтрока(АдресИнструкцииПоНастройкеТонкогоКлиента) Тогда
		Элементы.ЗагрузитьНачальныйОбразНаКомпьютерПользователя.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Объект.URLВебСервиса = АдресПриложенияВИнтернете();
	
	// Позиционируемся на первом шаге помощника
	ПорядковыйНомерПерехода = 1;	
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.Окончание Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтменитьСозданиеАвтономногоРабочегоМеста", ЭтотОбъект);
	
	ТекстПредупреждения = НСтр("ru = 'Отменить создание автономного рабочего места?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно", ОписаниеОповещения);
	
КонецПроцедуры

// Обработчики ожидания

&НаКлиенте
Процедура ОбработчикОжиданияДлительнойОперации()
	
	Попытка
		
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			
			ДлительнаяОперация = Ложь;
			ДлительнаяОперацияЗавершена = Истина;
			ПерейтиДалее();
			
		Иначе
			ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		КонецЕсли;
		
	Исключение
		ДлительнаяОперация = Ложь;
		ПерейтиНаСтраницуОшибки();
		ПоказатьПредупреждение(, НСтр("ru = 'Не удалось выполнить операцию.'"));
		
		ТекстОшибкиВыполнения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	
		ЗаписатьОшибкуВЖурналРегистрации(
			ТекстОшибкиВыполнения,
			СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияПоНастройкеАвтономногоРабочегоМестаДокументСформирован(Элемент)
	
	// Видимость команды печати
	Если Не Элемент.Документ.queryCommandSupported("Print") Тогда
		Элементы.ИнструкцияПоНастройкеАвтономногоРабочегоМестаПечатьИнструкции.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Поставляемая часть

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ЗакрытьФормуБезусловно = Истина;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

// Переопределяемая часть

&НаКлиенте
Процедура НастроитьОграниченияПередачиДанных(Команда)
	
	ИмяФормыНастройкиУзла = "ПланОбмена.[ИмяПланаОбмена].Форма.ФормаНастройкиУзла";
	ИмяФормыНастройкиУзла = СтрЗаменить(ИмяФормыНастройкиУзла, "[ИмяПланаОбмена]", ИмяПланаОбмена);
	
	ПараметрыФормы = Новый Структура("НастройкаОтборовНаУзле, ВерсияКорреспондента", НастройкаОтборовНаУзле, "");
	Обработчик = Новый ОписаниеОповещения("НастроитьОграниченияПередачиДанныхЗавершение", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ОткрытьФорму(ИмяФормыНастройкиУзла, ПараметрыФормы, ЭтотОбъект,,,,Обработчик, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОграниченияПередачиДанныхЗавершение(РезультатОткрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатОткрытия <> Неопределено Тогда
		
		Для Каждого НастройкаОтбора Из НастройкаОтборовНаУзле Цикл
			
			НастройкаОтборовНаУзле[НастройкаОтбора.Ключ] = РезультатОткрытия[НастройкаОтбора.Ключ];
			
		КонецЦикла;
		
		Элементы.ОписаниеОграниченийПередачиДанных.Заголовок = ОписаниеОграниченийПередачиДанных(ИмяПланаОбмена, НастройкаОтборовНаУзле);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНачальныйОбразНаКомпьютерПользователя(Команда)
	
	Если ПоддерживаетсяПередачаБольшихФайлов Тогда
		ДанныеФайла = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаНачальногоОбраза);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИдентификаторФайлаПакетаУстановки", ДанныеФайла.ИдентификаторФайлаПакетаУстановки);
		
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения(
			"ЗагрузитьНачальныйОбразНаКомпьютерПользователяЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		ИмяМодуляФайлыБТСКлиент = "ФайлыБТСКлиент";	
		МодульФайлыБТСКлиент    = ОбщегоНазначенияКлиент.ОбщийМодуль(ИмяМодуляФайлыБТСКлиент);
		
		ПараметрыПолученияФайла = МодульФайлыБТСКлиент.ПараметрыПолученияФайла();
		ПараметрыПолученияФайла.ИмяФайлаИлиАдрес = ДанныеФайла.ИмяФайлаИлиАдрес;
		ПараметрыПолученияФайла.ПутьФайлаWindows = ДанныеФайла.ПутьФайлаWindows;
		ПараметрыПолученияФайла.ПутьФайлаLinux   = ДанныеФайла.ПутьФайлаLinux;
		ПараметрыПолученияФайла.БлокируемаяФорма = ЭтотОбъект;
		
		ПараметрыПолученияФайла.ЗаголовокДиалогаСохранения = НСтр("ru = 'Сохранение пакета установки'");
		ПараметрыПолученияФайла.ФильтрДиалогаСохранения    = НСтр("ru = 'Архивы ZIP (*.zip)|*.zip'");
		ПараметрыПолученияФайла.ИмяФайлаДиалогаСохранения  = ИмяФайлаПакетаУстановки;
		
		ПараметрыПолученияФайла.ОписаниеОповещенияОЗавершении = ОписаниеОповещенияОЗавершении;
		
		МодульФайлыБТСКлиент.ПолучитьФайлИнтерактивно(ПараметрыПолученияФайла);
		
	Иначе
		ПолучаемыйФайл = Новый Структура;
		ПолучаемыйФайл.Вставить("Имя",      ИмяФайлаПакетаУстановки);
		ПолучаемыйФайл.Вставить("Хранение", АдресВременногоХранилищаНачальногоОбраза);
		
		ПараметрыДиалога = Новый Структура;
		ПараметрыДиалога.Вставить("Фильтр", НСтр("ru = 'Архивы ZIP (*.zip)|*.zip'"));
		
		ОбменДаннымиКлиент.ВыбратьИСохранитьФайлНаКлиенте(ПолучаемыйФайл, ПараметрыДиалога);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакета", "КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие");
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Как установить или обновить версию платформы 1С:Предприятие'"));
	
	ОткрытьФорму("Обработка.ПомощникСозданияАвтономногоРабочегоМеста.Форма.ДополнительноеОписание", ПараметрыФормы, ЭтотОбъект, "КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие");
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьИнструкции(Команда)
	
	Элементы.ИнструкцияПоНастройкеАвтономногоРабочегоМеста.Документ.execCommand("Print");
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИнструкциюКак(Команда)
	
	ПолучаемыйФайл = Новый Структура;
	ПолучаемыйФайл.Вставить("Имя",      НСтр("ru = 'Инструкция по настройке автономного рабочего места.html'"));
	ПолучаемыйФайл.Вставить("Хранение", ПолучитьМакет());
	
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Фильтр", НСтр("ru = 'Веб-страница, только HTML (*.html)|*.html'"));
	
	ОбменДаннымиКлиент.ВыбратьИСохранитьФайлНаКлиенте(ПолучаемыйФайл, ПараметрыДиалога);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьНачальныйОбразНаКомпьютерПользователяЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		УдалитьФайлПакетаУстановки(ДополнительныеПараметры.ИдентификаторФайлаПакетаУстановки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьФайлПакетаУстановки(ИдентификаторФайлаПакетаУстановки)
	
	Попытка
		ИмяФайлаПакетаУстановки = ОбменДаннымиСервер.ПолучитьФайлИзХранилища(ИдентификаторФайлаПакетаУстановки);
		ФайлПакетаУстановки = Новый Файл(ИмяФайлаПакетаУстановки);
		Если ФайлПакетаУстановки.Существует() Тогда
			УдалитьФайлы(ИмяФайлаПакетаУстановки);
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации(
			АвтономнаяРаботаСлужебный.СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПользователиРазрешитьСинхронизациюДанных.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПользователиСинхронизации.СинхронизацияДанныхРазрешена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНачальныйОбразНаКомпьютерПользователяРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "АдресИнструкцииПоНастройкеТонкогоКлиента" Тогда
		СтандартнаяОбработка = Ложь;
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресИнструкцииПоНастройкеТонкогоКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РасширенияИзменяющиеСтруктуруДанных()
	
	РасширенияИзменяющиеСтруктуруДанных = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	РасширенияОбласти = РасширенияКонфигурации.Получить();
	
	Для Каждого Расширение Из РасширенияОбласти Цикл
		
		Если НЕ Расширение.ИзменяетСтруктуруДанных() Тогда
			Продолжить;
		КонецЕсли;
		
		РасширенияИзменяющиеСтруктуруДанных.Добавить(Расширение.Синоним);
		
	КонецЦикла;
	
	Возврат РасширенияИзменяющиеСтруктуруДанных;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Поставляемая часть

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	// Устанавливаем текущую кнопку по умолчанию
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеДалее
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
			И Не СтрокаПерехода.ДлительнаяОперация Тогда
			
			ИмяПроцедуры = "[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
			
			Отказ = Ложь;
			
			РезультатВычисления = Вычислить(ИмяПроцедуры);
			
			Если Отказ Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеНазад
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
			И Не СтрокаПерехода.ДлительнаяОперация Тогда
			
			ИмяПроцедуры = "[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
			
			Отказ = Ложь;
			
			РезультатВычисления = Вычислить(ИмяПроцедуры);
			
			Если Отказ Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		РезультатВычисления = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			ЭтоПереходДалее = Истина;	
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ОбработкаДлительнойОперации
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		РезультатВычисления = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			ПерейтиНаСтраницуОшибки();
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТаблицаПереходовНоваяСтрока(ИмяОсновнойСтраницы, ИмяСтраницыНавигации, ИмяСтраницыДекорации = "")
	
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ТаблицаПереходов.Количество();
	НоваяСтрока.ИмяОсновнойСтраницы     = ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыДекорации    = ИмяСтраницыДекорации;
	НоваяСтрока.ИмяСтраницыНавигации    = ИмяСтраницыНавигации;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И СтрНайти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ПолучитьМакет()
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ИнструкцияПоНастройкеАвтономногоРабочегоМеста);
	ТекстовыйДокумент.Записать(ИмяВременногоФайла);
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОтменитьСозданиеАвтономногоРабочегоМеста(Результат, ДополнительныеПараметры) Экспорт
	
	Если Объект.АвтономноеРабочееМесто <> Неопределено Тогда
		ОбменДаннымиВызовСервера.УдалитьНастройкуСинхронизации(Объект.АвтономноеРабочееМесто);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Служебные процедуры и функции

&НаСервере
Процедура СоздатьНачальныйОбразАвтономногоРабочегоМестаНаСервере(Отказ)
	
	Отбор = Новый Структура("СинхронизацияДанныхРазрешена, РазрешитьСинхронизациюДанных", Ложь, Истина);
	ВыбранныеПользователиСинхронизации = ПользователиСинхронизации.Выгрузить(Отбор, "Пользователь").ВыгрузитьКолонку("Пользователь");
	
	КонтекстПомощника = Новый Структура(
		"URLВебСервиса, НаименованиеАвтономногоРабочегоМеста, АвтономноеРабочееМесто");
	ЗаполнитьЗначенияСвойств(КонтекстПомощника, Объект);
	
	КонтекстПомощника.Вставить("НастройкаОтборовНаУзле", НастройкаОтборовНаУзле);
	КонтекстПомощника.Вставить("ВыбранныеПользователиСинхронизации", ВыбранныеПользователиСинхронизации);
	
	Попытка
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Создание начального образа автономного рабочего места'");
		ПараметрыВыполнения.ДополнительныйРезультат = Истина;
		ПараметрыВыполнения.ЗапуститьНеВФоне = Ложь;
		ПараметрыВыполнения.ЗапуститьВФоне   = Истина;
		
		ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(
			"АвтономнаяРаботаСлужебный.СоздатьНачальныйОбразАвтономногоРабочегоМеста",
			КонтекстПомощника,
			ПараметрыВыполнения);
		
		АдресВременногоХранилищаНачальногоОбраза           = ФоновоеЗадание.АдресРезультата;
		АдресВременногоХранилищаИнформацииОПакетеУстановки = ФоновоеЗадание.АдресДополнительногоРезультата;
		
		Если ФоновоеЗадание.Статус = "Выполняется" Тогда
			ДлительнаяОперация = Истина;
			ИдентификаторЗадания = ФоновоеЗадание.ИдентификаторЗадания;
		ИначеЕсли ФоновоеЗадание.Статус = "Выполнено" Тогда
			ИнформацияОПакетеУстановки = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаИнформацииОПакетеУстановки);
			РазмерФайлаПакетаУстановки = ИнформацияОПакетеУстановки.РазмерФайлаПакетаУстановки;
			ИмяФайлаПакетаУстановки    = ИнформацияОПакетеУстановки.ИмяФайлаПакетаУстановки;
		Иначе
			СообщениеОбОшибке = ФоновоеЗадание.КраткоеПредставлениеОшибки;
			Если ЗначениеЗаполнено(ФоновоеЗадание.ПодробноеПредставлениеОшибки) Тогда
				СообщениеОбОшибке = ФоновоеЗадание.ПодробноеПредставлениеОшибки;
			КонецЕсли;
			
			ВызватьИсключение СообщениеОбОшибке;
		КонецЕсли;
		
	Исключение
		Отказ = Истина;
		
		ТекстОшибкиВыполнения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписатьОшибкуВЖурналРегистрации(
			ТекстОшибкиВыполнения,
			СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОписаниеОграниченийПередачиДанных(Знач ИмяПланаОбмена, НастройкаОтборовНаУзле)
	
	Возврат ОбменДаннымиСервер.ОписаниеОграниченийПередачиДанных(ИмяПланаОбмена, НастройкаОтборовНаУзле, "");
	
КонецФункции

&НаКлиенте
Функция АдресПриложенияВИнтернете()
	
	ПараметрыСоединения = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(СтрокаСоединенияИнформационнойБазы());
	
	Если Не ПараметрыСоединения.Свойство("ws") Тогда
		ВызватьИсключение НСтр("ru = 'Создать автономное рабочее место можно только в режиме веб-клиента.'");
	КонецЕсли;
	
	Возврат ПараметрыСоединения.ws;
КонецФункции

&НаКлиенте
Процедура ПерейтиДалее()
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуОшибки()
	
	// Устанавливаем ПорядковыйНомерПерехода для того, что бы не выполнялись обработчики предыдущего шага
	ПорядковыйНомерПерехода = ТаблицаПереходов.Количество();
	УстановитьПорядковыйНомерПерехода(ТаблицаПереходов.Количество());
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(СтрокаСообщенияОбОшибке, Событие)
	
	ЗаписьЖурналаРегистрации(Событие, УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ПользователиСинхронизации()
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Пользователь"); // Тип: СправочникСсылка.Пользователи
	Результат.Колонки.Добавить("СинхронизацияДанныхРазрешена", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("РазрешитьСинхронизациюДанных", Новый ОписаниеТипов("Булево"));
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Пользователь,
	|	Пользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.ПометкаУдаления
	|	И НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.Служебный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователи.Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.ИдентификаторПользователяИБ) Тогда
			
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Выборка.ИдентификаторПользователяИБ);
			
			Если ПользовательИБ <> Неопределено Тогда
				
				НастройкиПользователя = Результат.Добавить();
				НастройкиПользователя.Пользователь = Выборка.Пользователь;
				НастройкиПользователя.СинхронизацияДанныхРазрешена = ОбменДаннымиСервер.СинхронизацияДанныхРазрешена(ПользовательИБ);
				НастройкиПользователя.РазрешитьСинхронизациюДанных = НастройкиПользователя.СинхронизацияДанныхРазрешена;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Обработчики событий переходов

&НаКлиенте
Функция Подключаемый_НастройкаВыгрузки_ПриПереходеДалее(Отказ)
	
	Если ПустаяСтрока(Объект.НаименованиеАвтономногоРабочегоМеста) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано наименование автономного рабочего места.'"),
			, "Объект.НаименованиеАвтономногоРабочегоМеста", , Отказ);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ОжиданиеСозданияНачальногоОбраза_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	ДлительнаяОперация = Ложь;
	ДлительнаяОперацияЗавершена = Ложь;
	ИдентификаторЗадания = Неопределено;
	
	СоздатьНачальныйОбразАвтономногоРабочегоМестаНаСервере(Отказ);
	
	Если Отказ Тогда
		
		//
		
	ИначеЕсли Не ДлительнаяОперация Тогда
		
		Оповестить("Создание_АвтономноеРабочееМесто");
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ОжиданиеСозданияНачальногоОбразаДлительнаяОперация_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Если ДлительнаяОперация Тогда
		
		ПерейтиДалее = Ложь;
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_ОжиданиеСозданияНачальногоОбразаДлительнаяОперацияОкончание_ОбработкаДлительнойОперации(Отказ, ПерейтиДалее)
	
	Если ДлительнаяОперацияЗавершена Тогда
		
		ИнформацияОПакетеУстановки = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаИнформацииОПакетеУстановки);
		РазмерФайлаПакетаУстановки = ИнформацияОПакетеУстановки.РазмерФайлаПакетаУстановки;
		ИмяФайлаПакетаУстановки    = ИнформацияОПакетеУстановки.ИмяФайлаПакетаУстановки;
		
		Оповестить("Создание_АвтономноеРабочееМесто");
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_Окончание_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	ЗаголовокЭлемента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 (%2 МБ)'"),
		ИмяФайлаПакетаУстановки,
		Формат(Окр(РазмерФайлаПакетаУстановки / (1024 * 1024), 1), "ЧДЦ=1; ЧГ=3,0"));
	Элементы.ЗагрузитьНачальныйОбразНаКомпьютерПользователя.Заголовок = ЗаголовокЭлемента;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_НаличиеРасширенийИзменяющихСтруктуруДанных_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Расширения = РасширенияИзменяющиеСтруктуруДанных();
	ПропуститьСтраницу = Расширения.Количество() = 0;
	
	РасширенияИзменяющиеСтруктуруДанных.ЗагрузитьЗначения(Расширения);
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Инициализация переходов помощника

&НаСервере
Процедура СценарийСозданияАвтономногоРабочегоМеста()
	
	ТаблицаПереходов.Очистить();
	
	НовыйПереход = ТаблицаПереходовНоваяСтрока("НаличиеРасширенийИзменяющихСтруктуруДанных", "СтраницаНавигацииОкончание");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "Подключаемый_НаличиеРасширенийИзменяющихСтруктуруДанных_ПриОткрытии";
	
	НовыйПереход = ТаблицаПереходовНоваяСтрока("Начало", "СтраницаНавигацииНачало");
	
	НовыйПереход = ТаблицаПереходовНоваяСтрока("НастройкаВыгрузки", "СтраницаНавигацииПродолжение");
	НовыйПереход.ИмяОбработчикаПриПереходеДалее = "Подключаемый_НастройкаВыгрузки_ПриПереходеДалее";
	
	НовыйПереход = ТаблицаПереходовНоваяСтрока("ОжиданиеСозданияНачальногоОбраза", "СтраницаНавигацииОжидание");
	НовыйПереход.ДлительнаяОперация = Истина;
	НовыйПереход.ИмяОбработчикаДлительнойОперации = "Подключаемый_ОжиданиеСозданияНачальногоОбраза_ОбработкаДлительнойОперации";
	
	НовыйПереход = ТаблицаПереходовНоваяСтрока("ОжиданиеСозданияНачальногоОбраза", "СтраницаНавигацииОжидание");
	НовыйПереход.ДлительнаяОперация = Истина;
	НовыйПереход.ИмяОбработчикаДлительнойОперации = "Подключаемый_ОжиданиеСозданияНачальногоОбразаДлительнаяОперация_ОбработкаДлительнойОперации";
	
	НовыйПереход = ТаблицаПереходовНоваяСтрока("ОжиданиеСозданияНачальногоОбраза", "СтраницаНавигацииОжидание");
	НовыйПереход.ДлительнаяОперация = Истина;
	НовыйПереход.ИмяОбработчикаДлительнойОперации = "Подключаемый_ОжиданиеСозданияНачальногоОбразаДлительнаяОперацияОкончание_ОбработкаДлительнойОперации";
	
	НовыйПереход = ТаблицаПереходовНоваяСтрока("Окончание", "СтраницаНавигацииОкончание");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "Подключаемый_Окончание_ПриОткрытии";
	
	НовыйПереход = ТаблицаПереходовНоваяСтрока("ОшибкаВыполнения", "СтраницаНавигацииОкончание");
	
КонецПроцедуры

#КонецОбласти
