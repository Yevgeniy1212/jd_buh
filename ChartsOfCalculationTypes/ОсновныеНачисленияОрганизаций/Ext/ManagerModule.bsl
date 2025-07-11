﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВыбиратьВключаемыеНачисления") И Параметры.ВыбиратьВключаемыеНачисления Тогда
		
		СтандартнаяОбработка = Ложь;
		
		СтрокаПоиска = Неопределено;
		Параметры.Свойство("СтрокаПоиска", СтрокаПоиска);
		
		ТекстУсловия 	= "";
		
		Если СтрокаПоиска <> Неопределено Тогда 
			ТекстУсловия = "И ОсновныеНачисленияОрганизаций.Наименование ПОДОБНО &ШаблонНаименования ";
		КонецЕсли;
		
		Запрос = Новый Запрос;  		
		СписокСпособовРасчета = ПроведениеРасчетовСервер.ПолучитьСписокСпособовРасчетовОтОбратного();
		СписокСпособовРасчета.Добавить(Перечисления.СпособыРасчетаОплатыТруда.Процентом);
		
		Запрос.УстановитьПараметр("СпособРасчета", СписокСпособовРасчета);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОсновныеНачисленияОрганизаций.СпособРасчета,
		|	ОсновныеНачисленияОрганизаций.Ссылка,
		|	ОсновныеНачисленияОрганизаций.Наименование КАК Наименование,
		|	ОсновныеНачисленияОрганизаций.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	ПланВидовРасчета.ОсновныеНачисленияОрганизаций КАК ОсновныеНачисленияОрганизаций
		|ГДЕ
		|	НЕ ОсновныеНачисленияОрганизаций.СпособРасчета В (&СпособРасчета)
		|	" + ТекстУсловия + "
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
		
		Запрос.УстановитьПараметр("ШаблонНаименования", "%" + СтрокаПоиска + "%");
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ДанныеВыбора = Новый СписокЗначений();
		
		Пока Выборка.Следующий() Цикл 
			Если Выборка.ПометкаУдаления Тогда
				СтруктураЗначение = Новый Структура("Значение, ПометкаУдаления", Выборка.Ссылка, Выборка.ПометкаУдаления);
				ДанныеВыбора.Добавить(СтруктураЗначение,,,БиблиотекаКартинок.ПомеченныйНаУдалениеЭлемент);
			Иначе
				ДанныеВыбора.Добавить(Выборка.Ссылка,);
			КонецЕсли;			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли