﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ОстаткиСамокатов Приход
	Движения.ОстаткиСамокатов.Записывать = Истина;
	Движение = Движения.ОстаткиСамокатов.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Количество = 1;

	// регистр АрендаСамокатов Расход
	Движения.АрендаСамокатов.Записывать = Истина;
	Движение = Движения.АрендаСамокатов.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	Движение.Студент = Студент;
	Движение.Количество = 1;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
