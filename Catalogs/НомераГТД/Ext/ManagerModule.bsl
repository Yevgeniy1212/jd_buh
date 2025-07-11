﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПоискСозданиеОбновлениеНомеровГТД

// Общий порядок работы:
// Получить пустую таблицу для работы с номерами ГТД, вызвав ПустаяТаблицаНомеровГТД().
// Заполнить полученную таблицу номеров ГТД и передать её в метод НайтиСоздатьОбновитьНомераГТД().
// После выполнения метода НайтиСоздатьОбновитьНомераГТД() извлечь данные из таблицы ТаблицаНомеровГТД.  

Функция ПустаяТаблицаНомеровГТД() Экспорт
	
	// Тип булево был добавлен, чтобы в качестве значения ячейки можно было указывать Неопределено,
	// т.к. если поле составного типа, то для него можно указать Неопределено.
	//
	// Если для поля указывается значение Неопределено, то предполагается,
	// что в процедуре ОбновитьНомераГТД() данное поле не будет перезаполняться.
	// Это нужно, если в документе нет такого поля, например, в документе ГТДИмпорт,
	// нет поля РегистрационныйНомерЭСФ.
	
	ТаблицаНомеровГТД = Новый ТаблицаЗначений;
	
	ТипСтрока = Новый ОписаниеТипов("Строка, Булево", , Новый КвалификаторыСтроки(400));
	
	ТаблицаНомеровГТД.Колонки.Добавить("Идентификатор", ТипСтрока);
	ТаблицаНомеровГТД.Колонки.Добавить("НомерСтроки", ТипСтрока);
	ТаблицаНомеровГТД.Колонки.Добавить("НомерГТД", ТипСтрока);
	ТаблицаНомеровГТД.Колонки.Добавить("НомерСтрокиГТД", ТипСтрока);	
	ТаблицаНомеровГТД.Колонки.Добавить("КодТНВЭД", ТипСтрока);
	ТаблицаНомеровГТД.Колонки.Добавить("ГСВС", Новый ОписаниеТипов("СправочникСсылка.НоменклатураГСВС, Булево"));
	ТаблицаНомеровГТД.Колонки.Добавить("НаименованиеТовара", ТипСтрока);
	ТаблицаНомеровГТД.Колонки.Добавить("СтранаПроисхожденияТовара", Новый ОписаниеТипов("СправочникСсылка.КлассификаторСтранМира, Булево"));
	ТаблицаНомеровГТД.Колонки.Добавить("СпособПроисхожденияТовара", Новый ОписаниеТипов("ПеречислениеСсылка.СпособыПроисхожденияТоваров, Булево")); 
	ТаблицаНомеровГТД.Колонки.Добавить("РегистрационныйНомерЭСФ", ТипСтрока);	
	ТаблицаНомеровГТД.Колонки.Добавить("СсылкаНомерГТД", Новый ОписаниеТипов("СправочникСсылка.НомераГТД, Булево"));
	ТаблицаНомеровГТД.Колонки.Добавить("ПризнакПроисхождения", ТипСтрока);
	
	Возврат ТаблицаНомеровГТД;
	
КонецФункции

// Получает на вход ТаблицаНомеровГТД, после чего изменяет ее и возвращает обратно.
// В возвращаемой ТаблицаНомеровГТД всегда заполнена колонка СсылкаНомерГТД.
//
// Сначала пытается найти существующие номера ГТД в справочнике НомераГТД.
// Затем, если номера ГТД не удалось найти, то создает и записывает новые элементы справочника.
// После этого обновляет новые и старые элементы справочника по данным ТаблицаНомеровГТД.
//
// Возвращает ТаблицаНомеровГТД с заполненным полем СсылкаНомерГТД.
//
Процедура НайтиСоздатьОбновитьНомераГТД(ТаблицаНомеровГТД, СинонимТаблицы, ДокументСсылка) Экспорт
	
	Попытка
		
		НачатьТранзакцию();
	
		НайтиНомераГТД(ТаблицаНомеровГТД);
		СоздатьНомераГТД(ТаблицаНомеровГТД, СинонимТаблицы, ДокументСсылка);						
		ОбновитьНомераГТД(ТаблицаНомеровГТД);
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		ВызватьИсключение ПодробноеПредставлениеОшибки;
		
	КонецПопытки;
	
КонецПроцедуры

// Процедура пытается заполнить колонку СсылкаНомерГТД в таблице ТаблицаНомеровГТД.
// Если в ячейки колонки уже есть значение, то оно не заполняется.
// Для заполнения колонки процедура ищет элементы в справочнике НомераГТД по:
// номеру ГТД и номеру строки ГТД и коду ТН ВЭД.
Процедура НайтиНомераГТД(ТаблицаНомеровГТД) Экспорт
	
	// При поиске элементов справочника НомераГТД из документа ЭСФ,	
	// если у строки таблицы Товары не заполнен номер строки ГТД (Товары.ДополнительныеДанные),
	// то для двух строк с разными кодами ТН ВЭД и наименованиями будет найден один элемент справочника НомераГТД,
	// что является не правильным, т.к. у этих строк разные коды ТН ВЭД
	// и для них нужно создвать два элемента справочника НомераГТД.
	//
	// Поэтому поиск выполняется по реквизитам НомерГТД, НомерСтрокиГТД, КодТНВЭД, Наименование.
	// Тажке поиск по наименованию нужен для корректного создания номеров ГТД в ГТДИмпорт.
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаНомеровГТД.Идентификатор,
	|	ТаблицаНомеровГТД.НомерГТД,
	|	ТаблицаНомеровГТД.НомерСтрокиГТД,
	|	ТаблицаНомеровГТД.КодТНВЭД,
	|	ТаблицаНомеровГТД.НаименованиеТовара,
	|	ТаблицаНомеровГТД.СсылкаНомерГТД,
	|	ТаблицаНомеровГТД.РегистрационныйНомерЭСФ,
	|	ТаблицаНомеровГТД.СтранаПроисхожденияТовара,
	|	ТаблицаНомеровГТД.СпособПроисхожденияТовара,
	|	ТаблицаНомеровГТД.ПризнакПроисхождения	
	|ПОМЕСТИТЬ ВТ_ТаблицаНомеровГТД
	|ИЗ
	|	&ТаблицаНомеровГТД КАК ТаблицаНомеровГТД
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ 
	|	ВТ_ТаблицаНомеровГТД.Идентификатор,
	|	ВТ_ТаблицаНомеровГТД.НомерГТД,
	|	НомераГТД.Ссылка КАК СсылкаНомерГТД
	|ИЗ
	|	ВТ_ТаблицаНомеровГТД КАК ВТ_ТаблицаНомеровГТД
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НомераГТД КАК НомераГТД
	|		ПО ВТ_ТаблицаНомеровГТД.НомерГТД = НомераГТД.Код
	|			И ВТ_ТаблицаНомеровГТД.НомерСтрокиГТД = НомераГТД.НомерСтрокиГТД
	|			И ВТ_ТаблицаНомеровГТД.КодТНВЭД = НомераГТД.КодТНВЭД
	|			И ВТ_ТаблицаНомеровГТД.НаименованиеТовара = НомераГТД.НаименованиеТовара
	|			И ВТ_ТаблицаНомеровГТД.РегистрационныйНомерЭСФ = НомераГТД.РегистрационныйНомерЭСФ
	|			И ВТ_ТаблицаНомеровГТД.СтранаПроисхожденияТовара = НомераГТД.СтранаПроисхожденияТовара
	|			И ВТ_ТаблицаНомеровГТД.СпособПроисхожденияТовара = НомераГТД.СпособПроисхожденияТовара
	|			И ВТ_ТаблицаНомеровГТД.ПризнакПроисхождения = НомераГТД.ПризнакПроисхождения
	|ГДЕ	
	|	НЕ НомераГТД.ПометкаУдаления";
	
	КопияТаблицыНомеровГТД = ТаблицаНомеровГТД.Скопировать();
	
	// При заполнении источников происхождения в таблице ОС документа ГТДИмпорт
	// устанавливается: СтрокаНомерГТД.КодТНВЭД = Неопределено,
	// это нужно, чтобы для ОС создавались номера ГТД,
	// т.к. в СоздатьНомераГТД() номера ГТД не создадутся, если СтрокаНомерГТД.КодТНВЭД = "",
	// а в таблице ОС нет реквизита КодТНВЭД.
	// Код ниже исключает неявное преобразование из Неопределено в строку в тексте запроса,
	// т.к. предполагается, что оно может привести к ошибкам на некоторых ОС или версиях 1С.
	Для Каждого СтрокаКопии Из КопияТаблицыНомеровГТД Цикл
		Если СтрокаКопии.КодТНВЭД = Неопределено Тогда
			СтрокаКопии.КодТНВЭД = "";	
		КонецЕсли;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТаблицаНомеровГТД", КопияТаблицыНомеровГТД);
	
	//очистим старые ссылки
	//ТаблицаНомеровГТД.ЗаполнитьЗначения(Справочники.НомераГТД.ПустаяСсылка(),"СсылкаНомерГТД");
	Выборка = Запрос.Выполнить().Выбрать();	
	Пока Выборка.Следующий() Цикл
		
		// Номера ГТД ищутся, только если указана строка НомерГТД.
		// Это нужно, чтобы после обновления ИБ, когда пользователь записывает
		// документы ГТДИмпорт, если в них не указан номер ГТД,
		// не подставлять в реквизит ТЧ Товары и ОС найденный ГТД,
		// т.к. до обновления номер ГТД был пустым.
		
		Если ЗначениеЗаполнено(Выборка.НомерГТД) Тогда
			СтрокаНомерГТД = ТаблицаНомеровГТД.Найти(Выборка.Идентификатор, "Идентификатор");
			Если ЗначениеЗаполнено(СтрокаНомерГТД.СсылкаНомерГТД) Тогда
				Продолжить;
			КонецЕсли;
			СтрокаНомерГТД.СсылкаНомерГТД = Выборка.СсылкаНомерГТД;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьНомераГТД(ТаблицаНомеровГТД, СинонимТаблицы, ДокументСсылка) Экспорт
	
	ВедетсяУчетПоТоварамОрганизацийБУ   = НомераГТДСервер.ВедетсяУчетПоТоварамОрганизаций(ДокументСсылка.Дата);
	Для Каждого СтрокаНомерГТД Из ТаблицаНомеровГТД Цикл
				
		// Новые источники происхождения создаются, только если указана строка НомерГТД.
		// Это нужно, чтобы после обновления ИБ, когда пользователь записывает
		// документы ГТДИмпорт, если в них не указан номер ГТД,
		// не создавались новые пустые номера ГТД.
		Если НЕ ЗначениеЗаполнено(СтрокаНомерГТД.НомерГТД) 
			И ТипЗнч(ДокументСсылка) <> Тип("ДокументСсылка.ЭСФ")Тогда
			
			Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов") Тогда
				НаименованиеПоля = НСтр("ru = 'Регистрационный номер'");
			ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ГТДИмпорт") Тогда
				НаименованиеПоля = НСтр("ru = 'Номер декларации (ГТД)'");	
			Иначе
				НаименованиеПоля = НСтр("ru = 'Номер ГТД'"); // Для безопасности. Код сюда не должен заходить.	
			КонецЕсли;
			
			ТекстСообщения = НСтр("ru = 'В документе не заполнено поле ""%1"", поэтому источник происхождения не создан, строка №%2, таблица: ""%3"", документ: ""%4"".'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения, НаименованиеПоля, СтрокаНомерГТД.НомерСтроки, СинонимТаблицы, ДокументСсылка);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументСсылка);
			
		КонецЕсли;
		
		Если ВедетсяУчетПоТоварамОрганизацийБУ Тогда
			// Также новые источники происхождения создаются, только если заполнен код ТН ВЭД.
			// Это нужно, чтобы избежать ситуации: Пользователь вводит ЗавялениеОВвозе или ГТДИмпорт, 
			// не указал коды ТН ВЭД, нажал записать, создался один источник происхождения для двух строк.
			// Пользователь указал в строках коды ТН ВЭД, но источник происхождения все равно уже один.		
			Если СтрокаНомерГТД.КодТНВЭД = "" И ТипЗнч(ДокументСсылка) <> Тип("ДокументСсылка.ЭСФ") Тогда				
				ТекстСообщения = НСтр("ru = 'Источник происхождения не создан, так как не указан код ТН ВЭД, строка №%1, таблица: ""%2"", документ: ""%3"".'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаНомерГТД.НомерСтроки, СинонимТаблицы, ДокументСсылка);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументСсылка);				
			КонецЕсли;			
			
			// Также новые источники происхождения создаются, только если заполнен признак происхождения.
			// Данное поле является ключевым.
			Если СтрокаНомерГТД.ПризнакПроисхождения = "" Тогда
				ТекстСообщения = НСтр("ru = 'Источник происхождения не создан, так как не указан признак происхождения, строка №%1, таблица: ""%2"", документ: ""%3"".'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаНомерГТД.НомерСтроки, СинонимТаблицы, ДокументСсылка);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументСсылка);
			КонецЕсли;
			
			// Также новые источники происхождения создаются, только если заполнено наименование товара. Из правил:
			//"В графе 3/1 «Наименование товаров в соответствии с Декларацией на товары или заявлением о ввозе товаров и уплате косвенных налогов» 
			//указывается наименование товара, отраженное в графе 31 основного (добавочного) листа декларации на товары при импорте с территории государств,
			//не являющихся государствами-членами ЕАЭС, или в графе 2 заявления о ввозе товаров и уплате косвенных налогов при импорте с территории государства-члена ЕАЭС."
			Если СтрокаНомерГТД.НаименованиеТовара = "" И СинонимТаблицы <> "ОС" И ТипЗнч(ДокументСсылка) <> Тип("ДокументСсылка.ЭСФ") Тогда				
				ТекстСообщения = НСтр("ru = 'Источник происхождения не создан, так как не указано наименование товара, строка №%1, таблица: ""%2"", документ: ""%3"".'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаНомерГТД.НомерСтроки, СинонимТаблицы, ДокументСсылка);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументСсылка);				
			КонецЕсли;
			
			Если ((НЕ ЗначениеЗаполнено(СтрокаНомерГТД.НомерГТД) ИЛИ СтрокаНомерГТД.КодТНВЭД = "" ИЛИ (СтрокаНомерГТД.НаименованиеТовара = "" И СинонимТаблицы <> "ОС"))
				И ТипЗнч(ДокументСсылка) <> Тип("ДокументСсылка.ЭСФ"))
				ИЛИ НЕ СтрокаНомерГТД.СсылкаНомерГТД.Пустая() 
				ИЛИ СтрокаНомерГТД.ПризнакПроисхождения = "" Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		ОбъектНомерГТД = Справочники.НомераГТД.СоздатьЭлемент();
		
		ОбъектНомерГТД.Код = СтрокаНомерГТД.НомерГТД;
		ОбъектНомерГТД.НомерСтрокиГТД = СтрокаНомерГТД.НомерСтрокиГТД;
		ОбъектНомерГТД.КодТНВЭД = СтрокаНомерГТД.КодТНВЭД;
		ОбъектНомерГТД.ГСВС = СтрокаНомерГТД.ГСВС;
		ОбъектНомерГТД.НаименованиеТовара = СтрокаНомерГТД.НаименованиеТовара;			
		ОбъектНомерГТД.СтранаПроисхожденияТовара = СтрокаНомерГТД.СтранаПроисхожденияТовара;
		ОбъектНомерГТД.СпособПроисхожденияТовара = СтрокаНомерГТД.СпособПроисхожденияТовара;
		ОбъектНомерГТД.РегистрационныйНомерЭСФ = СтрокаНомерГТД.РегистрационныйНомерЭСФ;
		ОбъектНомерГТД.ПризнакПроисхождения = СтрокаНомерГТД.ПризнакПроисхождения;
		
		//заполним наименование товара
		МассивВариантовНаименований = ВариантыНаименованийНомераГТД(ОбъектНомерГТД);
		ОбъектНомерГТД.Наименование = МассивВариантовНаименований[МассивВариантовНаименований.ВГраница()];
		
		ОбъектНомерГТД.Записать();
		
		// Созданный элемент справочника НомераГТД может быть подставлен в несколько строк таблицы ТаблицаНомеровГТД,
		// например, когда заполняются источники происхождений в таблице ОС или в таблице Товары указано
		// несколько строк с одинаковым наименованием и кодом ТН ВЭД.
		// Важно! Ключи поиска в данном методе должны совпадать с ключами поиска в методе НайтиНомераГТД().		
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("НомерГТД", СтрокаНомерГТД.НомерГТД);
		ПараметрыПоиска.Вставить("НомерСтрокиГТД", СтрокаНомерГТД.НомерСтрокиГТД);
		ПараметрыПоиска.Вставить("КодТНВЭД", СтрокаНомерГТД.КодТНВЭД);
		ПараметрыПоиска.Вставить("НаименованиеТовара", СтрокаНомерГТД.НаименованиеТовара);
		ПараметрыПоиска.Вставить("СпособПроисхожденияТовара", СтрокаНомерГТД.СпособПроисхожденияТовара);
		ПараметрыПоиска.Вставить("СтранаПроисхожденияТовара", СтрокаНомерГТД.СтранаПроисхожденияТовара);
		ПараметрыПоиска.Вставить("ПризнакПроисхождения", СтрокаНомерГТД.ПризнакПроисхождения);
		
		МассивСтрокДляЗаполнения = ТаблицаНомеровГТД.НайтиСтроки(ПараметрыПоиска);
		
		Для Каждого НайденнаяСтрокаДляЗаполнения Из МассивСтрокДляЗаполнения Цикл						
			НайденнаяСтрокаДляЗаполнения.СсылкаНомерГТД = ОбъектНомерГТД.Ссылка;		
		КонецЦикла;
		
	КонецЦикла;	
	
КонецПроцедуры

Процедура ОбновитьНомераГТД(ТаблицаНомеровГТД) Экспорт
	
	Для Каждого СтрокаНомерГТД Из ТаблицаНомеровГТД Цикл
		
		Если ЗначениеЗаполнено(СтрокаНомерГТД.СсылкаНомерГТД) Тогда
		
			ОбъектНомерГТД = СтрокаНомерГТД.СсылкаНомерГТД.ПолучитьОбъект();
			
			Если СтрокаНомерГТД.НомерГТД <> Неопределено Тогда
				ОбъектНомерГТД.Код = СтрокаНомерГТД.НомерГТД;
			КонецЕсли;
			
			Если СтрокаНомерГТД.НомерСтрокиГТД <> Неопределено Тогда
				ОбъектНомерГТД.НомерСтрокиГТД = СтрокаНомерГТД.НомерСтрокиГТД;
			КонецЕсли;
			
			Если СтрокаНомерГТД.КодТНВЭД <> Неопределено Тогда
				ОбъектНомерГТД.КодТНВЭД = СтрокаНомерГТД.КодТНВЭД;
			КонецЕсли;
			
			Если СтрокаНомерГТД.НаименованиеТовара <> Неопределено Тогда
				ОбъектНомерГТД.НаименованиеТовара = СтрокаНомерГТД.НаименованиеТовара;			
			КонецЕсли;
			
			Если СтрокаНомерГТД.СтранаПроисхожденияТовара <> Неопределено Тогда
				ОбъектНомерГТД.СтранаПроисхожденияТовара = СтрокаНомерГТД.СтранаПроисхожденияТовара;
			КонецЕсли;
			
			Если СтрокаНомерГТД.СпособПроисхожденияТовара <> Неопределено Тогда
				ОбъектНомерГТД.СпособПроисхожденияТовара = СтрокаНомерГТД.СпособПроисхожденияТовара;
			КонецЕсли;
			
			Если СтрокаНомерГТД.РегистрационныйНомерЭСФ <> Неопределено Тогда
				ОбъектНомерГТД.РегистрационныйНомерЭСФ = СтрокаНомерГТД.РегистрационныйНомерЭСФ;
			КонецЕсли;
			
			Если СтрокаНомерГТД.ПризнакПроисхождения <> Неопределено Тогда
				ОбъектНомерГТД.ПризнакПроисхождения = СтрокаНомерГТД.ПризнакПроисхождения;
			КонецЕсли;
			
			МассивВариантовНаименований = ВариантыНаименованийНомераГТД(ОбъектНомерГТД);
			ОбъектНомерГТД.Наименование = МассивВариантовНаименований[МассивВариантовНаименований.ВГраница()];
			
			ОбъектНомерГТД.Записать();
		
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает различные варианты наименования для элемента справочника Номера ГТД.
//
// Параметры:
//  НомерГТД - Номер ГДТ для которого нужно получить варианты наименований .
//
// Возвращаемое значение:
//  Массив - Варианты наименования номера ГТД.
//
Функция ВариантыНаименованийНомераГТД(Знач НомерГТД) Экспорт
	
	МассивНаименований = Новый Массив();
		
	Если НомерГТД.СпособПроисхожденияТовара = Перечисления.СпособыПроисхожденияТоваров.СТ1 Тогда
		
		СтрокаНаименования = СокрЛП(НомерГТД.Код) 
		+ ?(ЗначениеЗаполнено(НомерГТД.ДатаСертификатаПроисхожденияТовара), "/" + Формат(НомерГТД.ДатаСертификатаПроисхожденияТовара, "ДФ=dd.MM.yyyy"), "");	
		
		МассивНаименований.Добавить(СтрокаНаименования);
		
	Иначе
		
		СтрокаНаименования = СокрЛП(НомерГТД.Код)
		+ ?(ЗначениеЗаполнено(НомерГТД.НомерСтрокиГТД), "/" + СокрЛП(НомерГТД.НомерСтрокиГТД), "")
		+ ?(ЗначениеЗаполнено(НомерГТД.КодТНВЭД), "/" + СокрЛП(НомерГТД.КодТНВЭД), "");
		
		МассивНаименований.Добавить(СтрокаНаименования); 		

	КонецЕсли; 	
	
	Если ЗначениеЗаполнено(НомерГТД.СтранаПроисхожденияТовара) Тогда
		
		СтрокаНаименования = СтрокаНаименования + "/" + СокрЛП(НомерГТД.СтранаПроисхожденияТовара.Наименование);
		МассивНаименований.Добавить(СтрокаНаименования);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерГТД.СпособПроисхожденияТовара) Тогда
		
		Если ЗначениеЗаполнено(НомерГТД.ПризнакПроисхождения) Тогда
			Разделитель = "/" +  НомерГТД.ПризнакПроисхождения + " ";
		Иначе
			Разделитель = "/"
		КонецЕсли;
		
		СтрокаНаименования = СтрокаНаименования  + Разделитель + ЭСФКлиентСервер.СпособыПроисхожденияТоваровИСЭСФ(НомерГТД.СпособПроисхожденияТовара);
		МассивНаименований.Добавить(СтрокаНаименования);
		
	КонецЕсли; 				         	
	
	Возврат МассивНаименований;

КонецФункции

#КонецОбласти

#Область ОбновлениеИБ

Процедура ЗаполнитьПризнакПроисхождения() Экспорт
	
	//Заполненный код ТНВЭД 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НомераГТД.Ссылка,
		|	НомераГТД.СпособПроисхожденияТовара,
		|	НомераГТД.КодТНВЭД,
		|	НомераГТД.СтранаПроисхожденияТовара
		|ИЗ
		|	Справочник.НомераГТД КАК НомераГТД
		|ГДЕ
		|	НомераГТД.ПометкаУдаления = ЛОЖЬ
		|	И НомераГТД.ПризнакПроисхождения = """"
		|	И ВЫБОР
		|			КОГДА НомераГТД.СпособПроисхожденияТовара = ЗНАЧЕНИЕ(Перечисление.СпособыПроисхожденияТоваров.ПустаяСсылка)
		|					ИЛИ НомераГТД.СпособПроисхожденияТовара = ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.СпособыПроисхожденияТоваров.СТ1)
		|				ТОГДА НомераГТД.КодТНВЭД <> """"
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			// Устанавливаем управляемую блокировку, чтобы провести ответственное чтение объекта.
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(Выборка.Ссылка.Метаданные().ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			ОбъектДляОбработки = Выборка.Ссылка.ПолучитьОбъект();
			Если ОбъектДляОбработки = Неопределено Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ПереченьИзъятий = ПолучитьПереченьИзъятий();
			
			ОбъектДляОбработки.ПризнакПроисхождения = ПолучитьПризнакПроисхождения(Выборка.СпособПроисхожденияТовара,
				Выборка.СтранаПроисхожденияТовара, ПереченьИзъятий.Найти(Выборка.КодТНВЭД) <> Неопределено);
				
			Если ОбъектДляОбработки.ПризнакПроисхождения = "" Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОбъектДляОбработки);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать %1 по причине: %2'"); 			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	//Код ТНВЭД не заполнен остаток по регистру ТоварыОрганизацииБУ есть
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НомераГТД.Ссылка
		|ПОМЕСТИТЬ ВТ_Источники
		|ИЗ
		|	Справочник.НомераГТД КАК НомераГТД
		|ГДЕ
		|	НомераГТД.ПометкаУдаления = ЛОЖЬ
		|	И НомераГТД.ПризнакПроисхождения = """"
		|	И НомераГТД.КодТНВЭД = """"
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТоварыОрганизацийБУОстатки.Товар КАК Товар,
		|	ТоварыОрганизацийБУОстатки.НомерГТД
		|ПОМЕСТИТЬ ВТ_Товары
		|ИЗ
		|	РегистрНакопления.ТоварыОрганизацийБУ.Остатки(
		|			&Дата,
		|			НомерГТД В
		|				(ВЫБРАТЬ
		|					Т.Ссылка
		|				ИЗ
		|					ВТ_Источники КАК Т)) КАК ТоварыОрганизацийБУОстатки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Товар
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Товары.НомерГТД КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ТоварыСПониженнойСтавкойПошлин.Товар ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ВПеречне,
		|	ВТ_Товары.НомерГТД.СтранаПроисхожденияТовара КАК СтранаПроисхожденияТовара,
		|	ВТ_Товары.НомерГТД.СпособПроисхожденияТовара КАК СпособПроисхожденияТовара
		|ИЗ
		|	ВТ_Товары КАК ВТ_Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварыСПониженнойСтавкойПошлин КАК ТоварыСПониженнойСтавкойПошлин
		|		ПО ВТ_Товары.Товар = ТоварыСПониженнойСтавкойПошлин.Товар";
	
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			// Устанавливаем управляемую блокировку, чтобы провести ответственное чтение объекта.
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(Выборка.Ссылка.Метаданные().ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			ОбъектДляОбработки = Выборка.Ссылка.ПолучитьОбъект();
			Если ОбъектДляОбработки = Неопределено Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбъектДляОбработки.ПризнакПроисхождения = ПолучитьПризнакПроисхождения(Выборка.СпособПроисхожденияТовара,
				Выборка.СтранаПроисхожденияТовара,Выборка.ВПеречне);
				
			Если ОбъектДляОбработки.ПризнакПроисхождения = "" Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОбъектДляОбработки);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	//Код ТНВЭД не заполнен остатков по регистру ТоварыОрганизацииБУ нет
		Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НомераГТД.Ссылка
		|ИЗ
		|	Справочник.НомераГТД КАК НомераГТД
		|ГДЕ
		|	НомераГТД.ПометкаУдаления = ЛОЖЬ
		|	И НомераГТД.ПризнакПроисхождения = """"";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			// Устанавливаем управляемую блокировку, чтобы провести ответственное чтение объекта.
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(Выборка.Ссылка.Метаданные().ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			ОбъектДляОбработки = Выборка.Ссылка.ПолучитьОбъект();
			Если ОбъектДляОбработки = Неопределено Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбъектДляОбработки.ПризнакПроисхождения = "5";
			
			Если ОбъектДляОбработки.ПризнакПроисхождения = "" Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОбъектДляОбработки);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПереченьИзъятий()
	
	ПереченьМакет = РегистрыСведений.ТоварыСПониженнойСтавкойПошлин.ПолучитьМакетПереченьИзъятий();
	МассивИзъятий = Новый Массив;
	Если ПереченьМакет <> Неопределено Тогда
		МассивИзъятий = ОбщегоНазначения.ЗначениеИзСтрокиXML(ПереченьМакет.ПолучитьТекст()).ВыгрузитьКолонку("КодТНВЭД");
	КонецЕсли;
	
	Возврат МассивИзъятий;
	
КонецФункции

Функция ПолучитьПризнакПроисхождения(СпособПроисхожденияТовара,СтранаПроисхожденияТовара,ВПеречне)
	
	Если Не ЗначениеЗаполнено(СпособПроисхожденияТовара) Тогда
		
		Если Не ЗначениеЗаполнено(СтранаПроисхожденияТовара) Тогда
			Возврат "5";
		ИначеЕсли СтранаПроисхожденияТовара = Справочники.КлассификаторСтранМира.Казахстан
			И  ВПеречне Тогда
			Возврат "3";
		ИначеЕсли СтранаПроисхожденияТовара = Справочники.КлассификаторСтранМира.Казахстан
			И НЕ  ВПеречне  Тогда
			Возврат "4";
		ИначеЕсли СтранаПроисхожденияТовара <> Справочники.КлассификаторСтранМира.Казахстан
			И  ВПеречне  Тогда
			Возврат "1";
		ИначеЕсли СтранаПроисхожденияТовара <> Справочники.КлассификаторСтранМира.Казахстан
			И  НЕ ВПеречне Тогда
			Возврат "2";
		КонецЕсли;
		
	ИначеЕсли СпособПроисхожденияТовара = Перечисления.СпособыПроисхожденияТоваров.СТ1 Тогда
		
		Если ВПеречне Тогда
			Возврат "3";
		Иначе
			Возврат "4";
		КонецЕсли;
		
	ИначеЕсли СпособПроисхожденияТовара = Перечисления.СпособыПроисхожденияТоваров.ЕТТЕАЭС
		ИЛИ СпособПроисхожденияТовара = Перечисления.СпособыПроисхожденияТоваров.ВТО
		ИЛИ СпособПроисхожденияТовара = Перечисления.СпособыПроисхожденияТоваров.ТС Тогда
		Возврат "1";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Процедура ЗаполнитьНомерСтрокиГТД() Экспорт
	
	ДатаПерехода = Константы.ДатаПереходаНаУчетПоТоварамОрганизацийВРазрезеНомеровГТДБУ.Получить();
	Если ДатаПерехода <> Дата(1,1,1) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ТоварыОрганизацийБУОстатки.Организация КАК Организация,
		|	ТоварыОрганизацийБУОстатки.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
		|	ТоварыОрганизацийБУОстатки.Товар КАК Товар,
		|	ТоварыОрганизацийБУОстатки.НомерГТД КАК НомерГТД,
		|	ТоварыОрганизацийБУОстатки.Склад КАК Склад
		|ПОМЕСТИТЬ ВТ_Остатки
		|ИЗ
		|	РегистрНакопления.ТоварыОрганизацийБУ.Остатки(&Дата, ) КАК ТоварыОрганизацийБУОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары.НомерСтроки КАК НомерСтроки,
		|	ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары.Номенклатура КАК Номенклатура,
		|	ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары.Ссылка КАК Ссылка,
		|	ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары.НомерГТД КАК НомерГТД
		|ПОМЕСТИТЬ ВТ_ОстаткиПоДокументу
		|ИЗ
		|	ВТ_Остатки КАК ВТ_Остатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов.Товары КАК ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары
		|		ПО ВТ_Остатки.Организация = ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары.Ссылка.Организация
		|			И ВТ_Остатки.СтруктурноеПодразделение = ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары.Ссылка.СтруктурноеПодразделение
		|			И ВТ_Остатки.Товар = ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары.Номенклатура
		|			И ВТ_Остатки.НомерГТД = ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары.НомерГТД
		|			И ВТ_Остатки.Склад = ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалоговТовары.Ссылка.ДокументОснование.Склад
		|ГДЕ
		|	ВТ_Остатки.НомерГТД.НомерСтрокиГТД = """"
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ОстаткиПоДокументу.Ссылка КАК Ссылка,
		|	ВТ_ОстаткиПоДокументу.НомерГТД КАК НомерГТД
		|ПОМЕСТИТЬ ВТ_ИсточникиВОстатках
		|ИЗ
		|	ВТ_ОстаткиПоДокументу КАК ВТ_ОстаткиПоДокументу
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ОстаткиПоДокументу.Ссылка,
		|	ВТ_ОстаткиПоДокументу.НомерГТД
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(ВТ_ОстаткиПоДокументу.НомерСтроки) > 1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Ссылка КАК Ссылка,
		|	Товары.НомерГТД КАК НомерГТД
		|ПОМЕСТИТЬ ВТ_ИсточникиНеВОстатках
		|ИЗ
		|	Документ.ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов.Товары КАК Товары
		|ГДЕ
		|	Товары.НомерГТД.НомерСтрокиГТД = """"
		|	И Товары.Ссылка.Дата >= &ДатаНачала
		|	И НЕ Товары.Ссылка В
		|				(ВЫБРАТЬ
		|					Т.Ссылка
		|				ИЗ
		|					ВТ_ОстаткиПоДокументу КАК Т)
		|
		|СГРУППИРОВАТЬ ПО
		|	Товары.Ссылка,
		|	Товары.НомерГТД
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(Товары.НомерСтроки) > 1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Ссылка,
		|	Товары.НомерСтроки,
		|	Товары.НомерГТД
		|ИЗ
		|	Документ.ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка.Дата >= &ДатаНачала
		|	И Товары.НомерГТД.НомерСтрокиГТД = """"
		|	И НЕ (Товары.Ссылка, Товары.НомерГТД) В
		|				(ВЫБРАТЬ
		|					Т.Ссылка,
		|					Т.НомерГТД
		|				ИЗ
		|					ВТ_ИсточникиВОстатках КАК Т
		|		
		|				ОБЪЕДИНИТЬ ВСЕ
		|		
		|				ВЫБРАТЬ
		|					Т.Ссылка,
		|					Т.НомерГТД
		|				ИЗ
		|					ВТ_ИсточникиНеВОстатках КАК Т)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Ссылка КАК Ссылка,
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	Товары.НомерГТД КАК НомерГТД
		|ИЗ
		|	Документ.ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка.Дата >= &ДатаНачала
		|	И Товары.НомерГТД.НомерСтрокиГТД = """"
		|	И (Товары.Ссылка, Товары.НомерГТД) В
		|			(ВЫБРАТЬ
		|				Т.Ссылка,
		|				Т.НомерГТД
		|			ИЗ
		|				ВТ_ИсточникиВОстатках КАК Т
		|		
		|			ОБЪЕДИНИТЬ ВСЕ
		|		
		|			ВЫБРАТЬ
		|				Т.Ссылка,
		|				Т.НомерГТД
		|			ИЗ
		|				ВТ_ИсточникиНеВОстатках КАК Т)
		|ИТОГИ
		|	КОЛИЧЕСТВО(НомерСтроки)
		|ПО
		|	Ссылка,
		|	НомерГТД
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Ссылка,
		|	Товары.НомерСтроки,
		|	Товары.НомерГТД,
		|	Товары.НомерГТД.НомерСтрокиГТД КАК НомерСтрокиГТД
		|ИЗ
		|	Документ.ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка.Дата >= &ДатаНачала
		|	И Товары.НомерГТД.НомерСтрокиГТД <> """"";
		
		Запрос.УстановитьПараметр("Дата", ТекущаяДата());
		Запрос.УстановитьПараметр("ДатаНачала", ДатаПерехода);
		МассивРезультатовЗапроса = Запрос.ВыполнитьПакет();
		
		ВыборкаДляОбработки = МассивРезультатовЗапроса[4].Выбрать();
		ВыборкаПустыеПоДокументам = МассивРезультатовЗапроса[5].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ВыборкаЗаполненные = МассивРезультатовЗапроса[6].Выбрать();
		
		Пока ВыборкаДляОбработки.Следующий() Цикл
			
			НачатьТранзакцию();
			
			Попытка
				
				// Устанавливаем управляемую блокировку, чтобы провести ответственное чтение объекта.
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить(ВыборкаДляОбработки.НомерГТД.Метаданные().ПолноеИмя());
				ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаДляОбработки.НомерГТД);
				Блокировка.Заблокировать();
				
				ОбъектДляОбработки = ВыборкаДляОбработки.НомерГТД.ПолучитьОбъект();
				Если ОбъектДляОбработки = Неопределено Тогда
					ОтменитьТранзакцию();
					Продолжить;
				КонецЕсли;
				
				ОбъектДляОбработки.НомерСтрокиГТД = Строка(ВыборкаДляОбработки.НомерСтроки);
				
				Если ОбъектДляОбработки.ПризнакПроисхождения = "" Тогда
					ОтменитьТранзакцию();
					Продолжить;
				КонецЕсли;
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОбъектДляОбработки);
				
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ОтменитьТранзакцию();
				ТекстСообщения = НСтр("ru = 'Не удалось обработать %Ссылка% по причине: %Причина%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", ВыборкаДляОбработки.НомерГТД);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
					ВыборкаДляОбработки.НомерГТД.Метаданные(), ВыборкаДляОбработки.НомерГТД, ТекстСообщения);
				
			КонецПопытки;
			
		КонецЦикла;
		
		Пока ВыборкаПустыеПоДокументам.Следующий() Цикл
			
			ВыборкаПустыеПоИсточникам = ВыборкаПустыеПоДокументам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПустыеПоИсточникам.Следующий() Цикл
				ВыборкаПустые = ВыборкаПустыеПоИсточникам.Выбрать();
				НомераСтрок = "";
				Пока ВыборкаПустые.Следующий() Цикл
					НомераСтрок = НомераСтрок + + Строка(ВыборкаПустые.НомерСтроки)+ ",";
				КонецЦикла;
				Если НомераСтрок <> "" Тогда
					НомераСтрок = Лев(НомераСтрок,СтрДлина(НомераСтрок) - 1);
					ТекстСообщения = НСтр("ru = 'Не удалось обработать номер строки источника ""%НомерГТД%"" по причине: 
						|	источник присутствует в нескольких строках: ""%НомераСтрок%"" документа ""%Документ%""'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерГТД%", ВыборкаПустыеПоИсточникам.НомерГТД);
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", ВыборкаПустыеПоДокументам.Ссылка);
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомераСтрок%", НомераСтрок);
					
					ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
						ВыборкаПустыеПоИсточникам.НомерГТД.Метаданные(), ВыборкаПустыеПоИсточникам.НомерГТД, ТекстСообщения);
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
		
		Пока ВыборкаЗаполненные.Следующий() Цикл
			
			Если ВыборкаЗаполненные.НомерСтроки <> Число(ВыборкаЗаполненные.НомерСтрокиГТД) Тогда
				ТекстСообщения = НСтр("ru = 'Номер строки ""%НомерСтрокиГТД%"" источника ""%НомерГТД%"" не соответствует строке ""%НомерСтроки%"" заявления ""%Документ%""'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерГТД%", ВыборкаЗаполненные.НомерГТД);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтрокиГТД%", ВыборкаЗаполненные.НомерСтрокиГТД);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", ВыборкаЗаполненные.НомерСтроки);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", ВыборкаЗаполненные.Ссылка);
				
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
					ВыборкаЗаполненные.НомерГТД.Метаданные(), ВыборкаЗаполненные.НомерГТД, ТекстСообщения);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли