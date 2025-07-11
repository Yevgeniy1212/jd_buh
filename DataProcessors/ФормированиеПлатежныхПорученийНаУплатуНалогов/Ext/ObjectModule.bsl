﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция СоздатьПустуюТаблицуДанных()

	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("НомерСтроки",         ОбщегоНазначенияБККлиентСервер.ПолучитьОписаниеТиповЧисла(15, 0));
	ТаблицаДанных.Колонки.Добавить("СуммаДокумента",      ОбщегоНазначенияБККлиентСервер.ПолучитьОписаниеТиповЧисла(15, 2));
	ТаблицаДанных.Колонки.Добавить("КодБК",               ОбщегоНазначенияБККлиентСервер.ПолучитьОписаниеТиповСтроки(6));
	ТаблицаДанных.Колонки.Добавить("КодНазначенияПлатежа",ОбщегоНазначенияБККлиентСервер.ПолучитьОписаниеТиповСтроки(3));
	ТаблицаДанных.Колонки.Добавить("ВидНалога",          Новый ОписаниеТипов("СправочникСсылка.НалогиСборыОтчисления"));
	ТаблицаДанных.Колонки.Добавить("НазначениеПлатежа",   ОбщегоНазначенияБККлиентСервер.ПолучитьОписаниеТиповСтроки(250));
	ТаблицаДанных.Колонки.Добавить("Контрагент",          Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ТаблицаДанных.Колонки.Добавить("Плательщик",          Новый ОписаниеТипов("СправочникСсылка.Организации,СправочникСсылка.ПодразделенияОрганизаций"));
	ТаблицаДанных.Колонки.Добавить("СчетКонтрагента",     Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета"));
	ТаблицаДанных.Колонки.Добавить("СчетОрганизации",     Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета"));
	ТаблицаДанных.Колонки.Добавить("Организация",         Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаДанных.Колонки.Добавить("СчетУчетаРасчетовСКонтрагентомБУ", Новый ОписаниеТипов("ПланСчетовСсылка.Типовой"));
	ТаблицаДанных.Колонки.Добавить("СчетУчетаРасчетовСКонтрагентомНУ", Новый ОписаниеТипов("ПланСчетовСсылка.Налоговый"));
	ТаблицаДанных.Колонки.Добавить("СубконтоДтБУ1");
	ТаблицаДанных.Колонки.Добавить("СубконтоДтБУ2");
	ТаблицаДанных.Колонки.Добавить("СубконтоДтБУ3");
	ТаблицаДанных.Колонки.Добавить("СубконтоДтНУ1");
	ТаблицаДанных.Колонки.Добавить("СубконтоДтНУ2");
	ТаблицаДанных.Колонки.Добавить("СубконтоДтНУ3");
	ТаблицаДанных.Колонки.Добавить("СтруктурнаяЕдиница", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
	
	Возврат ТаблицаДанных;

КонецФункции 

Функция ПолучитьТаблицуРеквизитовПлатежа(ТаблицаОстатков)
		
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписокРеквизитов.Ссылка КАК ВидНалога,
	|	СписокРеквизитов.КодБК КАК КодБК,
	|	СписокРеквизитов.Контрагент КАК Контрагент,
	|	СписокРеквизитов.СчетКонтрагента КАК СчетКонтрагента,
	|	СписокРеквизитов.НазначениеПлатежа,
	|	СписокРеквизитов.КодНазначенияПлатежа,
	|	СписокРеквизитов.СчетУчетаРасчетовСКонтрагентомНУ
	|ИЗ
	|	Справочник.НалогиСборыОтчисления КАК СписокРеквизитов
	|ГДЕ
	|	СписокРеквизитов.ПометкаУдаления = ЛОЖЬ
	|	И СписокРеквизитов.Ссылка В (&ВидНалога)
	|";
	      	
	Запрос.УстановитьПараметр("ВидНалога", ТаблицаОстатков.ВыгрузитьКолонку("Субконто1"));	
		
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
		
	Возврат ТаблицаРезультата;

КонецФункции // ПолучитьТаблицуРеквизитовПлатежа()

Функция ПодготовитьТаблицуДанныхПоОстаткам(Параметры)
	
	ТаблицаДанных = СоздатьПустуюТаблицуДанных();
	ТаблицаРеквизитовПлатежа = ПолучитьТаблицуРеквизитовПлатежа(Параметры.ТаблицаОстатков);
	
	Для Каждого СтрокаОстатка Из Параметры.ТаблицаОстатков Цикл
		Если  НЕ СтрокаОстатка.Оплатить Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаДанных = ТаблицаДанных.Добавить();
		СтрокаДанных.НомерСтроки    				  = СтрокаОстатка.НомерСтроки;
		СтрокаДанных.СуммаДокумента 				  = СтрокаОстатка.Сумма;
		СтрокаДанных.Организация    				  = СтрокаОстатка.Организация;
		
		СтрокаДанных.СубконтоДтБУ1  			      = СтрокаОстатка.Субконто1;
		СтрокаДанных.СубконтоДтБУ2  				  = СтрокаОстатка.Субконто2;
		СтрокаДанных.СубконтоДтБУ3  				  = СтрокаОстатка.Субконто3;
		
		СтрокаДанных.СубконтоДтНУ1  			      = СтрокаОстатка.Субконто1;
		СтрокаДанных.СубконтоДтНУ2  				  = СтрокаОстатка.Субконто2;
		СтрокаДанных.СубконтоДтНУ3  				  = СтрокаОстатка.Субконто3;
		
		СтрокаДанных.СтруктурнаяЕдиница 			  = СтрокаОстатка.СтруктурнаяЕдиница;
		СтрокаДанных.СчетУчетаРасчетовСКонтрагентомБУ = СтрокаОстатка.СчетУчета;
		
		СтрокаПлатежа = ТаблицаРеквизитовПлатежа.Найти(СтрокаОстатка.Субконто1, "ВидНалога");
		
		Если НЕ СтрокаПлатежа = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтрокаДанных, СтрокаПлатежа);		
			СтрокаДанных.НазначениеПлатежа = СтрокаПлатежа.НазначениеПлатежа;
		Иначе
			СтрокаДанных.НазначениеПлатежа = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Уплата налога: %1'"), СтрокаОстатка.Субконто1);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаДанных.СтруктурнаяЕдиница)
			И ТипЗнч(СтрокаДанных.СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			
			СтрокаДанных.НазначениеПлатежа = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 подразделение """"%2""""'"), СтрокаДанных.НазначениеПлатежа, СтрокаДанных.СтруктурнаяЕдиница.Наименование);
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(СтрокаДанных.СчетУчетаРасчетовСКонтрагентомНУ) Тогда
			СтрокаДанных.СчетУчетаРасчетовСКонтрагентомНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ, ", СтрокаДанных.СчетУчетаРасчетовСКонтрагентомНУ));
		КонецЕсли;
		
		Если Параметры.ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
			ОпределитьПлательщикаИПолучателя(СтрокаДанных, Параметры.ГоловнаяОрганизация);
		Иначе
			СтрокаДанных.Плательщик 		= СтрокаДанных.Организация;
			СтрокаДанных.СчетОрганизации 	= СчетОрганизации;
		КонецЕсли;  	
		
	КонецЦикла;
	
	Возврат ТаблицаДанных;

КонецФункции 

Процедура ЗаполнитьУплаченнуюСумму(Параметры) Экспорт
	
	ТаблицаОстатков 							 = Параметры.ТаблицаОстатков;
	ГоловнаяОрганизация 						 = Параметры.ГоловнаяОрганизация;
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = Параметры.ПоддержкаРаботыСоСтруктурнымиПодразделениями;
	ПолучениеОборотов 						     = Параметры.ПолучениеОборотов;

	ТаблицаДанныхСВидамиНалоговИСумма = ПодготовитьТаблицуДанныхПоОстаткам(Параметры);
	ТаблицаПоУплаченнымСуммам = ТаблицаСДаннымиПлатежныхПоручений(ТаблицаДанныхСВидамиНалоговИСумма, Параметры.ПоддержкаРаботыСоСтруктурнымиПодразделениями, Истина); 
	ТаблицаПоУплаченнымСуммам.Свернуть("НомерСтроки", "СуммаДокумента");
	
	Для Каждого СтрокаОстатка Из  ТаблицаОстатков Цикл
		Если НЕ СтрокаОстатка.Оплатить Тогда
			Продолжить;
		КонецЕсли;
		СтрокаСуммы = ТаблицаПоУплаченнымСуммам.Найти(СтрокаОстатка.НомерСтроки, "НомерСтроки");
		Если НЕ СтрокаСуммы = Неопределено Тогда
		   СтрокаОстатка.УплаченнаяСумма = СтрокаСуммы.СуммаДокумента;
		   Если ПолучениеОборотов Тогда
			   СтрокаОстатка.Сумма = СтрокаОстатка.Сумма - СтрокаОстатка.УплаченнаяСумма;
		   КонецЕсли;    		   
	   КонецЕсли; 	   
   КонецЦикла;
    
	
КонецПроцедуры

Процедура СформироватьПлатежныеПорученияПоОстаткам(РежимВвода = Истина, Параметры) Экспорт

	//очистим для строк колонку "Активность", ее мы заполняем для того, что бы понять 
	//была создана новая строка, или уже хранитяс в обработке
	
	Для Каждого Строка Из ПлатежныеПоручения Цикл
		Строка.Активность = Ложь;
	КонецЦикла;
	
	ТаблицаДанных = ПодготовитьТаблицуДанныхПоОстаткам(Параметры);
	ТаблицаПлатежек = ТаблицаСДаннымиПлатежныхПоручений(ТаблицаДанных, Параметры.ПоддержкаРаботыСоСтруктурнымиПодразделениями);

	Для Каждого СтрокаОстатка Из Параметры.ТаблицаОстатков Цикл
		
		Если НЕ СтрокаОстатка.Оплатить Тогда
			Продолжить;
		КонецЕсли;
		
		СуммаПлатежек   = 0;
		УплаченнаяСумма = 0;
		СуммаДокумента = СтрокаОстатка.Сумма;

		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("НомерСтроки", СтрокаОстатка.НомерСтроки);
       	СтрокиПлатежек = ТаблицаПлатежек.НайтиСтроки(СтруктураПоиска);
			
		Для Каждого ДокументПлатежка Из СтрокиПлатежек Цикл
			СтрокаТЧ = Параметры.ТаблицаПлатежныхПоручений.Найти(ДокументПлатежка.Ссылка, "Ссылка");
			Если СтрокаТЧ = Неопределено Тогда					
				НоваяСтрока = Параметры.ТаблицаПлатежныхПоручений.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ДокументПлатежка.Ссылка);
				НоваяСтрока.НомерСтрокиОстатка = СтрокаОстатка.НомерСтроки;
				НоваяСтрока.СтруктурноеПодразделение = ДокументПлатежка.Ссылка.СтруктурноеПодразделениеОтправитель;
			КонецЕсли;
				
			Если Не РежимВвода И  ДокументПлатежка.Ссылка.Проведен Тогда
				СтрокаОстатка.УплаченнаяСумма = СтрокаОстатка.УплаченнаяСумма +  ДокументПлатежка.СуммаДокумента;
				Продолжить;
			КонецЕсли;			
						
			Если ДокументПлатежка.Ссылка.Проведен Тогда
				УплаченнаяСумма = УплаченнаяСумма + ДокументПлатежка.СуммаДокумента;
			Иначе
				СуммаПлатежек = СуммаПлатежек + ДокументПлатежка.СуммаДокумента;	
			КонецЕсли;  			
		КонецЦикла;
		
		Если Не СуммаПлатежек < (СуммаДокумента - (УплаченнаяСумма - СтрокаОстатка.УплаченнаяСумма)) Тогда
			Продолжить;
		Иначе
			СуммаДокумента = СуммаДокумента - СуммаПлатежек;					
		КонецЕсли; 		
					
		Если Не РежимВвода Тогда
			Продолжить;
		КонецЕсли;  			
		
		СуммаДокумента  = СуммаДокумента - (УплаченнаяСумма - СтрокаОстатка.УплаченнаяСумма);
		СтрокаОстатка.УплаченнаяСумма = УплаченнаяСумма; 

			Если СуммаДокумента <= 0 тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаДанных = ТаблицаДанных.Найти(СтрокаОстатка.НомерСтроки, "НомерСтроки");
			Если СтрокаДанных = Неопределено Тогда 
				Продолжить;
			Иначе
				СтрокаДанных.СуммаДокумента = СуммаДокумента;
			КонецЕсли;
			
			НовыйДокумент = СоздатьПлатежноеПоручение(СтрокаДанных, Параметры.ДатаПрекращенияВыводаРНН);				
			Если ЗначениеЗаполнено(НовыйДокумент) Тогда  				
				НоваяСтрока = Параметры.ТаблицаПлатежныхПоручений.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, НовыйДокумент);
				НоваяСтрока.СтруктурноеПодразделение = СтрокаДанных.СтруктурнаяЕдиница;
				НоваяСтрока.НомерСтрокиОстатка		 = СтрокаОстатка.НомерСтроки;
				НоваяСтрока.Активность = Истина;
			КонецЕсли;
			
		КонецЦикла;      		
		
КонецПроцедуры

Функция ТаблицаСДаннымиПлатежныхПоручений(ТаблицаОстатков, ПоддержкаРаботыСоСтруктурнымиПодразделениями, ЕстьПризнакПроведения = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст =     "ВЫБРАТЬ
	                   |	ТаблицаОстатков.НомерСтроки КАК НомерСтроки,
	                   |	ТаблицаОстатков.Контрагент КАК Контрагент,
	                   |	ТаблицаОстатков.Плательщик КАК Организация,
	                   |	ТаблицаОстатков.СтруктурнаяЕдиница КАК СтруктурноеПодразделение,
	                   |	ТаблицаОстатков.ВидНалога КАК ВидНалога,
	                   |	ТаблицаОстатков.СчетУчетаРасчетовСКонтрагентомБУ КАК СчетУчетаРасчетовСКонтрагентомБУ
	                   |ПОМЕСТИТЬ ВТ_ТаблицаОстатков
	                   |ИЗ
	                   |	&ТаблицаОстатков КАК ТаблицаОстатков
	                   |;
	                   |
	                   |////////////////////////////////////////////////////////////////////////////////
	                   |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                   |	ВТ_ТаблицаОстатков.НомерСтроки КАК НомерСтроки,
	                   |	ПлатежноеПоручениеИсходящее.СуммаДокумента КАК СуммаДокумента,
	                   |	ПлатежноеПоручениеИсходящее.Ссылка
	                   |ИЗ
	                   |	Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеПоручениеИсходящее
	                   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ТаблицаОстатков КАК ВТ_ТаблицаОстатков
	                   |		ПО (ВТ_ТаблицаОстатков.Контрагент = ПлатежноеПоручениеИсходящее.Контрагент)
	                   |			И (ВТ_ТаблицаОстатков.ВидНалога = ПлатежноеПоручениеИсходящее.ВидНалога)
	                   |			И (ВТ_ТаблицаОстатков.СчетУчетаРасчетовСКонтрагентомБУ = ПлатежноеПоручениеИсходящее.СчетУчетаРасчетовСКонтрагентомБУ)
	                   |			И (ВТ_ТаблицаОстатков.Организация = ПлатежноеПоручениеИсходящее.Организация)
	                   |			И (ВЫБОР
	                   |				КОГДА &УчетПоСтруктурнымПодразделениям 
	                   |					ТОГДА ВТ_ТаблицаОстатков.СтруктурноеПодразделение = ПлатежноеПоручениеИсходящее.СтруктурноеПодразделениеОтправитель
	                   |				ИНАЧЕ ИСТИНА
	                   |			КОНЕЦ)
	                   |ГДЕ
	                   |	НАЧАЛОПЕРИОДА(ПлатежноеПоручениеИсходящее.Дата, ДЕНЬ) = &ДатаУплаты
	                   |	И ПлатежноеПоручениеИсходящее.ВидОперации = &ВидОперации
	                   |	И НЕ ПлатежноеПоручениеИсходящее.ПометкаУдаления
	                   |	И ВЫБОР
	                   |			КОГДА &ЕстьПризнакПроведения
	                   |				ТОГДА ПлатежноеПоручениеИсходящее.Проведен
	                   |			ИНАЧЕ ИСТИНА
	                   |		КОНЕЦ";
	 
	Запрос.УстановитьПараметр("ДатаУплаты", 		 НачалоДня(ДатаУплаты));
	Запрос.УстановитьПараметр("ЕстьПризнакПроведения", ЕстьПризнакПроведения);
	Запрос.УстановитьПараметр("УчетПоСтруктурнымПодразделениям", ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	Запрос.УстановитьПараметр("ТаблицаОстатков", ТаблицаОстатков);
		
	Запрос.УстановитьПараметр("ВидОперации", Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат;
		
КонецФункции

Функция ЗаполнитьПолучателяПлатежки(ВидНалога,СтруктурнаяЕдиница,ГоловнаяОрганизация)
	
	Контрагент = ПроцедурыНалоговогоУчета.ПолучитьНалоговыйКомитетСтруктурнойЕдиницы(СтруктурнаяЕдиница,
																		ГоловнаяОрганизация,
																		ПолныеПраваПовтИсп.ЗаполнитьИсчислениеНалоговСтруктурныхЕдиниц(),
																		ВидНалога);

	Возврат Контрагент;
КонецФункции

Процедура ОпределитьПлательщикаИПолучателя(СтрокаДанных, ГоловнаяОрганизация)
	
	АнализируетсяГоловнаяОрганизация = Ложь;
	СтрокаДанных.Плательщик  = СтрокаДанных.Организация;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	//для головной организации
	Если СтрокаДанных.Организация = ГоловнаяОрганизация И НЕ ЗначениеЗаполнено(СтрокаДанных.СтруктурнаяЕдиница)  Тогда
		СтрокаДанных.СчетОрганизации	 = СчетОрганизации;		
		АнализируетсяГоловнаяОрганизация = Истина;
	ИначеЕсли ОплачиватьСРасчетногоСчетаФилиала Тогда
		//смотрим, если счет филиала указан, то в качетсве организации выступает сам филиал
		//иначе голова
		Если ЗначениеЗаполнено(СтрокаДанных.СтруктурнаяЕдиница) Тогда
			НайденнаяСтрока = РасчетныеСчетаФилиалов.Найти(СтрокаДанных.СтруктурнаяЕдиница, "Филиал" );
		Иначе	
			НайденнаяСтрока = РасчетныеСчетаФилиалов.Найти(СтрокаДанных.Организация, "Филиал" );
		КонецЕсли;
		
		Если НЕ  НайденнаяСтрока = Неопределено Тогда
			СтрокаДанных.СчетОрганизации = НайденнаяСтрока.РасчетныйСчет;	
		Иначе
			//поропбуем найти основной расчетный счет, если он тенговый
			УправлениеДенежнымиСредствамиСервер.УстановитьБанковскийСчет(СтрокаДанных.СчетОрганизации,СтрокаДанных.Организация, ВалютаРегламентированногоУчета);
		КонецЕсли;
	Иначе
		СтрокаДанных.Организация = Организация;
		СтрокаДанных.СчетОрганизации = СчетОрганизации;		
	КонецЕсли;
	 	
	//Заполняем Получателя денег:
	//1. Смотрим если на счетах раздела 3100 субконто "Контрагенты", если есть Субконто, то получателя берем из него
	//   р/с - основной расчетный счет покупателя
	//	ДЛЯ ВСЕХ НАЛОГОВ, КРОМЕ ПРОЧИХ (СЧЕТ "3190")
	//  2. Если нет Субконто "Контрагенты" на счетах уплаты налогов, то получателя берем из ресурса "Налоговый комитет"
	//    регистра "исчисление налогов стр. единиц" с отбором оп виду налога и филиалу.
	//    р/с - основной расчетный счет покупателя
	//		3. Если нет записи регистре по филлиалу берем запись в регистре "исчисление налогов стр. единиц" по голове
	//         р/с - основной расчетный счет покупателя
	//			4. Если нет записи в регистре по голове, то получателя и р/с получателя берем из спр. "Налоги и сборы 
	//			   и отчисления" по данному виду налога.
	//
	//	ДЛЯ ПРОЧИХ НАЛОГОВ (СЧЕТ "3190")
	// 2. Если нет Субконто "Контрагенты" на счетах уплаты налогов, то получателя и р/с получателя берем из 
	//    спр. "Налоги и сборы и отчисления" по данному виду налога.
                                                                                                     	
	ЕстьКонтрагентНаСчете = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.НаСчетеВедетсяУчетПоКонтрагентам(СтрокаДанных.СчетУчетаРасчетовСКонтрагентомБУ);
	СчетКонтрагента = Справочники.БанковскиеСчета.ПустаяСсылка();
	
	//если есть контрагент на счете, а счет учета =3120, и Контрагент = Неопределено
	//тогда данные получались из регистра накопления, и контрагента взять неоткуда, поэтому берем из регистра сведений
	//"Исчисление структурных единиц"	
	Если ЕстьКонтрагентНаСчете И Не АнализируетсяГоловнаяОрганизация
		ИЛИ Не (СтрокаДанных.СчетУчетаРасчетовСКонтрагентомБУ  = ПланыСчетов.Типовой.ИндивидуальныйПодоходныйНалог И СтрокаДанных.СубконтоДтБУ3 = Неопределено)Тогда
		СтрокаДанных.Контрагент = ?(ТипЗнч(СтрокаДанных.СубконтоДтБУ3) = Тип("СправочникСсылка.Контрагенты"),СтрокаДанных.СубконтоДтБУ3,Справочники.Контрагенты.ПустаяСсылка());
		УправлениеДенежнымиСредствамиСервер.УстановитьБанковскийСчет(СчетКонтрагента, СтрокаДанных.Контрагент, ВалютаРегламентированногоУчета);
		СтрокаДанных.СчетКонтрагента = СчетКонтрагента;
	Иначе
		
		Если СтрокаДанных.СчетУчетаРасчетовСКонтрагентомБУ = ПланыСчетов.Типовой.Акцизы Тогда
			ВидНалога = Перечисления.РазделыНалоговогоУчета.Акциз;
		ИначеЕсли СтрокаДанных.СчетУчетаРасчетовСКонтрагентомБУ = ПланыСчетов.Типовой.КорпоративныйПодоходныйНалог Тогда
			ВидНалога = Перечисления.РазделыНалоговогоУчета.КПН;
		ИначеЕсли СтрокаДанных.СчетУчетаРасчетовСКонтрагентомБУ = ПланыСчетов.Типовой.НалогНаДобавленнуюСтоимость Тогда
			ВидНалога = Перечисления.РазделыНалоговогоУчета.НДС;
		ИначеЕсли  СтрокаДанных.СчетУчетаРасчетовСКонтрагентомБУ = ПланыСчетов.Типовой.ПрочиеНалоги Тогда
			Возврат;
		Иначе //все остальные налоги			
			ВидНалога = Перечисления.РазделыНалоговогоУчета.МестныеНалоги;
		КонецЕсли;                  		
		Контрагент = ЗаполнитьПолучателяПлатежки(ВидНалога, СтрокаДанных.Плательщик, ГоловнаяОрганизация);
		Если ЗначениеЗаполнено(Контрагент) Тогда
			СтрокаДанных.Контрагент = Контрагент;
			УправлениеДенежнымиСредствамиСервер.УстановитьБанковскийСчет(СчетКонтрагента, СтрокаДанных.Контрагент, ВалютаРегламентированногоУчета);
			СтрокаДанных.СчетКонтрагента = СчетКонтрагента;
		КонецЕсли;
		//Если контрагент не заполнен, то он уже заполен данными из спр. "налоги сборы и отчисления"
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьПлатежноеПоручение(СтрокаДанных,ДатаПрекращенияВыводаРНН)
	
	ДокументОбъект = Документы.ПлатежноеПоручениеИсходящее.СоздатьДокумент();
	
	ДокументОбъект.Дата        = ДатаУплаты;
	ДокументОбъект.ДатаВыписки = ДатаУплаты;
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ДокументОбъект);
			
	ЗаполнитьЗначенияСвойств(ДокументОбъект, СтрокаДанных);
		
	ВыводитьРНН = НЕ ЗначениеЗаполнено(ДатаПрекращенияВыводаРНН) ИЛИ ДатаУплаты < ДатаПрекращенияВыводаРНН;
	
	ДокументОбъект.СтруктурноеПодразделениеОтправитель = СтрокаДанных.СтруктурнаяЕдиница;
	
	ДокументОбъект.ВидОперации     = Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога;	
	Если ЗначениеЗаполнено(СтрокаДанных.СчетОрганизации) Тогда
		ДокументОбъект.СчетБанк = ПроцедурыБухгалтерскогоУчета.ПолучитьСчетУчетаДенежныхСредств(СтрокаДанных.СчетОрганизации, ДокументОбъект.СчетБанк.Пустая()).СчетУчетаБУ;		
	КонецЕсли;
	
	// Определяем  реквизиты СП или самой организации нужно использовать
	ОрганизацияДляПечати = ОбщегоНазначенияБК.ПолучитьСтруктурнуюЕдиницу(ДокументОбъект.Организация, ДокументОбъект.СтруктурноеПодразделениеОтправитель);		
	
	Если УправлениеДенежнымиСредствамиСервер.ИспользоватьПечатныеФормыПП2024() Тогда
		Если ЗначениеЗаполнено(ДокументОбъект.СтруктурноеПодразделениеОтправитель) Тогда
			Если ОрганизацияДляПечати = ДокументОбъект.СтруктурноеПодразделениеОтправитель Тогда
				ДокументОбъект.ФактическийПлательщик = Неопределено;
			Иначе
				ДокументОбъект.ФактическийПлательщик = ДокументОбъект.СтруктурноеПодразделениеОтправитель;
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(ДокументОбъект.Организация) Тогда
			Если ОрганизацияДляПечати = ДокументОбъект.Организация Тогда
				ДокументОбъект.ФактическийПлательщик = Неопределено;
			Иначе
				ДокументОбъект.ФактическийПлательщик = ДокументОбъект.Организация;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;  
	 		
	Если ЗначениеЗаполнено(ДокументОбъект.СчетОрганизации.ТекстКорреспондента) Тогда
		ДокументОбъект.ТекстПлательщика = ДокументОбъект.СчетОрганизации.ТекстКорреспондента;
	Иначе
		ДокументОбъект.ТекстПлательщика = ?(НЕ ЗначениеЗаполнено(ОрганизацияДляПечати.НаименованиеПолное), ОрганизацияДляПечати.Наименование, ОрганизацияДляПечати.НаименованиеПолное);
	КонецЕсли;

	Если НЕ ДокументОбъект.СчетКонтрагента.Пустая() Тогда
		ДокументОбъект.ТекстПолучателя = ДокументОбъект.СчетКонтрагента.ТекстКорреспондента;
	Иначе
		ДокументОбъект.ТекстПолучателя = ?(НЕ ЗначениеЗаполнено(ДокументОбъект.Контрагент.НаименованиеПолное), ДокументОбъект.Контрагент.Наименование, ДокументОбъект.Контрагент.НаименованиеПолное);
	КонецЕсли;

	
	Если ТипЗНЧ(СтрокаДанных.СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций")
		ИЛИ ТипЗНЧ(СтрокаДанных.СтруктурнаяЕдиница) = Тип("СправочникСсылка.Организации") Тогда
		ДокументОбъект.РННПлательщика = ?(ВыводитьРНН, СтрокаДанных.Плательщик.РНН, СтрокаДанных.Плательщик.ИдентификационныйНомер);	
	КонецЕсли;
	
	Если НЕ ДокументОбъект.Контрагент.Пустая() Тогда
		ДокументОбъект.РННПолучателя = ?(ВыводитьРНН, ДокументОбъект.Контрагент.РНН,ДокументОбъект.Контрагент.ИдентификационныйКодЛичности);
	КонецЕсли; 	
	
	Попытка     	
		ДокументОбъект.Записать();
		Возврат ДокументОбъект.Ссылка;	
	Исключение 
		ТекстСообщения = НСтр("ru='Не сформировано платежное поручение исходящее (перечисление налога) на %1 тенге (%2)'");		
		ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ТекстСообщения, СтрокаДанных.СуммаДокумента, СтрокаДанных.СуммаДокумента.НазначениеПлатежа));					
		Возврат Документы.ПлатежноеПоручениеИсходящее.ПустаяСсылка();	
	
	КонецПопытки;

КонецФункции

#КонецЕсли