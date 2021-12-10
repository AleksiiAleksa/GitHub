    
&НаКлиенте
Процедура ЗапросКPostgreSQL(Команда)
АДОСоединение = Новый COMОбъект("ADODB.CONNECTION");
АДОСоединение.Provider = "MSDASQL.1";
АДОСоединение.ConnectionString = "Driver={PostgreSQL Unicode};Server=Server1C;Port=5432;Database=demo_base;Uid=postgres;Pwd=1234;STMT=utf8";

Попытка
АДОСоединение.Open();
Исключение
Возврат;
КонецПопытки;

АДОНаборЗаписей = Новый COMОбъект("ADODB.RecordSet");
АДОКоманда = Новый COMОбъект("ADODB.Command");

Попытка
АДОКоманда.ActiveConnection = АДОСоединение;
АДОКоманда.CommandText = "SELECT * FROM ""public.v8users"";";

АДОНаборЗаписей = АДОКоманда.Execute();
Исключение
Возврат;
КонецПопытки;
КонецПроцедуры