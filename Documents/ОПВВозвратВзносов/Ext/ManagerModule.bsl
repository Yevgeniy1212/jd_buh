﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ДоступныеВидыОпераций(Объект) Экспорт
    
    ДоступныеОперации = Новый Массив;
    ИсключаемыеОперации = Новый Массив;
	
	ОрганизацияЯвляетсяВкладчикомОППВ = ПроцедурыНалоговогоУчета.ПолучитьПризнакВкладчикаПрофПенсионныхВзносов(Объект.Организация, Объект.Дата);
	
    Если НЕ ОрганизацияЯвляетсяВкладчикомОППВ Тогда 
        ИсключаемыеОперации.Добавить(Перечисления.ВидыОперацийОПВВозвратВзносов.ВозвратОбязательныхПрофессиональныхПенсионныхВзносов);
    КонецЕсли;
    
    Для Каждого ВидОперации Из Перечисления.ВидыОперацийОПВВозвратВзносов Цикл
        Если ИсключаемыеОперации.Найти(ВидОперации) <> Неопределено Тогда 
            Продолжить;
        КонецЕсли;
        ДоступныеОперации.Добавить(ВидОперации);
	КонецЦикла;
	
	Возврат ДоступныеОперации;

КонецФункции

Функция ДоступныеДокументыОснования(ВидОперации) Экспорт
	
	ДоступныеДокументы = Новый Массив;
	ИсключаемыеДокументы = Новый Массив;
	
	Если ВидОперации = Перечисления.ВидыОперацийОПВВозвратВзносов.ВозвратОбязательныхПрофессиональныхПенсионныхВзносов Тогда
		ИсключаемыеДокументы.Добавить(Перечисления.ВидыОперацийОПВПеречислениеВФонды.ПеречислениеОбязательныхПенсионныхВзносов);
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийОПВВозвратВзносов.ВозвратОбязательныхПенсионныхВзносов Тогда
		ИсключаемыеДокументы.Добавить(Перечисления.ВидыОперацийОПВПеречислениеВФонды.ПеречислениеОбязательныхПрофессиональныхПенсионныхВзносов);
		
	КонецЕсли;
	
	Для Каждого ВидОперацииОснования Из Перечисления.ВидыОперацийОПВПеречислениеВФонды Цикл
		Если ИсключаемыеДокументы.Найти(ВидОперацииОснования) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		ДоступныеДокументы.Добавить(ВидОперацииОснования);
	КонецЦикла;
	
	Возврат ДоступныеДокументы;

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоОПВПеречисленияВФонды(Объект, Основание) Экспорт
	
	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(Объект, Основание);
	
	СоответствиеВидовОпераций = Новый Соответствие;
	СоответствиеВидовОпераций.Вставить(Перечисления.ВидыОперацийОПВПеречислениеВФонды.ПеречислениеОбязательныхПенсионныхВзносов, Перечисления.ВидыОперацийОПВВозвратВзносов.ВозвратОбязательныхПенсионныхВзносов);
	СоответствиеВидовОпераций.Вставить(Перечисления.ВидыОперацийОПВПеречислениеВФонды.ПеречислениеОбязательныхПрофессиональныхПенсионныхВзносов, Перечисления.ВидыОперацийОПВВозвратВзносов.ВозвратОбязательныхПрофессиональныхПенсионныхВзносов);
	СоответствиеВидовОпераций.Вставить(Перечисления.ВидыОперацийОПВПеречислениеВФонды.ПеречислениеОбязательныхПенсионныхВзносовРаботодателя, Перечисления.ВидыОперацийОПВВозвратВзносов.ВозвратОбязательныхПенсионныхВзносовРаботодателя);
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОПВПеречислениеВФонды.Контрагент КАК Контрагент,
	|	ОПВПеречислениеВФонды.ВидПлатежа КАК ВидПлатежа,
	|	ОПВПеречислениеВФонды.ВидОперации КАК ВидОперации,
	|	ОПВПеречислениеВФонды.ПериодРегистрации КАК ПериодРегистрации,
	|	ОПВПеречислениеВФонды.ПенсионныеВзносы КАК ПенсионныеВзносы
	|ИЗ
	|	Документ.ОПВПеречислениеВФонды КАК ОПВПеречислениеВФонды
	|
	|ГДЕ
	|	ОПВПеречислениеВФонды.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОПВПеречислениеВФонды.ПенсионныеВзносы.НомерСтроки";

	Запрос.УстановитьПараметр("Ссылка", Основание);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		Объект.Контрагент		  = РезультатЗапроса.Контрагент;
		Объект.ВидПлатежа		  = РезультатЗапроса.ВидПлатежа;
		Объект.ПериодРегистрации  = РезультатЗапроса.ПериодРегистрации;
		Объект.ВидОперации 	  	  = СоответствиеВидовОпераций[РезультатЗапроса.ВидОперации];
		
		Объект.ПенсионныеВзносы.Загрузить(РезультатЗапроса.ПенсионныеВзносы.Выгрузить());
		
	КонецЕсли;
	
	Объект.ДокументОснование = Основание;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецЕсли