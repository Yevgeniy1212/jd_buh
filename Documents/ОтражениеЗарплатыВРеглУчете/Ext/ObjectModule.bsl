﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область УправлениеДоступом

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	СписокФизЛиц = ОтражениеВУчете.ВыгрузитьКолонку("ФизЛицо");;
	
	РасчетЗарплатыСервер.ЗаполнитьНаборыПоОрганизацииСтрутурномуПодразделениюСпискуФизЛиц(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение", СписокФизЛиц);
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(ОтражениеВУчете);

	КраткийСоставДокумента = ПроцедурыУправленияПерсоналомСервер.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "ФизЛицо");

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	МассивНепроверяемыхРеквизитов.Добавить("СчетДт");
	МассивНепроверяемыхРеквизитов.Добавить("СчетКт");
	МассивНепроверяемыхРеквизитов.Добавить("СчетДтНУ");  // добавлены, так как проверка на заполненность выполняется в ПроверитьЗаполнениеТабличнойЧастиПострочно()
	МассивНепроверяемыхРеквизитов.Добавить("СчетКтНУ");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПроверитьЗаполнениеТабличнойЧастиПострочно(ОтражениеВУчете.Выгрузить(), Отказ);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ОтражениеЗарплатыВРеглУчете.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Если вдруг не удалось получить параметры проведения и не установлен флаг Отказ, то просто выйдем из проведения
	Если ПараметрыПроведения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	//ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	Если ПараметрыПроведения.ТаблицаОтражениеВУчетеБУ.Количество() <> 0 
		И ПараметрыПроведения.ТаблицаОтражениеВУчетеНУ.Количество() <> 0 Тогда 
		
		ТаблицаПоБУ = ПараметрыПроведения.ТаблицаОтражениеВУчетеБУ;
		ТаблицаПоНУ = ПараметрыПроведения.ТаблицаОтражениеВУчетеНУ;
		
		// Отражаем сведения по затратам на ремонт производственных ОС
		ОтразитьСведенияПоЗатратамНаРемонтПроизводственныхОС(ПараметрыПроведения.Реквизиты, ТаблицаПоБУ, ТаблицаПоНУ, Движения, Отказ);
				
		//дополним проводки по резервам НУ
		Если ПараметрыПроведения.ТаблицаПоРезервам.Количество() <> 0 Тогда			
			ДополнитьПроводкиПоРезервамНУ(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаПоРезервам, ТаблицаПоБУ, ТаблицаПоНУ);			
		КонецЕсли;
														
		// по БУ		
		СформироватьДвиженияПоОтражениюВУчетеВБУ(ПараметрыПроведения.Реквизиты, ТаблицаПоБУ, Движения, Отказ);		
		
		// по НУ		
		СформироватьДвиженияПоОтражениюВУчетеВНУ(ПараметрыПроведения.Реквизиты, ТаблицаПоНУ, Движения, Отказ);
	КонецЕсли;
													
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ	

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, Отказ)
	
	// получим список счетов учета резервов по вознаграждениям работникам, 
    // чтобы потом их не учитывать при проверке заполненности счетов НУ
    МассивСчетовРезервов = Новый Массив;
    МассивСчетовРезервов.Добавить(ПланыСчетов.Типовой.КраткосрочныеОценочныеОбязательстваПоВознаграждениямРаботникам);
    МассивСчетовРезервов.Добавить(ПланыСчетов.Типовой.ДолгосрочныеОценочныеОбязательстваПоВознаграждениямРаботникам);
    СписокСчетовРезервов = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСписокВыбораСчетов(МассивСчетовРезервов);
	
	ОрганизацияПлательщикНалогаНаПрибыль = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата);
	ВидСубконтоРаботникиОрганизаций = ПланыВидовХарактеристик.ВидыСубконтоТиповые.РаботникиОрганизаций;
	СоответствиеСчетаБУВлияющиеНаНалогооблагаемыйДоход = Новый Соответствие;
	ВедениеУчетаВременныхРазницБалансовымМетодом    = УчетнаяПолитикаСервер.ВедетсяУчетВременныхРазницБалансовымМетодом(Организация, Дата);
		
	РезультатПоОтражениюВУчете   = СформироватьЗапросПоОтражениюВУчете(ПроверяемаяТабличнаячасть);
	ВыборкаПоСтрокамДокумента = РезультатПоОтражениюВУчете.Выбрать();
	
	Пока ВыборкаПоСтрокамДокумента.Следующий() Цикл		
		СтрокаНачалаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В строке номер %1 табл. части ""Отражение в учете"": '"), СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки));
		
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.СчетДт) Тогда
			ТекстСообщения = НСтр("ru='не указан счет дебета!'");
			Поле = "ОтражениеВУчете" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетДт";
			ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.СчетКт) Тогда
			ТекстСообщения = НСтр("ru='не указан счет кредита!'");
			Поле = "ОтражениеВУчете" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетКт";
			ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		// проверим правильность отнесения данных сотрудника
		Для ДтКт = 1 По 2 Цикл
			Если ДтКт = 1 Тогда
				СтрокаДтКт = "Дт";
			Иначе
				СтрокаДтКт = "Кт";
			КонецЕсли;
			Для СчСк = 1 По 3 Цикл
				Если ВыборкаПоСтрокамДокумента[СтрокаДтКт+"ВидСубконто"+СчСк] = ВидСубконтоРаботникиОрганизаций Тогда
					Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента["Субконто"+СтрокаДтКт+СчСк]) И ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицо) 
						 И ВыборкаПоСтрокамДокумента.ФизЛицо <> ВыборкаПоСтрокамДокумента["Субконто"+СтрокаДтКт+СчСк] Тогда
						ТекстСообщения = НСтр("ru='данные не соответствуют физлицу!'");
						Поле = "ОтражениеВУчете" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ФизЛицо";
						ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
					КонецЕсли
				КонецЕсли;
			КонецЦикла;
			
			// проверим, влияет ли счет БУ на налогооблагаемый доход, тогда потребуем заполнение счета НУ
			СчетБУ = ВыборкаПоСтрокамДокумента["Счет" + СтрокаДтКт];
			КорСчетБУ = ?(ДтКт = 1, ВыборкаПоСтрокамДокумента["СчетКт"], ВыборкаПоСтрокамДокумента["СчетДт"]);
			СчетВлияетНаНалогооблагаемыйДоход = СоответствиеСчетаБУВлияющиеНаНалогооблагаемыйДоход[СчетБУ];
			Если СчетВлияетНаНалогооблагаемыйДоход = Неопределено Тогда
				СчетВлияетНаНалогооблагаемыйДоход = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.ВлияетНаНалогооблагаемыйДоход(СчетБУ);
				СоответствиеСчетаБУВлияющиеНаНалогооблагаемыйДоход.Вставить(СчетБУ, СчетВлияетНаНалогооблагаемыйДоход);
			КонецЕсли;
			
			Если (ОрганизацияПлательщикНалогаНаПрибыль И СчетВлияетНаНалогооблагаемыйДоход) Или ВедениеУчетаВременныхРазницБалансовымМетодом Тогда
				// исключим из проверки проводки по резервам отпусков, если не ведется учета временных разниц балансовым методом
				Если ВедениеУчетаВременныхРазницБалансовымМетодом Или СписокСчетовРезервов.НайтиПоЗначению(КорСчетБУ) = Неопределено Тогда
					Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента["Счет"+СтрокаДтКт+"НУ"]) Тогда
						Если ДтКт = 1 Тогда
							ТекстСообщения = НСтр("ru = 'не указан счет дебета налогового учета!'");
						Иначе
							ТекстСообщения = НСтр("ru = 'не указан счет кредита налогового учета!'");
						КонецЕсли;
						Поле = "ОтражениеВУчете" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Счет"+СтрокаДтКт+"НУ";
						ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", ?(СчетВлияетНаНалогооблагаемыйДоход, Отказ, Истина));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;

		Если ВыборкаПоСтрокамДокумента.УжеРанееОтражен Тогда
			Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицо) Тогда
				ТекстСообщения = НСтр("ru='по работнику уже формировали проводки по заработной плате за месяц!'");
				Поле = "ОтражениеВУчете" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ФизЛицо";
				ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);				
			КонецЕсли;
		КонецЕсли;
				
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьЗапросПоОтражениюВУчете(ПроверяемаяТабличнаячасть)
	
	Запрос = Новый Запрос;
 	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", 				 Ссылка);
	Запрос.УстановитьПараметр("Организация", 				 	 Организация);
	Запрос.УстановитьПараметр("ПериодРегистрации", 				 НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ВидСубконтоРаботникиОрганизаций", ПланыВидовХарактеристик.ВидыСубконтоТиповые.РаботникиОрганизаций);
	Запрос.УстановитьПараметр("ВедениеУчетаПоСотрудникам", 		 ОбщегоНазначенияБК.ПолучитьПризнакВеденияУчетаПоСотрудникам());
	Запрос.УстановитьПараметр("ТаблицаДокумента", 				 ПроверяемаяТабличнаячасть);	
		
	ТекстЗапроса = "ВЫБРАТЬ
	                |	ТаблицаДокумента.НомерСтроки,
	                |	ТаблицаДокумента.ФизЛицо,	                
	                |	ТаблицаДокумента.СчетДт,
				    |	ТаблицаДокумента.СубконтоДт1,
				    |	ТаблицаДокумента.СубконтоДт2,
				    |	ТаблицаДокумента.СубконтоДт3,
				    |	ТаблицаДокумента.СчетКт,
				    |	ТаблицаДокумента.СубконтоКт1,
				    |	ТаблицаДокумента.СубконтоКт2,
				    |	ТаблицаДокумента.СубконтоКт3,
				    |	ТаблицаДокумента.СчетДтНУ,
				    |	ТаблицаДокумента.СубконтоДтНУ1,
				    |	ТаблицаДокумента.СубконтоДтНУ2,
				    |	ТаблицаДокумента.СубконтоДтНУ3,
				    |	ТаблицаДокумента.СчетКтНУ,
				    |	ТаблицаДокумента.СубконтоКтНУ1,
				    |	ТаблицаДокумента.СубконтоКтНУ2,
				    |	ТаблицаДокумента.СубконтоКтНУ3				    
	                |ПОМЕСТИТЬ ВТ_ТаблицаОтражениеВУчете
	                |ИЗ
	                |	&ТаблицаДокумента КАК ТаблицаДокумента
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ  РАЗРЕШЕННЫЕ
					|	ТаблицаОтражениеВУчете.ФизЛицо,
					|	ТаблицаОтражениеВУчете.НомерСтроки КАК НомерСтроки,
					|	ТаблицаОтражениеВУчете.СчетДт,
					|	ТаблицаОтражениеВУчете.СчетДт.Наименование КАК НаименованиеСчетДт,	
					|	ВЫБОР
					|		КОГДА ДтВидСубконто1.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоДт1 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДт1
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоДт1 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДт1
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоДт1,
					|	ДтВидСубконто1.ВидСубконто КАК ДтВидСубконто1,
					|	ВЫБОР
					|		КОГДА ДтВидСубконто2.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоДт2 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДт2
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоДт2 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДт2
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоДт2,
					|	ДтВидСубконто2.ВидСубконто КАК ДтВидСубконто2,
					|	ВЫБОР
					|		КОГДА ДтВидСубконто3.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоДт3 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДт3
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоДт3 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДт3
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоДт3,
					|	ДтВидСубконто3.ВидСубконто КАК ДтВидСубконто3,
					|	ТаблицаОтражениеВУчете.СчетКт,	
					|	ВЫБОР
					|		КОГДА КтВидСубконто1.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоКт1 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКт1
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоКт1 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКт1
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоКт1,
					|	КтВидСубконто1.ВидСубконто КАК КтВидСубконто1,
					|	ВЫБОР
					|		КОГДА КтВидСубконто2.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоКт2 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКт2
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоКт2 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКт2
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоКт2,
					|	КтВидСубконто2.ВидСубконто КАК КтВидСубконто2,
					|	ВЫБОР
					|		КОГДА КтВидСубконто3.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоКт3 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКт3
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоКт3 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКт3
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоКт3,
					|	КтВидСубконто3.ВидСубконто КАК КтВидСубконто3,
					|	ТаблицаОтражениеВУчете.СчетДтНУ,
					|	ВЫБОР
					|		КОГДА ДтВидСубконтоНУ1.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоДтНУ1 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДтНУ1
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоДтНУ1 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДтНУ1
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоДтНУ1,
					|	ДтВидСубконтоНУ1.ВидСубконто КАК ДтВидСубконтоНУ1,
					|	ВЫБОР
					|		КОГДА ДтВидСубконтоНУ2.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоДтНУ2 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДтНУ2
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоДтНУ1 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДтНУ2
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоДтНУ2,
					|	ДтВидСубконтоНУ2.ВидСубконто КАК ДтВидСубконтоНУ2,
					|	ВЫБОР
					|		КОГДА ДтВидСубконтоНУ3.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоДтНУ3 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДтНУ3
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоДтНУ3 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоДтНУ3
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоДтНУ3,
					|	ДтВидСубконтоНУ3.ВидСубконто КАК ДтВидСубконтоНУ3,	
					|	ТаблицаОтражениеВУчете.СчетКтНУ,
					|	ВЫБОР
					|		КОГДА КтВидСубконтоНУ1.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоКтНУ1 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКтНУ1
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоКтНУ1 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКтНУ1
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоКтНУ1,
					|	КтВидСубконтоНУ1.ВидСубконто КАК КтВидСубконтоНУ1,
					|	ВЫБОР
					|		КОГДА КтВидСубконтоНУ2.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоКтНУ2 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКтНУ2
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоКтНУ2 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКтНУ2
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоКтНУ2,
					|	КтВидСубконтоНУ2.ВидСубконто КАК КтВидСубконтоНУ2,
					|	ВЫБОР
					|		КОГДА КтВидСубконтоНУ3.ВидСубконто = &ВидСубконтоРаботникиОрганизаций
					|			ТОГДА ВЫБОР
					|					КОГДА ТаблицаОтражениеВУчете.СубконтоКтНУ3 = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|						ТОГДА ТаблицаОтражениеВУчете.ФизЛицо
					|					ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКтНУ3
					|				КОНЕЦ
					|		ИНАЧЕ ВЫБОР
					|				КОГДА (НЕ &ВедениеУчетаПоСотрудникам)
					|						И ТаблицаОтражениеВУчете.СубконтоКтНУ3 ССЫЛКА Справочник.ФизическиеЛица
					|					ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
					|				ИНАЧЕ ТаблицаОтражениеВУчете.СубконтоКтНУ3
					|			КОНЕЦ
					|	КОНЕЦ КАК СубконтоКтНУ3,
					|	КтВидСубконтоНУ3.ВидСубконто КАК КтВидСубконтоНУ3,					
					|	ВЫБОР
					|		КОГДА РанееПроведенныеРаботники.ФизЛицо ЕСТЬ NULL 
					|			ТОГДА ЛОЖЬ
					|		ИНАЧЕ ИСТИНА
					|	КОНЕЦ КАК УжеРанееОтражен
					|ИЗ
					|	ВТ_ТаблицаОтражениеВУчете КАК ТаблицаОтражениеВУчете					
					|	
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Типовой.ВидыСубконто КАК ДтВидСубконто1
					|		ПО (ДтВидСубконто1.Ссылка = ТаблицаОтражениеВУчете.СчетДт)
					|			И (ДтВидСубконто1.НомерСтроки = 1)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Типовой.ВидыСубконто КАК ДтВидСубконто2
					|		ПО (ДтВидСубконто2.Ссылка = ТаблицаОтражениеВУчете.СчетДт)
					|			И (ДтВидСубконто2.НомерСтроки = 2)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Типовой.ВидыСубконто КАК ДтВидСубконто3
					|		ПО (ДтВидСубконто3.Ссылка = ТаблицаОтражениеВУчете.СчетДт)
					|			И (ДтВидСубконто3.НомерСтроки = 3)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Типовой.ВидыСубконто КАК КтВидСубконто1
					|		ПО (КтВидСубконто1.Ссылка = ТаблицаОтражениеВУчете.СчетКт)
					|			И (КтВидСубконто1.НомерСтроки = 1)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Типовой.ВидыСубконто КАК КтВидСубконто2
					|		ПО (КтВидСубконто2.Ссылка = ТаблицаОтражениеВУчете.СчетКт)
					|			И (КтВидСубконто2.НомерСтроки = 2)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Типовой.ВидыСубконто КАК КтВидСубконто3
					|		ПО (КтВидСубконто3.Ссылка = ТаблицаОтражениеВУчете.СчетКт)
					|			И (КтВидСубконто3.НомерСтроки = 3)	
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Налоговый.ВидыСубконто КАК ДтВидСубконтоНУ1
					|		ПО (ДтВидСубконтоНУ1.Ссылка = ТаблицаОтражениеВУчете.СчетДтНУ)
					|			И (ДтВидСубконтоНУ1.НомерСтроки = 1)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Налоговый.ВидыСубконто КАК ДтВидСубконтоНУ2
					|		ПО (ДтВидСубконтоНУ2.Ссылка = ТаблицаОтражениеВУчете.СчетДтНУ)
					|			И (ДтВидСубконтоНУ2.НомерСтроки = 2)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Налоговый.ВидыСубконто КАК ДтВидСубконтоНУ3
					|		ПО (ДтВидСубконтоНУ3.Ссылка = ТаблицаОтражениеВУчете.СчетДтНУ)
					|			И (ДтВидСубконтоНУ3.НомерСтроки = 3)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Налоговый.ВидыСубконто КАК КтВидСубконтоНУ1
					|		ПО (КтВидСубконтоНУ1.Ссылка = ТаблицаОтражениеВУчете.СчетКтНУ)
					|			И (КтВидСубконтоНУ1.НомерСтроки = 1)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Налоговый.ВидыСубконто КАК КтВидСубконтоНУ2
					|		ПО (КтВидСубконтоНУ2.Ссылка = ТаблицаОтражениеВУчете.СчетКтНУ)
					|			И (КтВидСубконтоНУ2.НомерСтроки = 2)
					|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Налоговый.ВидыСубконто КАК КтВидСубконтоНУ3
					|		ПО (КтВидСубконтоНУ3.Ссылка = ТаблицаОтражениеВУчете.СчетКтНУ)
					|			И (КтВидСубконтоНУ3.НомерСтроки = 3)
					|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
					|			ОтражениеЗарплатыВРеглУчете.ФизЛицо КАК ФизЛицо
					|		ИЗ
					|			Документ.ОтражениеЗарплатыВРеглУчете.ОтражениеВУчете КАК ОтражениеЗарплатыВРеглУчете
					|		ГДЕ
					|			ОтражениеЗарплатыВРеглУчете.Ссылка.Организация = &Организация
					|			И ОтражениеЗарплатыВРеглУчете.Ссылка.Проведен
					|			И ОтражениеЗарплатыВРеглУчете.Ссылка.ПериодРегистрации = &ПериодРегистрации
					|			И ОтражениеЗарплатыВРеглУчете.Ссылка <> &ДокументСсылка) КАК РанееПроведенныеРаботники
					|		ПО ТаблицаОтражениеВУчете.ФизЛицо = РанееПроведенныеРаботники.ФизЛицо 
					|
					|УПОРЯДОЧИТЬ ПО
					|	ТаблицаОтражениеВУчете.НомерСтроки";

	Запрос.Текст = ТекстЗапроса;
		
	Возврат Запрос.Выполнить();
	
КонецФункции // СформироватьЗапросПоОтражениюВУчете()

Процедура ОтразитьСведенияПоЗатратамНаРемонтПроизводственныхОС(ТаблицаРеквизиты, ТаблицаОтражениеВУчетеБУ, ТаблицаОтражениеВУчетеНУ, Движения, Отказ)
	
	Реквизиты = ТаблицаРеквизиты[0];
	
	Если Реквизиты.ВедениеУчетаВременныхРазницБалансовымМетодом = Истина Тогда
		
		Для Каждого СтрокаДанных Из ТаблицаОтражениеВУчетеБУ Цикл
			СтрокаДанныхНУ = ТаблицаОтражениеВУчетеНУ.Найти(СтрокаДанных.НомерСтроки, "НомерСтроки"); 
			Если СтрокаДанныхНУ = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ПроцедурыНалоговогоУчета.ОтразитьРасходыНаРемонтПроизводственныхОС(Движения.Налоговый,
										Новый Структура("СчетБУ, СубконтоБУ1, СубконтоБУ2,СубконтоБУ3",
										СтрокаДанных.СчетДт, СтрокаДанных.СубконтоДт1, СтрокаДанных.СубконтоДт2, СтрокаДанных.СубконтоДт3),
										Новый Структура("СчетНУ, СубконтоНУ1, СубконтоНУ2,СубконтоНУ3",
										СтрокаДанныхНУ.СчетДтНУ, СтрокаДанныхНУ.СубконтоДтНУ1, СтрокаДанныхНУ.СубконтоДтНУ2, СтрокаДанныхНУ.СубконтоДтНУ3),
										Реквизиты, СтрокаДанных.СтруктурноеПодразделениеДт, СтрокаДанных.СтруктурноеПодразделениеКт,
										СтрокаДанных.Сумма, 0, Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьПроводкиПоРезервамНУ(ТаблицаРеквизиты, ТаблицаПоРезервам, ТаблицаПоБУ, ТаблицаПоНУ)
	
	Реквизиты = ТаблицаРеквизиты[0];
	
	Если Реквизиты.ВедениеУчетаВременныхРазницБалансовымМетодом = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ВидУчетаНУВР = Справочники.ВидыУчетаНУ.ВР;
	
	Для Каждого ДанныеРезерва Из ТаблицаПоРезервам Цикл
		Если НЕ ДанныеРезерва.ПринятиеКВычетуПоНалоговомуУчету Тогда
			
			// Создание резерва
			ПараметрыОтбора = Новый Структура("ВидРасчета", ДанныеРезерва.Резерв);
			СтрокиСозданиеРезерва = ТаблицаПоБУ.НайтиСтроки(ПараметрыОтбора);
			Для Каждого СтрокаРезерва Из СтрокиСозданиеРезерва Цикл
				
				СтрокаРезерваНУ = ТаблицаПоНУ.Найти(СтрокаРезерва.НомерСтроки, "НомерСтроки"); 
				Если СтрокаРезерваНУ = Неопределено Тогда
					Продолжить;
				КонецЕсли;
									
				//Для резерва установим ВидУчета ВР
				СтрокаРезерваНУ.ВидУчетаДт = ВидУчетаНУВР;
				СтрокаРезерваНУ.ВидУчетаКт = ВидУчетаНУВР;
				
				// Если счет производственный, то добавим служебную проводоку
				Если ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.СчетЯвляетсяПроизводственным(СтрокаРезерва.СчетДт) Тогда
					
					СчетНУПроизводственный = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.СчетЯвляетсяПроизводственнымНУ(СтрокаРезерваНУ.СчетДтНУ);
					
					Если СчетНУПроизводственный Тогда
						
						ДанныеСчетДтНУ = Новый Структура("СчетДтНУ, СубконтоДтНУ1, ДтВидСубконтоНУ1, СубконтоДтНУ2, ДтВидСубконтоНУ2, СубконтоДтНУ3, ДтВидСубконтоНУ3",
															СтрокаРезерваНУ.СчетДтНУ, 	СтрокаРезерваНУ.СубконтоДтНУ1, СтрокаРезерваНУ.ДтВидСубконтоНУ1, 
																						СтрокаРезерваНУ.СубконтоДтНУ2, СтрокаРезерваНУ.ДтВидСубконтоНУ2, 
																						СтрокаРезерваНУ.СубконтоДтНУ3, СтрокаРезерваНУ.ДтВидСубконтоНУ3);
						
						
						СтрокаРезерваНУ.СчетДтНУ = ПланыСчетов.Налоговый.ПрочиеРасходы;
 					
						КоличествоСубконто = СтрокаРезерваНУ.СчетДтНУ.ВидыСубконто.Количество();
						Для Н = 1 По 3 Цикл
							Если Н <= КоличествоСубконто И СтрокаРезерваНУ.СчетДтНУ.ВидыСубконто[Н-1].ВидСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.СтатьиЗатрат")) Тогда
								СтрокаРезерваНУ["СубконтоДтНУ" + Н] = ДанныеРезерва.СтатьяЗатрат;
								СтрокаРезерваНУ["ДтВидСубконтоНУ" + Н] = ПланыВидовХарактеристик.ВидыСубконтоТиповые.СтатьиЗатрат;
							Иначе 
								СтрокаРезерваНУ["СубконтоДтНУ" + Н] = Неопределено;
								СтрокаРезерваНУ["ДтВидСубконтоНУ" + Н] = Неопределено;
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
					
					СтрокаНУ = ТаблицаПоНУ.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаНУ,СтрокаРезерва);
					СтрокаНУ.НомерСтроки = Неопределено;
					СтрокаНУ.СтруктурноеПодразделениеКт = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
					
					// Дт
					Если СчетНУПроизводственный Тогда
						ЗаполнитьЗначенияСвойств(СтрокаНУ, ДанныеСчетДтНУ); 
					Иначе 
						СтрокаНУ.СчетДтНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаРезерва.СчетДт), , , );
						
						// Изменим статью затрат на установленное значение в резерве
						КоличествоСубконто = СтрокаНУ.СчетДтНУ.ВидыСубконто.Количество();
						Для Н = 1 По КоличествоСубконто Цикл
							СтрокаНУ["СубконтоДтНУ" + Н] = СтрокаРезерва["СубконтоДт" + Н];
							СтрокаНУ["ДтВидСубконтоНУ" + Н] = СтрокаРезерва.СчетДт.ВидыСубконто[Н-1].ВидСубконто;							
						КонецЦикла;
					КонецЕсли;
					
					//Кт
					СтрокаНУ.СчетКтНУ = ПланыСчетов.Налоговый.ПрочиеРасходы;
					КоличествоСубконто = СтрокаНУ.СчетКтНУ.ВидыСубконто.Количество();
					Для Н = 1 По КоличествоСубконто Цикл
						Если СтрокаНУ.СчетКтНУ.ВидыСубконто[Н-1].ВидСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.СтатьиЗатрат")) Тогда
							СтрокаНУ["СубконтоКтНУ" + Н] = ДанныеРезерва.СтатьяЗатрат;
							СтрокаНУ["КтВидСубконтоНУ" + Н] = ПланыВидовХарактеристик.ВидыСубконтоТиповые.СтатьиЗатрат;
						Иначе 
							СтрокаНУ["СубконтоКтНУ" + Н] = Неопределено;
						КонецЕсли;
					КонецЦикла;

				КонецЕсли;				
			КонецЦикла;   		
			
			// Погашение резерва
			ПараметрыОтбора = Новый Структура("СчетДт, СубконтоДт1", ДанныеРезерва.СчетУчета, ДанныеРезерва.Резерв);
			СтрокиПогашенияРезерва = ТаблицаПоБУ.НайтиСтроки(ПараметрыОтбора);
			Для Каждого СтрокаРезерва Из СтрокиПогашенияРезерва Цикл
				СтрокаНУ = ТаблицаПоНУ.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНУ,СтрокаРезерва);
				СтрокаНУ.СтруктурноеПодразделениеДт = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
				СтрокаНУ.СтруктурноеПодразделениеКт = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
				
				// Установим вид учета НУ
				СтрокаНУ.ВидУчетаДт = ВидУчетаНУВР;
				СтрокаНУ.ВидУчетаКт = ВидУчетаНУВР;
				
				// Дт
				СтрокаНУ.СчетДтНУ = ПланыСчетов.Налоговый.КраткосрочныеОценочныеОбязательстваПоВознаграждениямРаботникам;
				
				КоличествоСубконто = СтрокаНУ.СчетДтНУ.ВидыСубконто.Количество();
				Для Н = 1 По КоличествоСубконто Цикл
					Если СтрокаНУ.СчетДтНУ.ВидыСубконто[Н-1].ВидСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Резервы")) Тогда
						СтрокаНУ["СубконтоДтНУ" + Н] = ДанныеРезерва.Резерв;
						СтрокаНУ["ДтВидСубконтоНУ" + Н] = ПланыВидовХарактеристик.ВидыСубконтоТиповые.Резервы;
					Иначе 
						СтрокаНУ["СубконтоДтНУ" + Н] = Неопределено;КонецЕсли;
				КонецЦикла;
					
				//Кт
				СтрокаНУ.СчетКтНУ = ПланыСчетов.Налоговый.ПрочиеРасходы;
				КоличествоСубконто = СтрокаНУ.СчетКтНУ.ВидыСубконто.Количество();
				Для Н = 1 По КоличествоСубконто Цикл
					Если СтрокаНУ.СчетКтНУ.ВидыСубконто[Н-1].ВидСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.СтатьиЗатрат")) Тогда
						СтрокаНУ["СубконтоКтНУ" + Н] = ДанныеРезерва.СтатьяЗатрат;
						СтрокаНУ["КтВидСубконтоНУ" + Н] = ПланыВидовХарактеристик.ВидыСубконтоТиповые.СтатьиЗатрат;
					Иначе 
						СтрокаНУ["СубконтоКтНУ" + Н] = Неопределено;
					КонецЕсли;
				КонецЦикла;

			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьДвиженияПоОтражениюВУчетеВБУ(ТаблицаРеквизиты, ТаблицаОтражениеВУчете, Движения, Отказ)
	
	Реквизиты = ТаблицаРеквизиты[0];
	
	ТаблицаФормированияПроводок = ТаблицаОтражениеВУчете;
	
	ВедениеУчетаПоСотрудникам = Реквизиты.ВедениеУчетаПоСотрудникам;
	Если НЕ ВедениеУчетаПоСотрудникам Тогда
		ТаблицаФормированияПроводок.Свернуть("ВидРасчета, ВидРасчетаНаименование, 
											|СчетДт, СубконтоДт1, ДтВидСубконто1, СубконтоДт2, ДтВидСубконто2, СубконтоДт3, ДтВидСубконто3,
											|СчетКт, СубконтоКт1, КтВидСубконто1, СубконтоКт2, КтВидСубконто2, СубконтоКт3, КтВидСубконто3,
											|ВключатьФИОРаботникаВСодержание, ВключатьВидРасчетаВСодержание, ФизЛицо, ФИОРаботника,  
											|СтруктурноеПодразделениеДт, СтруктурноеПодразделениеКт", "Сумма");
	КонецЕсли;
		
	Для Каждого СтрокаДанных Из ТаблицаФормированияПроводок Цикл

		// Формируем проводки 
		Если СтрокаДанных.Сумма <> 0 Тогда
			Проводка = Движения.Типовой.Добавить();
			
			Проводка.Период      = Реквизиты.Период;
			Проводка.Организация = Реквизиты.Организация;
			Проводка.Сумма       = СтрокаДанных.Сумма;
			
			// бухучет
			Проводка.СчетДт       = СтрокаДанных.СчетДт;
			Проводка.СчетКт       = СтрокаДанных.СчетКт;
			Проводка.СубконтоДт[СтрокаДанных.ДтВидСубконто1] = СтрокаДанных.СубконтоДт1;
			Проводка.СубконтоДт[СтрокаДанных.ДтВидСубконто2] = СтрокаДанных.СубконтоДт2;
			Проводка.СубконтоДт[СтрокаДанных.ДтВидСубконто3] = СтрокаДанных.СубконтоДт3;
			Проводка.СубконтоКт[СтрокаДанных.КтВидСубконто1] = СтрокаДанных.СубконтоКт1;
			Проводка.СубконтоКт[СтрокаДанных.КтВидСубконто2] = СтрокаДанных.СубконтоКт2;
			Проводка.СубконтоКт[СтрокаДанных.КтВидСубконто3] = СтрокаДанных.СубконтоКт3;
	
			ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(Проводка, СтрокаДанных.СтруктурноеПодразделениеДт, СтрокаДанных.СтруктурноеПодразделениеКт);

			Если Проводка.СчетДт.Валютный Тогда
				Проводка.ВалютаДт = Реквизиты.ВалютаРеглУчета;
				Проводка.ВалютнаяСуммаДт = СтрокаДанных.Сумма;
			КонецЕсли;
	
			Если Проводка.СчетКт.Валютный Тогда
				Проводка.ВалютаКт 			= Реквизиты.ВалютаРеглУчета;
				Проводка.ВалютнаяСуммаКт 	= СтрокаДанных.Сумма;
			КонецЕсли;
			
			// реквизиты
			СтрокаСодержания = "";
			Если СтрокаДанных.ВключатьФИОРаботникаВСодержание Тогда
				СтрокаСодержания = ?(ЗначениеЗаполнено(СтрокаДанных.ФИОРаботника), СтрокаДанных.ФИОРаботника, "");
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаДанных.ВидРасчета)
					И (СтрокаДанных.ВключатьВидРасчетаВСодержание Или ПустаяСтрока(СтрокаСодержания)) Тогда
				Если СтрокаСодержания <> "" Тогда
					СтрокаСодержания = СтрокаСодержания + " (" + СтрокаДанных.ВидРасчетаНаименование + ")";
				Иначе
					СтрокаСодержания = ?(ЗначениеЗаполнено(СтрокаДанных.ВидРасчетаНаименование), СтрокаДанных.ВидРасчетаНаименование, "");
				КонецЕсли;
			КонецЕсли;
			Проводка.Содержание  = СтрокаСодержания;
	        			
		КонецЕсли;

	КонецЦикла;
	
	Движения.Типовой.Записать(Истина);

КонецПроцедуры

Процедура СформироватьДвиженияПоОтражениюВУчетеВНУ(ТаблицаРеквизиты, ТаблицаОтражениеВУчете, Движения, Отказ)
	
	Реквизиты = ТаблицаРеквизиты[0];
	
	ТаблицаФормированияПроводок = ТаблицаОтражениеВУчете;
	
	ВедениеУчетаПоСотрудникам = Реквизиты.ВедениеУчетаПоСотрудникам;
	Если НЕ ВедениеУчетаПоСотрудникам Тогда
		ТаблицаФормированияПроводок.Свернуть("ВидРасчета, ВидРасчетаНаименование, 
											|СчетДтНУ, СубконтоДтНУ1, ДтВидСубконтоНУ1, СубконтоДтНУ2, ДтВидСубконтоНУ2, СубконтоДтНУ3, ДтВидСубконтоНУ3,
											|СчетКтНУ, СубконтоКтНУ1, КтВидСубконтоНУ1, СубконтоКтНУ2, КтВидСубконтоНУ2, СубконтоКтНУ3, КтВидСубконтоНУ3,
											|ВключатьФИОРаботникаВСодержание, ВключатьВидРасчетаВСодержание, ФизЛицо, ФИОРаботника, 
											|СтруктурноеПодразделениеДт, СтруктурноеПодразделениеКт,
											|ВидУчетаДт, ВидУчетаКт, ПризнакПроизводственногоСчета", "Сумма");
	КонецЕсли;
	
	Для Каждого СтрокаДанных Из ТаблицаФормированияПроводок Цикл

		Если (Реквизиты.ОрганизацияПлательщикНалогаНаПрибыль) И (ЗначениеЗаполнено(СтрокаДанных.СчетДтНУ) ИЛИ ЗначениеЗаполнено(СтрокаДанных.СчетКтНУ)) Тогда
			
			// Формируем проводки 
			Если СтрокаДанных.Сумма <> 0 Тогда
				ПроводкаНУ = Движения.Налоговый.Добавить();
				
				ПроводкаНУ.Период      = Реквизиты.Период;
				ПроводкаНУ.Организация = Реквизиты.Организация;
				ПроводкаНУ.Сумма       = СтрокаДанных.Сумма;
				
				// бухучет
				ПроводкаНУ.СчетДт       = СтрокаДанных.СчетДтНУ;
				ПроводкаНУ.СчетКт       = СтрокаДанных.СчетКтНУ;
				ПроводкаНУ.СубконтоДт[СтрокаДанных.ДтВидСубконтоНУ1] = СтрокаДанных.СубконтоДтНУ1;
				ПроводкаНУ.СубконтоДт[СтрокаДанных.ДтВидСубконтоНУ2] = СтрокаДанных.СубконтоДтНУ2;
				ПроводкаНУ.СубконтоДт[СтрокаДанных.ДтВидСубконтоНУ3] = СтрокаДанных.СубконтоДтНУ3;
				ПроводкаНУ.СубконтоКт[СтрокаДанных.КтВидСубконтоНУ1] = СтрокаДанных.СубконтоКтНУ1;
				ПроводкаНУ.СубконтоКт[СтрокаДанных.КтВидСубконтоНУ2] = СтрокаДанных.СубконтоКтНУ2;
				ПроводкаНУ.СубконтоКт[СтрокаДанных.КтВидСубконтоНУ3] = СтрокаДанных.СубконтоКтНУ3;
				ПроцедурыНалоговогоУчета.ВидУчетаНУ(ПроводкаНУ,  Справочники.ВидыУчетаНУ.НУ);
				
				// Заполнем уже известные виды учета
				Если ЗначениеЗаполнено(СтрокаДанных.ВидУчетаДт) Тогда
					ПроводкаНУ.ВидУчетаДт = СтрокаДанных.ВидУчетаДт;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаДанных.ВидУчетаКт) Тогда
					ПроводкаНУ.ВидУчетаКт = СтрокаДанных.ВидУчетаКт;
				КонецЕсли;
				
				СтруктурноеПодразделениеДт = ?(ЗначениеЗаполнено(ПроводкаНУ.СчетДт), СтрокаДанных.СтруктурноеПодразделениеДт, Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
				СтруктурноеПодразделениеКт = ?(ЗначениеЗаполнено(ПроводкаНУ.СчетКт), СтрокаДанных.СтруктурноеПодразделениеКт, Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
				Если ПроводкаНУ.СчетДт = ПланыСчетов.Налоговый.ПрочиеРасходы 
					И ПроводкаНУ.СчетКт = ПланыСчетов.Налоговый.КраткосрочныеОценочныеОбязательстваПоВознаграждениямРаботникам Тогда 
						СтруктурноеПодразделениеДт = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();					
				КонецЕсли;
		
				ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(ПроводкаНУ, СтруктурноеПодразделениеДт, СтруктурноеПодразделениеКт);
								
				// реквизиты
				СтрокаСодержания = "";
				Если СтрокаДанных.ВключатьФИОРаботникаВСодержание Тогда
					СтрокаСодержания = ?(ЗначениеЗаполнено(СтрокаДанных.ФИОРаботника), СтрокаДанных.ФИОРаботника, "");
				КонецЕсли;
				Если ЗначениеЗаполнено(СтрокаДанных.ВидРасчета)
						И (СтрокаДанных.ВключатьВидРасчетаВСодержание Или ПустаяСтрока(СтрокаСодержания)) Тогда
					Если СтрокаСодержания <> "" Тогда
						СтрокаСодержания = СтрокаСодержания + " (" + СтрокаДанных.ВидРасчетаНаименование + ")";
					Иначе
						СтрокаСодержания = ?(ЗначениеЗаполнено(СтрокаДанных.ВидРасчетаНаименование), СтрокаДанных.ВидРасчетаНаименование, "");
					КонецЕсли;
				КонецЕсли;
				ПроводкаНУ.Содержание  = СтрокаСодержания;
		        			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.Налоговый.Записать(Истина);

КонецПроцедуры

#КонецЕсли