﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция возвращает соответствие налогоплательщиков для всех возможных структурных единиц
//
// Возвращаемое значение:
//	Соответствие со следующей структурой
//		Ключ - СправочникСсылка.Организации/ПодразделенияОрганизации - все возможные структурные единицы
//		Значение - Структура 
//						Ключ - строка с название вида налога (как имена значения перечисления РазделыНалоговогоУчета)
//						Значение - Структура с такими же полями, как и ресурсы в регистре сведений ИсчислениеНалоговСтруктурныхЕдиниц
//
// Пример обращения к результату:
//		Результат[Справочники.Организации.НайтиПоИмени("ТОО ОГО-ГО")].НалогиСЗаработнойПлаты.Налогоплательщик
// 
Функция ЗаполнитьИсчислениеНалоговСтруктурныхЕдиниц() Экспорт

	Если НЕ Константы.ПоддержкаРаботыСоСтруктурнымиПодразделениями.Получить() Тогда
		// если в базе не поддерживается работа со структурными единица - ничего не делаем
		Возврат Неопределено;
	КонецЕсли;

	Результат = Новый Соответствие();

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК СтруктурнаяЕдиница,
	|	РазделыНалоговогоУчета.Ссылка КАК РазделНалоговогоУчета,
	|	ЕСТЬNULL(ИсчислениеНалогов.Налогоплательщик, Организации.Ссылка) КАК Налогоплательщик,
	|	ВЫБОР
	|		КОГДА НЕ(ИсчислениеНалогов.НалоговыйКомитет ЕСТЬ NULL) 
	|			ТОГДА ВЫБОР
	|					КОГДА ИсчислениеНалогов.НалоговыйКомитет = &ПустойКонтрагент
	|						ТОГДА Организации.НалоговыйКомитет
	|					ИНАЧЕ ИсчислениеНалогов.НалоговыйКомитет
	|				  КОНЕЦ
	|		ИНАЧЕ Организации.НалоговыйКомитет
	|	КОНЕЦ КАК НалоговыйКомитет
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Перечисление.РазделыНалоговогоУчета КАК РазделыНалоговогоУчета
	|		ПО ИСТИНА
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов
	|		ПО Организации.Ссылка = ИсчислениеНалогов.СтруктурнаяЕдиница
	|			И РазделыНалоговогоУчета.Ссылка = ИсчислениеНалогов.РазделНалоговогоУчета
	|";
	
	Если Метаданные.Справочники.Найти("ПодразделенияОрганизаций") <> Неопределено Тогда
		// если есть этот справочник, значит это бухгалтерия
		// дополним запрос
		Запрос.Текст = Запрос.Текст + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодразделенияОрганизаций.Ссылка КАК СтруктурнаяЕдиница,
		|	РазделыНалоговогоУчета.Ссылка КАК РазделНалоговогоУчета,
		|	ВЫБОР
		|		КОГДА ПодразделенияОрганизаций.ЯвляетсяСтруктурнымПодразделением
		|			ТОГДА ЕСТЬNULL(ИсчислениеНалогов_Подр.Налогоплательщик, ЕСТЬNULL(ИсчислениеНалогов_Орг.Налогоплательщик, ПодразделенияОрганизаций.Владелец)) 
		|		ИНАЧЕ ЕСТЬNULL(ИсчислениеНалогов_Орг.Налогоплательщик, ПодразделенияОрганизаций.Владелец)
		|	КОНЕЦ КАК Налогоплательщик,
		|	ВЫБОР
		|		КОГДА ПодразделенияОрганизаций.ЯвляетсяСтруктурнымПодразделением
		|			ТОГДА ВЫБОР
		|					КОГДА НЕ(ИсчислениеНалогов_Подр.НалоговыйКомитет ЕСТЬ NULL)
		|							И ИсчислениеНалогов_Подр.НалоговыйКомитет <> &ПустойКонтрагент
		|						ТОГДА ИсчислениеНалогов_Подр.НалоговыйКомитет
		|					КОГДА НЕ(ИсчислениеНалогов_Орг.НалоговыйКомитет ЕСТЬ NULL)
		|							И ИсчислениеНалогов_Орг.НалоговыйКомитет <> &ПустойКонтрагент
		|						ТОГДА ИсчислениеНалогов_Орг.НалоговыйКомитет
		|					ИНАЧЕ ПодразделенияОрганизаций.Владелец.НалоговыйКомитет
		|				  КОНЕЦ
		|		КОГДА НЕ(ИсчислениеНалогов_Орг.НалоговыйКомитет ЕСТЬ NULL)
		|				И ИсчислениеНалогов_Орг.НалоговыйКомитет <> &ПустойКонтрагент
		|			ТОГДА ИсчислениеНалогов_Орг.НалоговыйКомитет
		|		ИНАЧЕ ПодразделенияОрганизаций.Владелец.НалоговыйКомитет
		|	КОНЕЦ КАК НалоговыйКомитет
		|ИЗ
		|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ Перечисление.РазделыНалоговогоУчета КАК РазделыНалоговогоУчета
		|		ПО ИСТИНА
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов_Подр
		|		ПО ПодразделенияОрганизаций.Ссылка = ИсчислениеНалогов_Подр.СтруктурнаяЕдиница
		|			И ПодразделенияОрганизаций.ЯвляетсяСтруктурнымПодразделением
		|			И РазделыНалоговогоУчета.Ссылка = ИсчислениеНалогов_Подр.РазделНалоговогоУчета
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов_Орг
		|		ПО ПодразделенияОрганизаций.Владелец = ИсчислениеНалогов_Орг.СтруктурнаяЕдиница
		|			И РазделыНалоговогоУчета.Ссылка = ИсчислениеНалогов_Орг.РазделНалоговогоУчета
		|";
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// соотвествие, в котором храним строковые имена разделов налогового учета
	СоответствиеРазделовНУ = Новый Соответствие();
	Для Каждого РазделНУ Из Метаданные.Перечисления.РазделыНалоговогоУчета.ЗначенияПеречисления Цикл
		ИмяРазделаНУ = РазделНУ.Имя;
		СоответствиеРазделовНУ.Вставить(Перечисления.РазделыНалоговогоУчета[ИмяРазделаНУ], ИмяРазделаНУ);
	КонецЦикла;	
	
	Пока Выборка.Следующий() Цикл
		
		ИмяРазделаНУ = СоответствиеРазделовНУ[Выборка.РазделНалоговогоУчета];
		
		ЭлементСоответствияДляСтруктурнойЕдиницы = Результат[Выборка.СтруктурнаяЕдиница];
		Если ЭлементСоответствияДляСтруктурнойЕдиницы = Неопределено Тогда
			Результат.Вставить(Выборка.СтруктурнаяЕдиница, Новый Структура());
			ЭлементСоответствияДляСтруктурнойЕдиницы = Результат[Выборка.СтруктурнаяЕдиница];
		КонецЕсли;
		
		СтруктураИсчислениеНалогов = Новый Структура();
		СтруктураИсчислениеНалогов.Вставить("Налогоплательщик", Выборка.Налогоплательщик);
		СтруктураИсчислениеНалогов.Вставить("НалоговыйКомитет", Выборка.НалоговыйКомитет);
		
		// записываем в формируемое соответствие
		ЭлементСоответствияДляСтруктурнойЕдиницы.Вставить(ИмяРазделаНУ, СтруктураИсчислениеНалогов);
	
	КонецЦикла;

	Возврат Результат;

КонецФункции // ЗаполнитьИсчислениеНалоговСтруктурныхЕдиниц()

Функция ЗаполнениеУчетнойПолитикиПоПерсоналуОрганизации() Экспорт

	парамПустаяОрганизация                = Справочники.Организации.ПустаяСсылка();
	УчетнаяПолитикаПоПерсоналуОрганизации = Новый Соответствие;
	УчетнаяПолитикаПоПерсоналуОрганизации.Вставить(парамПустаяОрганизация, Новый Структура("ВедениеУчетаПоГоловнойОрганизации, УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка, ВариантУчетаКадровыхПерестановок, РасчетКоэффициентаНарастающимИтогом, РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок", 
																							Истина, Ложь, Перечисления.ВариантыУчетаКадровыхПерестановок.ПустаяСсылка(), Ложь, Ложь));

	Запрос = Новый Запрос(УчетнаяПолитикаСервер.ПолучитьТекстЗапросаУчетнойПолитикиПоПерсоналу());					
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		УчетнаяПолитикаПоПерсоналуОрганизации.Вставить(Выборка.Организация, 
		                                      Новый Структура("ВедениеУчетаПоГоловнойОрганизации, УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка, ВариантУчетаКадровыхПерестановок, РасчетКоэффициентаНарастающимИтогом, РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок", 
											  				Выборка.ВедениеУчетаПоГоловнойОрганизации, Выборка.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка, Выборка.ВариантУчетаКадровыхПерестановок, Выборка.РасчетКоэффициентаНарастающимИтогом, Выборка.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок));

	КонецЦикла;
	
	Возврат УчетнаяПолитикаПоПерсоналуОрганизации;
	
КонецФункции

Функция СформироватьТаблицуУчетнойПолитикиПоПерсоналу(УчетнаяПолитика = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если УчетнаяПолитика = Неопределено Тогда
		УчетнаяПолитика = ЗаполнениеУчетнойПолитикиПоПерсоналуОрганизации();
	КонецЕсли;
		
	ТаблицаУчетнойПолитики = Новый ТаблицаЗначений;
	ТаблицаУчетнойПолитики.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаУчетнойПолитики.Колонки.Добавить("ВедениеУчетаПоГоловнойОрганизации", Новый ОписаниеТипов("Булево"));
	ТаблицаУчетнойПолитики.Колонки.Добавить("УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка", Новый ОписаниеТипов("Булево"));	
	ТаблицаУчетнойПолитики.Колонки.Добавить("ВариантУчетаКадровыхПерестановок", Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыУчетаКадровыхПерестановок"));	
	ТаблицаУчетнойПолитики.Колонки.Добавить("РасчетКоэффициентаНарастающимИтогом", Новый ОписаниеТипов("Булево"));	
	ТаблицаУчетнойПолитики.Колонки.Добавить("РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок", Новый ОписаниеТипов("Булево"));	
	
	Для Каждого ЭлементУчетнойПолитики Из УчетнаяПолитика Цикл
		НоваяСтрока = ТаблицаУчетнойПолитики.Добавить();
		НоваяСтрока.Организация = ЭлементУчетнойПолитики.Ключ;
		НоваяСтрока.ВедениеУчетаПоГоловнойОрганизации 	 = ЭлементУчетнойПолитики.Значение["ВедениеУчетаПоГоловнойОрганизации"];
		НоваяСтрока.УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка = ЭлементУчетнойПолитики.Значение["УчитыватьКадровыеПерестановкиПриРасчетеСреднегоЗаработка"];
		НоваяСтрока.ВариантУчетаКадровыхПерестановок 	 = ЭлементУчетнойПолитики.Значение["ВариантУчетаКадровыхПерестановок"];
		НоваяСтрока.РасчетКоэффициентаНарастающимИтогом  = ЭлементУчетнойПолитики.Значение["РасчетКоэффициентаНарастающимИтогом"];
		НоваяСтрока.РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок  = ЭлементУчетнойПолитики.Значение["РассчитыватьКоэффициентИндексацииВПределахКадровыхПерестановок"];
	КонецЦикла;   	
		
	Возврат ТаблицаУчетнойПолитики;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

