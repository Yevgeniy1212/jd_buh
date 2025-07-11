﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

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

////////////////////////////////////////////////////////////////////////////////
// Проведение

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка"						  , ДокументСсылка);
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	Запрос.УстановитьПараметр("СинонимНМА", НСтр("ru = 'НМА'"));
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)
					+ ТекстЗапросаВыработкаНМА(НомераТаблиц);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;

КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты"				 , НомераТаблиц.Количество());
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	""ВыработкаНМА"" КАК ВидДокумента,
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ВыработкаНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.ВидДокумента,
	|	Реквизиты.Регистратор,
	|	Реквизиты.Период
	|ИЗ
	|	Реквизиты КАК Реквизиты";

	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("ВременнаяТаблицаНМА", НомераТаблиц.Количество());
 	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаНМА.Ссылка КАК Ссылка,
	|	ТаблицаНМА.НомерСтроки,
	|	ТаблицаНМА.НематериальныйАктив,
	|	ТаблицаНМА.Количество КАК Количество
	|ПОМЕСТИТЬ ТаблицаНМА
	|ИЗ
	|	Документ.ВыработкаНМА.НМА КАК ТаблицаНМА
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаВыработкаНМА(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВыработкаНМАРеквизитыТаблицаНМА", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	""НМА"" КАК ИмяСписка,
	|	&СинонимНМА КАК СинонимСписка,
	|	Реквизиты.Период КАК Период,
	|	Реквизиты.Регистратор КАК Регистратор,
	|	ТаблицаНМА.НомерСтроки,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	ТаблицаНМА.Количество
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаНМА КАК ТаблицаНМА
	|		ПО (ИСТИНА)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаНМА.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
		
КонецФункции

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