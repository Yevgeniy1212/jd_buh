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

#Область ЗагрузкаДанныхИзФайла

// Устанавливает параметры загрузки.
//
Процедура УстановитьПараметрыЗагрузкиИзФайлаВТЧ(Параметры) Экспорт
    

КонецПроцедуры

// Производит сопоставление данных, загружаемых в табличную часть ПолноеИмяТабличнойЧасти,
// с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
//
// Параметры:
//   АдресЗагружаемыхДанных    - Строка - Адрес временного хранилища с таблицей значений, в которой
//                                        находятся загруженные данные из файла. Состав колонок:
//     * Идентификатор - Число - Порядковый номер строки;
//     * остальные колонки соответствуют колонкам макета ЗагрузкаИзФайла.
//   АдресТаблицыСопоставления - Строка - Адрес временного хранилища с пустой таблицей значений,
//                                        являющейся копией табличной части документа, 
//                                        которую необходимо заполнить из таблицы АдресЗагружаемыхДанных.
//   СписокНеоднозначностей - ТаблицаЗначений - Список неоднозначных значений, для которых в ИБ имеется несколько
//                                              подходящих вариантов.
//     * Колонка       - Строка - Имя колонки, в которой была обнаружена неоднозначность;
//     * Идентификатор - Число  - Идентификатор строки, в которой была обнаружена неоднозначность.
//   ПолноеИмяТабличнойЧасти   - Строка - Полное имя табличной части, в которую загружаются данные.
//   ДополнительныеПараметры   - ЛюбойТип - Любые дополнительные сведения.
//
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	ДанныеСопоставление	= ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления); // ТаблицаЗначений
	ЗагружаемыеДанные	= ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных);
	
	МассивФамилия	           = ЗагружаемыеДанные.ВыгрузитьКолонку("ФизЛицо_Фамилия");
	МассивИмя	               = ЗагружаемыеДанные.ВыгрузитьКолонку("ФизЛицо_Имя");
	МассивОтчество	           = ЗагружаемыеДанные.ВыгрузитьКолонку("ФизЛицо_Отчество");
	МассивФИО	               = ЗагружаемыеДанные.ВыгрузитьКолонку("ФизЛицо_ФИО");
	МассивПериодВзаиморасчетов = ЗагружаемыеДанные.ВыгрузитьКолонку("ПериодВзаиморасчетов");  
	
	НовыйМассивПериодВзаиморасчетов = Новый Массив;
	
	Для Каждого ЭлементПериодВзаиморасчетов Из МассивПериодВзаиморасчетов Цикл
		Попытка
			НовыйЭлементПериодВзаиморасчетов = Дата(Прав(ЭлементПериодВзаиморасчетов, 4) + Сред(ЭлементПериодВзаиморасчетов, 4, 2) + Лев(ЭлементПериодВзаиморасчетов, 2));		
			НовыйМассивПериодВзаиморасчетов.Добавить(НовыйЭлементПериодВзаиморасчетов);	
		Исключение	
			НовыйМассивПериодВзаиморасчетов.Добавить(ЭлементПериодВзаиморасчетов);
		КонецПопытки;
	КонецЦикла;
			
	ЗагружаемыеДанные.Колонки.Удалить("ФизЛицо_Фамилия"); 
	ЗагружаемыеДанные.Колонки.Удалить("ФизЛицо_Имя");  
	ЗагружаемыеДанные.Колонки.Удалить("ФизЛицо_Отчество");  
	ЗагружаемыеДанные.Колонки.Удалить("ФизЛицо_ФИО");  
	ЗагружаемыеДанные.Колонки.Удалить("ПериодВзаиморасчетов");
	   
	ЗагружаемыеДанные.Колонки.Добавить("ФизЛицо_Фамилия",      Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50)));  
	ЗагружаемыеДанные.Колонки.Добавить("ФизЛицо_Имя",          Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50)));
	ЗагружаемыеДанные.Колонки.Добавить("ФизЛицо_Отчество",     Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50)));   
	ЗагружаемыеДанные.Колонки.Добавить("ФизЛицо_ФИО",          Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50)));
	ЗагружаемыеДанные.Колонки.Добавить("ПериодВзаиморасчетов", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
		
	ЗагружаемыеДанные.ЗагрузитьКолонку(МассивФамилия, 	                "ФизЛицо_Фамилия"); 
	ЗагружаемыеДанные.ЗагрузитьКолонку(МассивИмя, 	                    "ФизЛицо_Имя");
	ЗагружаемыеДанные.ЗагрузитьКолонку(МассивОтчество, 	                "ФизЛицо_Отчество");
	ЗагружаемыеДанные.ЗагрузитьКолонку(МассивФИО, 	                    "ФизЛицо_ФИО");
	ЗагружаемыеДанные.ЗагрузитьКолонку(НовыйМассивПериодВзаиморасчетов, "ПериодВзаиморасчетов");
		
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗагружаемыеДанные.ФизЛицо_Фамилия КАК ФизЛицоФамилия, 
	|	ЗагружаемыеДанные.ФизЛицо_Имя КАК ФизЛицоИмя,
	|	ЗагружаемыеДанные.ФизЛицо_Отчество КАК ФизЛицоОтчество,
	|	ЗагружаемыеДанные.ФизЛицо_ФИО КАК ФизЛицоФИО,
	|	ЗагружаемыеДанные.ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
	|	ЗагружаемыеДанные.СуммаНачисления КАК СуммаНачисления,
	|	ЗагружаемыеДанные.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ ЗагружаемыеДанные
	|ИЗ
	|	&ЗагружаемыеДанные КАК ЗагружаемыеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФизЛица.Идентификатор КАК Идентификатор,
	|	МАКСИМУМ(ФизЛица.ФизЛицо) КАК ФизЛицо,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ФизЛица.ФизЛицо) КАК КоличествоФизЛиц
	|ПОМЕСТИТЬ ВТДанныеФизЛица
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|		ФизЛица.Ссылка КАК ФизЛицо
	|	ИЗ
	|		ЗагружаемыеДанные КАК ЗагружаемыеДанные
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизЛица
	|			ПО (ФизЛица.Наименование = ЗагружаемыеДанные.ФизЛицоФИО)
	|	ГДЕ
	|		ЗагружаемыеДанные.ФизЛицоФИО <> """"
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|		ФИОФизЛиц.ФизЛицо КАК ФизЛицо
	|	ИЗ
	|		ЗагружаемыеДанные КАК ЗагружаемыеДанные
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&Дата, ) КАК ФИОФизЛиц
	|			ПО (ВЫБОР КОГДА НЕ ЗагружаемыеДанные.ФизЛицоФамилия = """"
	|				ТОГДА ФИОФизЛиц.Фамилия = ЗагружаемыеДанные.ФизЛицоФамилия
	|				ИНАЧЕ ИСТИНА КОНЕЦ)
	|			И (ВЫБОР КОГДА НЕ ЗагружаемыеДанные.ФизЛицоИмя = """"
	|				ТОГДА ФИОФизЛиц.Имя = ЗагружаемыеДанные.ФизЛицоИмя
	|				ИНАЧЕ ИСТИНА КОНЕЦ)
	|			И (ВЫБОР КОГДА НЕ ЗагружаемыеДанные.ФизЛицоОтчество = """"
	|				ТОГДА ФИОФизЛиц.Отчество = ЗагружаемыеДанные.ФизЛицоОтчество
	|				ИНАЧЕ ИСТИНА КОНЕЦ)
	|	ГДЕ
	|		ЗагружаемыеДанные.ФизЛицоФИО = """") КАК ФизЛица
	|
	|СГРУППИРОВАТЬ ПО
	|	ФизЛица.Идентификатор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛица.Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	ЗагружаемыеДанные.ФизЛицоФамилия КАК ФизЛицоФамилия, 
	|	ЗагружаемыеДанные.ФизЛицоИмя КАК ФизЛицоИмя,
	|	ЗагружаемыеДанные.ФизЛицоОтчество КАК ФизЛицоОтчество,
	|	ЗагружаемыеДанные.ФизЛицоФИО КАК ФизЛицоФИО,
	|	ЗагружаемыеДанные.ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
	|	ЗагружаемыеДанные.СуммаНачисления КАК СуммаНачисления,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ФизЛица.КоличествоФизЛиц, 0) = 1
	|			ТОГДА ФизЛица.ФизЛицо
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|	КОНЕЦ КАК ФизЛицо,
	|	ЕСТЬNULL(ФизЛица.КоличествоФизЛиц, 0) КАК КоличествоФизЛиц 
	|ИЗ
	|	ЗагружаемыеДанные КАК ЗагружаемыеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеФизЛица КАК ФизЛица
	|		ПО (ФизЛица.Идентификатор = ЗагружаемыеДанные.Идентификатор)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ЗагружаемыеДанные", ЗагружаемыеДанные); 
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ДанныеСопоставление.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Если Выборка.КоличествоФизЛиц > 1 Тогда
			ЗаписьОНеоднозначности					= СписокНеоднозначностей.Добавить();
			ЗаписьОНеоднозначности.Идентификатор	= Выборка.Идентификатор;
			ЗаписьОНеоднозначности.Колонка			= "ФизЛицо";
		КонецЕсли;
			
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ДанныеСопоставление, АдресТаблицыСопоставления);
	
КонецПроцедуры

// Возвращает список подходящих объектов ИБ для неоднозначного значения ячейки.
// 
// Параметры:
//   ПолноеИмяТабличнойЧасти  - Строка - Полное имя табличной части, в которую загружаются данные.
//  ИмяКолонки                - Строка - Имя колонки, в который возникла неоднозначность.
//  СписокНеоднозначностей    - Массив - Массив для заполнения с неоднозначными данными.
//  ЗагружаемыеЗначенияСтрока - Строка - Загружаемые данные на основании которых возникла неоднозначность.
//  ДополнительныеПараметры   - ЛюбойТип - Любые дополнительные сведения.
//
Процедура ЗаполнитьСписокНеоднозначностей(ПолноеИмяТабличнойЧасти, СписокНеоднозначностей, ИмяКолонки, ЗагружаемыеЗначенияСтрока, ДополнительныеПараметры) Экспорт
	
	Запрос = Новый Запрос;
	
	Если ИмяКолонки = "ФизЛицо" Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СпрФизЛица.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ФизическиеЛица КАК СпрФизЛица
		|";
		
		ТекстУсловия = "ГДЕ ИСТИНА";
		
		Если ЗначениеЗаполнено(ЗагружаемыеЗначенияСтрока.ФизЛицо_ФИО) Тогда
		
			ТекстУсловия = "ГДЕ &ФизЛицоНаименование <> """"
			|		И СпрФизЛица.Наименование = &ФизЛицоНаименование"; 
			
			Запрос.УстановитьПараметр("ФизЛицоНаименование", ЗагружаемыеЗначенияСтрока.ФизЛицо_ФИО);
		
		Иначе
		
	        ФИОФизЛица = "";
			
			Если ЗначениеЗаполнено(ЗагружаемыеЗначенияСтрока.ФизЛицо_Фамилия) Тогда	
				ФИОФизЛица = ФИОФизЛица + ЗагружаемыеЗначенияСтрока.ФизЛицо_Фамилия;	
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ЗагружаемыеЗначенияСтрока.ФизЛицо_Имя) Тогда	
				ФИОФизЛица = ФИОФизЛица + ЗагружаемыеЗначенияСтрока.ФизЛицо_Имя;			
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ЗагружаемыеЗначенияСтрока.ФизЛицо_Отчество) Тогда	
				ФИОФизЛица = ФИОФизЛица + ЗагружаемыеЗначенияСтрока.ФизЛицо_Отчество;		
			КонецЕсли;
			
			Если ФИОФизЛица <> "" Тогда 
				
				ФИОФизЛица = "%" + ФИОФизЛица + "%";
				
				ТекстУсловия = "ГДЕ &ФизЛицоНаименование <> """"
				|		И СпрФизЛица.Наименование ПОДОБНО &ФизЛицоНаименование";
				
				Запрос.УстановитьПараметр("ФизЛицоНаименование", ФИОФизЛица);
			КонецЕсли;  
			
		КонецЕсли;
		
		Запрос.Текст = Запрос.Текст + ТекстУсловия; 
		
		Запрос.УстановитьПараметр("УсловиеПоФизЛицу", ТекстУсловия);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запрос.Текст) Тогда
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокНеоднозначностей.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Проведение

Функция ПодготовитьПараметрыПроведения(Ссылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Содержание", НСтр("ru='Начислены прочие выплаты'", ОбщегоНазначения.КодОсновногоЯзыка()));
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета",	Константы.ВалютаРегламентированногоУчета.Получить());
    
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	ОрганизацияПлательщикНалогаНаПрибыль 			= ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Реквизиты.Организация, Реквизиты.Период);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Реквизиты.Организация, Реквизиты.Период);
	
	НеобходимостьОтраженияВНУ 						= (ОрганизацияПлательщикНалогаНаПрибыль И Реквизиты.УчитыватьКПН) И (ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ Реквизиты.ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ);
	
	Реквизиты.Вставить("ОрганизацияПлательщикНалогаНаПрибыль", 			 ОрганизацияПлательщикНалогаНаПрибыль);
	Реквизиты.Вставить("ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль", ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль);
	Реквизиты.Вставить("НеобходимостьОтраженияВНУ", 					 НеобходимостьОтраженияВНУ);
	
	ПараметрыПроведения.Реквизиты.ЗаполнитьЗначения(НеобходимостьОтраженияВНУ, "НеобходимостьОтраженияВНУ");
	ПараметрыПроведения.Реквизиты.ЗаполнитьЗначения(ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль, "ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль");

	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	Реквизиты.Вставить("ПоддержкаРаботыСоСтруктурнымиПодразделениями", ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	ПараметрыПроведения.Реквизиты.ЗаполнитьЗначения(ПоддержкаРаботыСоСтруктурнымиПодразделениями, "ПоддержкаРаботыСоСтруктурнымиПодразделениями");
   
	Налогоплательщик = Реквизиты.Организация;
	Если ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		
		Налогоплательщик = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.ПолучитьНалогоплательщикаСтруктурнойЕдиницы(Реквизиты.СтруктурноеПодразделение,
																	Реквизиты.Организация,
																	Перечисления.РазделыНалоговогоУчета.НДС);
	КонецЕсли;       
	
	Реквизиты.Вставить("Налогоплательщик", Налогоплательщик);
	ПараметрыПроведения.Реквизиты.ЗаполнитьЗначения(Налогоплательщик, "Налогоплательщик");


	
	Запрос.УстановитьПараметр("Организация", 			   Реквизиты.Организация);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение",  Реквизиты.СтруктурноеПодразделение);
	Запрос.УстановитьПараметр("ПоддержкаРаботыСоСтруктурнымиПодразделениями", 	   ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	Запрос.УстановитьПараметр("Налогоплательщик",  Налогоплательщик);
	
	ПодготовитьТаблицыДокумента(Запрос, Реквизиты);
   	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаПрочиеВыплаты(НомераТаблиц, Реквизиты, ПараметрыПроведения)
					+ ТекстЗапросаВзаиморасчетыПоПрочимВыплатам(НомераТаблиц, Реквизиты, ПараметрыПроведения);

	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда 
		Результат = Запрос.ВыполнитьПакет();
		Для Каждого НомерТаблицы Из НомераТаблиц Цикл
			ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
		КонецЦикла;
	КонецЕсли;
			
	Возврат ПараметрыПроведения;

КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц) 
	
	НомераТаблиц.Вставить("ВременнаяТаблица_Реквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РегистрацияПрочихВыплат.Дата КАК Период,
		|	РегистрацияПрочихВыплат.Организация,
		|	РегистрацияПрочихВыплат.СтруктурноеПодразделение,
		|	РегистрацияПрочихВыплат.Ссылка,
		|	РегистрацияПрочихВыплат.УчитыватьКПН КАК УчитыватьКПН,
		|	РегистрацияПрочихВыплат.ВидПрочихВыплат КАК ВидПрочихВыплат,
	    |	РегистрацияПрочихВыплат.ВидУчетаНУ КАК ВидУчетаНУ,
		|   РегистрацияПрочихВыплат.СпособОтраженияВРеглУчете КАК СпособОтраженияВРеглУчете,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРеглУчета,
	    |	&Содержание КАК Содержание,
		|	ЛОЖЬ КАК НеобходимостьОтраженияВНУ,
	    |	ЛОЖЬ КАК ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль,
		|	ЛОЖЬ КАК ПоддержкаРаботыСоСтруктурнымиПодразделениями,
	    |	НЕОПРЕДЕЛЕНО КАК Налогоплательщик
		|ПОМЕСТИТЬ Реквизиты
		|ИЗ
		|	Документ.РегистрацияПрочихВыплат КАК РегистрацияПрочихВыплат
		|ГДЕ
		|	РегистрацияПрочихВыплат.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Реквизиты.Период,
		|	Реквизиты.Организация,
		|	Реквизиты.СтруктурноеПодразделение,
		|	Реквизиты.Ссылка,
		|	Реквизиты.УчитыватьКПН КАК УчитыватьКПН,
		|	Реквизиты.ВидПрочихВыплат КАК ВидПрочихВыплат,
		|	Реквизиты.ВидУчетаНУ КАК ВидУчетаНУ,
		|	Реквизиты.СпособОтраженияВРеглУчете КАК СпособОтраженияВРеглУчете,
		|	Реквизиты.ВалютаРеглУчета КАК ВалютаРеглУчета,
		|	Реквизиты.Содержание КАК Содержание,
		|	Реквизиты.НеобходимостьОтраженияВНУ,
		|	Реквизиты.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль,
		|	Реквизиты.ПоддержкаРаботыСоСтруктурнымиПодразделениями,
		|	Реквизиты.Налогоплательщик		
		|ИЗ
		|	Реквизиты КАК Реквизиты";

	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Процедура ПодготовитьТаблицыДокумента(Запрос, Реквизиты)
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПрочиеВыплаты.НомерСтроки,
		|	ПрочиеВыплаты.ФизЛицо,
		|	ПрочиеВыплаты.ПериодВзаиморасчетов,
		|	ПрочиеВыплаты.СуммаНачисления,
		|	ПрочиеВыплаты.СчетЗатратБУ,
		|	ПрочиеВыплаты.СчетЗатратНУ,
		|	ПрочиеВыплаты.СубконтоЗатратБУ1,
		|	ПрочиеВыплаты.СубконтоЗатратБУ2,
		|	ПрочиеВыплаты.СубконтоЗатратБУ3,
		|	ПрочиеВыплаты.СубконтоЗатратНУ1,
		|	ПрочиеВыплаты.СубконтоЗатратНУ2,
		|	ПрочиеВыплаты.СубконтоЗатратНУ3
		|ПОМЕСТИТЬ ВТ_ПрочиеВыплаты
		|ИЗ
		|	Документ.РегистрацияПрочихВыплат.ПрочиеВыплаты КАК ПрочиеВыплаты
		|ГДЕ
		|	ПрочиеВыплаты.Ссылка = &Ссылка
		|";
			
	Запрос.Текст = Запрос.Текст + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	Результат = Запрос.Выполнить();
	                                                 
КонецПроцедуры

Функция ТекстЗапросаПрочиеВыплаты(НомераТаблиц, Реквизиты, ПараметрыПроведения) 
	
	НомераТаблиц.Вставить("ТаблицаПрочиеВыплаты", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Период КАК Период,
	|	Реквизиты.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	Реквизиты.ВалютаРеглУчета КАК ВалютаРеглУчета,
	|	ВТ_ПрочиеВыплаты.НомерСтроки,
	|	ВТ_ПрочиеВыплаты.ФизЛицо,
	|   ВТ_ПрочиеВыплаты.СуммаНачисления КАК Сумма,  
	|	ВТ_ПрочиеВыплаты.ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
	|	Реквизиты.ВидПрочихВыплат КАК ВидПрочихВыплат,
	|	Реквизиты.СпособОтраженияВРеглУчете КАК СпособОтраженияВРеглУчете,
	|	Реквизиты.ВидУчетаНУ КАК ВидУчетаНУ,
	|	ВТ_ПрочиеВыплаты.СчетЗатратБУ КАК СчетДтБУ,
	|	ВТ_ПрочиеВыплаты.СубконтоЗатратБУ1 КАК СубконтоДтБУ1,
	|	ВТ_ПрочиеВыплаты.СубконтоЗатратБУ2 КАК СубконтоДтБУ2,
	|	ВТ_ПрочиеВыплаты.СубконтоЗатратБУ3 КАК СубконтоДтБУ3,
	|	ВТ_ПрочиеВыплаты.СчетЗатратНУ КАК СчетДтНУ,
	|	ВТ_ПрочиеВыплаты.СубконтоЗатратНУ1 КАК СубконтоДтНУ1,
	|	ВТ_ПрочиеВыплаты.СубконтоЗатратНУ2 КАК СубконтоДтНУ2,
	|	ВТ_ПрочиеВыплаты.СубконтоЗатратНУ3 КАК СубконтоДтНУ3
	|ИЗ
	|		ВТ_ПрочиеВыплаты КАК ВТ_ПрочиеВыплаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Реквизиты КАК Реквизиты
	|		ПО (ИСТИНА)
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_ПрочиеВыплаты.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();	
КонецФункции

Функция ТекстЗапросаВзаиморасчетыПоПрочимВыплатам(НомераТаблиц, Реквизиты, ПараметрыПроведения) 
	
	НомераТаблиц.Вставить("ТаблицаВзаиморасчетыПоПрочимВыплатам", НомераТаблиц.Количество());

	ТекстЗапроса =  
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	&Организация КАК Организация,
			|	&Налогоплательщик КАК Налогоплательщик,
			|	СтрокаПрочиеВыплаты.ФизЛицо КАК ФизЛицо,
			|	Реквизиты.Период КАК Период,  
			|	Реквизиты.ВидПрочихВыплат КАК ВидПрочихВыплат,
			|	СтрокаПрочиеВыплаты.ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
			|	СтрокаПрочиеВыплаты.СуммаНачисления КАК СуммаВзаиморасчетов,
			|	СтрокаПрочиеВыплаты.НомерСтроки,
			|	ЗНАЧЕНИЕ(Перечисление.РасчетыСБюджетомФондамиВидСтроки.Исчисление) КАК ВидСтроки,
			|	ВЫБОР
			|		КОГДА НЕ (&СтруктурноеПодразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка))
		    |			ТОГДА &СтруктурноеПодразделение
			|		ИНАЧЕ &Организация
			|	КОНЕЦ КАК СтруктурнаяЕдиница
			|ИЗ
			|	ВТ_ПрочиеВыплаты КАК СтрокаПрочиеВыплаты
			|	ЛЕВОЕ СОЕДИНЕНИЕ Реквизиты КАК Реквизиты
			|		ПО ИСТИНА
			|УПОРЯДОЧИТЬ ПО 
			|	СтрокаПрочиеВыплаты.НомерСтроки
			|" + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
			
		
	Возврат ТекстЗапроса;
	
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