﻿////////////////////////////////////////////////////////////////////////////////
// Функции и процедуры обеспечения формирования бухгалтерских отчетов.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьСписокМакетовОформления() Экспорт
	
	СписокМакетовОформления = Новый СписокЗначений;
	
	Для Каждого ОбщийМакет Из Метаданные.ОбщиеМакеты Цикл
		Если ОбщийМакет.ТипМакета = Метаданные.СвойстваОбъектов.ТипМакета.МакетОформленияКомпоновкиДанных Тогда
			СписокМакетовОформления.Добавить(ОбщийМакет.Имя, ОбщийМакет.Синоним);
		КонецЕсли;
	КонецЦикла;
	
	СписокМакетовОформления.Добавить("БезОформления", "Без оформления");
	СписокМакетовОформления.Добавить("Основной"     , "Основной");
	СписокМакетовОформления.Добавить("Яркий"        , "Яркий");
	СписокМакетовОформления.Добавить("Море"         , "Море");
	СписокМакетовОформления.Добавить("Арктика"      , "Арктика");
	СписокМакетовОформления.Добавить("Зеленый"      , "Зеленый");
	СписокМакетовОформления.Добавить("Античный"     , "Античный");
	
	Возврат СписокМакетовОформления;
	
КонецФункции

Функция ПолучитьТекстОбособленныхПодразделений(Организация) Экспорт
	
	ТекстОрганизации = "";
	
	СведенияОбОрганизации = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(Организация);
	ТекстОрганизации = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
	Если ПустаяСтрока(ТекстОрганизации) Тогда
		ТекстОрганизации = СведенияОбОрганизации.Представление;
	КонецЕсли;
	
	ТекстОрганизации = ТекстОрганизации + НСтр("ru = ' с обособленными подразделениями'");
	
	Возврат ТекстОрганизации;
	
КонецФункции

Функция ПолучитьТекстОрганизация(Организация = Неопределено, ВключатьОбособленныеПодразделения = Ложь) Экспорт
	
	
	ТекстОрганизации = "";
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Попытка
				
			СведенияОбОрганизации = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(Организация);
			Текст = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
			Если ПустаяСтрока(Текст) Тогда
				Текст = СведенияОбОрганизации.Представление;
			КонецЕсли;
			
			ТекстОрганизации = ТекстОрганизации + Текст + ";"; 
				
		Исключение
			// Запись в журнал регистрации не требуется
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Лев(ТекстОрганизации, СтрДлина(ТекстОрганизации) - 1);
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

