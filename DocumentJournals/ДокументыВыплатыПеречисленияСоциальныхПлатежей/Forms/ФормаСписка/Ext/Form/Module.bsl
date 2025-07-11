﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияБКВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СПИСОК

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБККлиентСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура РаботникПриИзменении(Элемент)
	ИспользоватьОтборПоРаботнику = Истина;
	УстановитьОтборПоФизическомуЛицу();
КонецПроцедуры

// Возвращает массив всех документов, включенных в критерий отбора "ДокументыПоРаботникуОрганизации", в которых присутствует переданное физическое лицо
//
// Параметры:
//		ФизическоеЛицо - Ссылка на физическое лицо
//
// Возвращаемое значение:
//		МассивДокументов - Массив документов по физическому лицу
//
&НаСервереБезКонтекста
Функция ДокументыПоФизическомуЛицу(ФизическоеЛицо) Экспорт
	
	МассивДокументов = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КритерийОтбораДокументыСотрудников.Ссылка
	|ИЗ
	|	КритерийОтбора.ДокументыПоРаботникуОрганизации(&ФизическоеЛицо) КАК КритерийОтбораДокументыСотрудников";
	
	МассивДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат МассивДокументов;
	
КонецФункции

&НаКлиенте
Процедура УстановитьОтборПоФизическомуЛицу()
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,	
		"МассивДокументов",
		?(ИспользоватьОтборПоРаботнику, ДокументыПоФизическомуЛицу(Работник), Новый Массив),
		ИспользоватьОтборПоРаботнику);			
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоРаботникуПриИзменении(Элемент)
	УстановитьОтборПоФизическомуЛицу()
КонецПроцедуры

