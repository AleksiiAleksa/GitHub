﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// В форме допустимо использовать только метода программного интерфейса.
// Использование методов служебного программного интерфейса, а также служебных методов не допускается.
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПользовательскиеМакетыПечати) Тогда
		Элементы.ЗадатьДействиеПриВыбореМакетаПечатнойФормы.Видимость = Ложь;
	КонецЕсли;
	
	ЭтоВебКлиент = ОбщегоНазначения.ЭтоВебКлиент();
	
	ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
	
	ПредлагатьПерейтиНаСайтПриЗапуске = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбщиеНастройкиПользователя", 
		"ПредлагатьПерейтиНаСайтПриЗапуске",
		Ложь);

	// СтандартныеПодсистемы.БазоваяФункциональность
	Если Не ЭтоВебКлиент Тогда
		Элементы.РаботаВВебКлиенте.Видимость = Ложь;
	КонецЕсли;
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы = СтандартныеПодсистемыСервер.ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы();
	
	// Определение текущей настройки рабочей даты.
	ЗначениеРабочейДаты = ОбщегоНазначения.РабочаяДатаПользователя();
	Если ЗначениеЗаполнено(ЗначениеРабочейДаты) Тогда
		ИспользоватьТекущуюДатуКомпьютера = 0;
	Иначе
		ИспользоватьТекущуюДатуКомпьютера = 1;
		Элементы.ЗначениеРабочейДаты.Доступность = Ложь;
	КонецЕсли;
	
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	Если ПравоДоступа("Просмотр", Метаданные.НайтиПоТипу(ТипЗнч(АвторизованныйПользователь))) Тогда
		Элементы.СведенияОПользователе.Заголовок = АвторизованныйПользователь;
	Иначе
		Элементы.ГруппаУчетнаяЗапись.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.РаботаСФайлами
	НастройкиРаботыСФайлами = РаботаСФайлами.НастройкиРаботыСФайлами();
	СпрашиватьРежимРедактированияПриОткрытииФайла = НастройкиРаботыСФайлами.СпрашиватьРежимРедактированияПриОткрытииФайла;
	
	Если НастройкиРаботыСФайлами.ДействиеПоДвойномуЩелчкуМыши = "ОткрыватьФайл" Тогда
		ДействиеПоДвойномуЩелчкуМыши = Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл;
		Элементы.СпрашиватьРежимРедактированияПриОткрытииФайла.Доступность = Истина;
	Иначе
		ДействиеПоДвойномуЩелчкуМыши = Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьКарточку;
		Элементы.СпрашиватьРежимРедактированияПриОткрытииФайла.Доступность = Ложь;
	КонецЕсли;
	
	Если НастройкиРаботыСФайлами.СпособСравненияВерсийФайлов = "MicrosoftOfficeWord" Тогда
		СпособСравненияВерсийФайлов = Перечисления.СпособыСравненияВерсийФайлов.MicrosoftOfficeWord;
	Иначе
		СпособСравненияВерсийФайлов = Перечисления.СпособыСравненияВерсийФайлов.OpenOfficeOrgWriter;
	КонецЕсли;
	
	ПоказыватьПодсказкиПриРедактированииФайлов = НастройкиРаботыСФайлами.ПоказыватьПодсказкиПриРедактированииФайлов;
	
	ПоказыватьИнформациюЧтоФайлНеБылИзменен = НастройкиРаботыСФайлами.ПоказыватьИнформациюЧтоФайлНеБылИзменен;
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = НастройкиРаботыСФайлами.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы;
	
	ПоказыватьКолонкуРазмер = НастройкиРаботыСФайлами.ПоказыватьКолонкуРазмер;
	
	// Заполнение настроек открытия файлов.
	СтрокаНастройки = НастройкиОткрытияФайлов.Добавить();
	СтрокаНастройки.ТипФайла = Перечисления.ТипыФайловДляВстроенногоРедактора.ТекстовыеФайлы;
	
	СтрокаНастройки.Расширение = НастройкиРаботыСФайлами.ТекстовыеФайлыРасширение;
	
	СтрокаНастройки.СпособОткрытия = НастройкиРаботыСФайлами.ТекстовыеФайлыСпособОткрытия;
	
	Если ЭтоВебКлиент Или Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		Элементы.НастройкаСканирования.Видимость = Ложь;
	КонецЕсли;
	
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ЭлектроннаяПодпись
	Элементы.НастройкиЭлектроннойПодписиИШифрования.Видимость =
		ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись
	
	Элементы.ГруппаИнтеграцияВызовОнлайнПоддержки.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОнлайнПоддержку");
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ЗаписатьИЗакрыть.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ПерсональнаяНастройкаПроксиСервера.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
#Если ВебКлиент Тогда
	ОбновитьГруппуРаботыВВебКлиенте();
#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница Главное

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(, АвторизованныйПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ПолучениеФайловИзИнтернетаКлиент.ОткрытьФормуПараметровПроксиСервера(Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуРаботыВВебКлиенте()
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьГруппуРаботыВВебКлиентеЗавершение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуРаботыВВебКлиентеЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(Подключено, Элементы.ГруппаРасширениеУстановлено, 
		Элементы.ГруппаРасширениеНеУстановлено);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТекущуюДатуКомпьютераПриИзменении(Элемент)
	
	Если ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДаты = '0001-01-01';
	Иначе
		ЗначениеРабочейДаты = ТекущаяДата();
	КонецЕсли;
	Элементы.ЗначениеРабочейДаты.Доступность = ИспользоватьТекущуюДатуКомпьютера = 0;
	Модифицированность = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница Органайзер

////////////////////////////////////////////////////////////////////////////////
// Страница Печать

&НаКлиенте
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
	
	УправлениеПечатьюКлиент.ЗадатьДействиеПриВыбореМакетаПечатнойФормы();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница РаботаСФайлами

&НаКлиенте
Процедура НастройкаРабочегоКаталога(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаРабочегоКаталогаПродолжение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения,, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСканирования(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЭлектроннойПодписиИШифрования(Команда)
	
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьНастройкиИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПоДвойномуЩелчкуМышиПриИзменении(Элемент)
	Элементы.СпрашиватьРежимРедактированияПриОткрытииФайла.Доступность = 
		(ДействиеПоДвойномуЩелчкуМыши = ПредопределенноеЗначение("Перечисление.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл"));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьНастройкиИЗакрытьФорму()
	
	Настройки = Новый Структура;
	Настройки.Вставить("НапоминатьОбУстановкеРасширенияРаботыСФайлами", НапоминатьОбУстановкеРасширенияРаботыСФайлами);
	Настройки.Вставить("ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", ЗапрашиватьПодтверждениеПриЗавершенииПрограммы);
	Настройки.Вставить("ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы", ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы);
	
	ПерсональныеНастройкиРаботыСФайлами = УстановитьНастройкиНаСервере(Настройки);
	Настройки.Вставить("ПерсональныеНастройкиРаботыСФайлами ", ПерсональныеНастройкиРаботыСФайлами);
	
	ОбщегоНазначенияКлиент.СохранитьПерсональныеНастройки(Настройки);
	
	ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Контекст) Экспорт
	СохранитьНастройкиИЗакрытьФорму();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение(ДополнительныеПараметры) Экспорт
	
	ОбновитьГруппуРаботыВВебКлиенте();
	
КонецПроцедуры

&НаСервере
Функция УстановитьНастройкиНаСервере(Настройки)
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	
	// Рабочая дата.
	Если ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДатыДляСохранения = '0001-01-01';
	Иначе
		ЗначениеРабочейДатыДляСохранения = ЗначениеРабочейДаты;
	КонецЕсли;
	ОбщегоНазначения.УстановитьРабочуюДатуПользователя(ЗначениеРабочейДатыДляСохранения);
	
	ОбщегоНазначения.СохранитьПерсональныеНастройки(Настройки);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.РаботаСФайлами
	НастройкиРаботыСФайлами = Новый Структура;
	НастройкиРаботыСФайлами.Вставить("ДействиеПоДвойномуЩелчкуМыши", ДействиеПоДвойномуЩелчкуМыши);
	НастройкиРаботыСФайлами.Вставить("СпрашиватьРежимРедактированияПриОткрытииФайла", СпрашиватьРежимРедактированияПриОткрытииФайла);
	НастройкиРаботыСФайлами.Вставить("ПоказыватьПодсказкиПриРедактированииФайлов", ПоказыватьПодсказкиПриРедактированииФайлов);
	НастройкиРаботыСФайлами.Вставить("ПоказыватьЗанятыеФайлыПриЗавершенииРаботы", ПоказыватьЗанятыеФайлыПриЗавершенииРаботы);
	НастройкиРаботыСФайлами.Вставить("ПоказыватьКолонкуРазмер", ПоказыватьКолонкуРазмер);
	НастройкиРаботыСФайлами.Вставить("ПоказыватьИнформациюЧтоФайлНеБылИзменен", ПоказыватьИнформациюЧтоФайлНеБылИзменен);
	НастройкиРаботыСФайлами.Вставить("СпособСравненияВерсийФайлов", СпособСравненияВерсийФайлов);
	
	Если НастройкиОткрытияФайлов.Количество() >= 1 Тогда
		НастройкиРаботыСФайлами.Вставить("ТекстовыеФайлыРасширение", НастройкиОткрытияФайлов[0].Расширение);
		НастройкиРаботыСФайлами.Вставить("ТекстовыеФайлыСпособОткрытия", НастройкиОткрытияФайлов[0].СпособОткрытия);
	КонецЕсли;
	
	РаботаСФайлами.СохранитьНастройкиРаботыСФайлами(НастройкиРаботыСФайлами);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	СохранитьСвойстваКоллекции("ОбщиеНастройкиПользователя", ЭтотОбъект,
		"ПредлагатьПерейтиНаСайтПриЗапуске");
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат РаботаСФайлами.НастройкиРаботыСФайлами();
	
КонецФункции

&НаСервере
Процедура СохранитьСвойстваКоллекции(КлючОбъекта, Коллекция, ИменаРеквизитов)
	СтруктураРеквизитов = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Коллекция);
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаРабочегоКаталогаПродолжение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Истина Тогда
		РаботаСФайламиКлиент.ОткрытьФормуНастройкиРабочегоКаталога();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
