﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДобавитьПредлагаемоеЗначениеИдентификатораВСписокВыбора();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ОбновитьПредлагаемоеЗначениеИдентификатора();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ДобавитьПредлагаемоеЗначениеИдентификатораВСписокВыбора()
	
	Элементы.Идентификатор.СписокВыбора[0].Значение = ОбщегоНазначенияБККлиентСервер.ПолучитьИдентификатор(Объект.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредлагаемоеЗначениеИдентификатора()
	
	Если Не Элементы.Идентификатор.ТолькоПросмотр Тогда
		Объект.Идентификатор = ОбщегоНазначенияБККлиентСервер.ПолучитьИдентификатор(Объект.Наименование);
	КонецЕсли;
	ДобавитьПредлагаемоеЗначениеИдентификатораВСписокВыбора();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Если Объект.Предопределенный Тогда 
		Элементы.Идентификатор.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры
