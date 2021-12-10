﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьОбщиеНастройкиТранспорта(Команда)
	
	Отбор              = Новый Структура("КонечнаяТочкаКорреспондента", Запись.КонечнаяТочкаКорреспондента);
	ЗначенияЗаполнения = Новый Структура("КонечнаяТочкаКорреспондента", Запись.КонечнаяТочкаКорреспондента);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "НастройкиТранспортаОбменаОбластейДанных", ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
