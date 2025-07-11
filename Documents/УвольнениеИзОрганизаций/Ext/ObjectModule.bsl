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
	
	СписокФизЛиц = РаботникиОрганизации.ВыгрузитьКолонку("ФизЛицо");;
	
	РасчетЗарплатыСервер.ЗаполнитьНаборыПоОрганизацииСтрутурномуПодразделениюСпискуФизЛиц(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение", СписокФизЛиц);
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		
		Документы.УвольнениеИзОрганизаций.ЗаполнитьПоДокументуОснования(ЭтотОбъект, ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьЗаполнениеТабличнойЧастиПострочно(РаботникиОрганизации, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(РаботникиОрганизации);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналомСервер.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "Сотрудник");

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.УвольнениеИзОрганизаций.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	КадровыйУчетСервер.СформироватьДвиженияРаботникиОрганизации(ПараметрыПроведения.ТаблицаРаботники, Движения, Отказ);
	
	РасчетЗарплатыСервер.СформироватьДвижения(ПараметрыПроведения.ТаблицаПлановыеНачисления, 
												"ПлановыеНачисленияРаботниковОрганизаций", Движения, Отказ);
	
	РасчетЗарплатыСервер.СформироватьДвижения(ПараметрыПроведения.ТаблицаПлановыеУдержания, 
												"ПлановыеУдержанияРаботниковОрганизаций", Движения, Отказ);
	
	РасчетЗарплатыСервер.СформироватьДвижения(ПараметрыПроведения.ТаблицаИПНПлановыеВычеты, 
												"ИПНПлановыеНалоговыеВычетыФизлиц", Движения, Отказ);
	
	РасчетЗарплатыСервер.СформироватьДвиженияПрекращениеПредоставленияВычетовИПН(ПараметрыПроведения.ПрименениеВычетовИПН, ПараметрыПроведения.СтандартныеВычетыИПН, 
	                                                                              ПараметрыПроведения.ПрочиеВычетыИПН, Движения, Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, Отказ)
	
	РезультатЗапросаПоРаботники   = СформироватьЗапросПоРаботникиОрганизации(ПроверяемаяТабличнаячасть);
	ВыборкаПоСтрокамДокумента = РезультатЗапросаПоРаботники.Выбрать();
	
	Пока ВыборкаПоСтрокамДокумента.Следующий() Цикл		
		СтрокаНачалаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке номер %1 табл. части ""Сотрудники"": '"),СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки));
				
		Если  ВыборкаПоСтрокамДокумента.ВидСтрокиЗапроса = "ДанныеДляДвиженийКадров" Тогда
			
			Если ВыборкаПоСтрокамДокумента.ПрежнееОбособленноеПодразделение <> Организация Тогда 
				// чтобы при увольнении в шапке было указано именно обособленное подразделение, в котором числится работник
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru=' на момент увольнения не работает в организации (обособленном подразделении) %1!'"),Организация);
				Поле = "РаботникиОрганизации" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Сотрудник";
				ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			// Организация сотрудника должна совпадать с организацией документа
			Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
				ТекстСообщения = НСтр("ru=' организация документа не соответствует организации, указанной в карточке сотрудника! '");
				Поле = "РаботникиОрганизации" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Сотрудник";
				ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			// Проверка: противоречие другой строке документа
			Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер <> NULL Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru=' сотрудник не может быть указан в документе дважды (см. строку %1)!'"),ВыборкаПоСтрокамДокумента.НомерСтроки);
				Поле = "РаботникиОрганизации" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Сотрудник";
				ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;	

			// Проверка: ранее работник должен быть принят на работу
			Если ВыборкаПоСтрокамДокумента.ПрежняяСтавка = NULL Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru=' на %1 сотрудник %2 еще не принят на работу!'"),Формат(ВыборкаПоСтрокамДокумента.ДатаУвольнения, "ДЛФ=DD"),ВыборкаПоСтрокамДокумента.СотрудникНаименование);
				Поле = "РаботникиОрганизации" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Сотрудник";
				ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				
			ИначеЕсли ВыборкаПоСтрокамДокумента.ПрежняяСтавка = 0 Тогда	
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru=' на %1 сотрудник %2 уже уволен (с %3)!'"),
										Формат(ВыборкаПоСтрокамДокумента.ДатаУвольнения, "ДЛФ=DD"), 
										ВыборкаПоСтрокамДокумента.СотрудникНаименование, 
										Формат(ВыборкаПоСтрокамДокумента.ДатаПоследнегоДвиженияПоРаботнику, "ДЛФ=DD"));
				Поле = "РаботникиОрганизации" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Сотрудник";
				ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				
			КонецЕсли; 
			
		ИначеЕсли ВыборкаПоСтрокамДокумента.ВидСтрокиЗапроса = "РабочиеМестаДоУвольнения"  Тогда
			ВидЗанятостиПоПриказу = ВыборкаПоСтрокамДокумента.ВидЗанятости;
			
			Если ВидЗанятостиПоПриказу = Перечисления.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы
				ИЛИ ВидЗанятостиПоПриказу = Перечисления.ВидыЗанятостиВОрганизации.Совместительство Тогда
				
				// При увольнении с основного места работы потребуем, чтобы не было внутреннего совместительства
				Если ВыборкаПоСтрокамДокумента.ВидЗанятостиПоДругомуМестуРаботы = Перечисления.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство  Тогда
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='нельзя уволить сотрудника с основного места работы или внешнего совместительства до тех пор, пока он оформлен внутренним совместителем! (Сотрудник: %1)'"),
											ВыборкаПоСтрокамДокумента.СотрудникНаименование);
					Поле = "РаботникиОрганизации" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Сотрудник";
					ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;		
			КонецЕсли;
			
		ИначеЕсли ВыборкаПоСтрокамДокумента.ВидСтрокиЗапроса = "КонфликтныйДокумент" Тогда
			// противоречие другим кадровым приказам
			ТекстСообщения = НСтр("ru='возникает противоречие кадровому приказу '")+ Символы.ПС + Символы.Таб + ВыборкаПоСтрокамДокумента.КонфликтныйДокумент + "!";
			Поле = "РаботникиОрганизации" + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Сотрудник";
			ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует запрос по таблице "РаботникиОрганизации" документа.
//
Функция СформироватьЗапросПоРаботникиОрганизации(ПроверяемаяТабличнаячасть)
   
	Запрос = Новый Запрос;

	// Заполним список обособленных подразделений организации 
	ГоловнаяОрганизация = ОбщегоНазначенияБКВызовСервера.ГоловнаяОрганизацияДляУчетаЗарплаты(Организация);
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");

	Если ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда   			
		Налогоплательщик = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.ПолучитьНалогоплательщикаСтруктурнойЕдиницы(СтруктурноеПодразделение,
																							Организация,
																							ПредопределенноеЗначение("Перечисление.РазделыНалоговогоУчета.НалогиСЗаработнойПлаты"));
	Иначе
		Налогоплательщик = Организация;
	КонецЕсли;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("МассивФизЛиц", РаботникиОрганизации.ВыгрузитьКолонку("ФизЛицо"));
	Запрос.УстановитьПараметр("НачальнаяДата", '00010101');
	Запрос.УстановитьПараметр("Налогоплательщик", Налогоплательщик);
	Запрос.УстановитьПараметр("ТаблицаДокумента", ПроверяемаяТабличнаячасть);
	
	// Описание текста запроса:
	// Первая часть запроса  - вид строки запроса "ДанныеДляДвиженийКадров": 
    // 1. Выборка "ТЧРаботникиОрганизации": 
	//		Выбираются строки документа.  
	// 2. Выборка "ДанныеПоРаботникиДоНазначения": 
	//		Для каждой строки ТЧРаботникиОрганизации выполняем срез по регистру РаботникиОрганизации на дату ДатаНачала
	//		для выполнения движений и проверки "Работает ли работник на дату перемещения" в указанной организации (структурном подразделении). 
	//		(Использует данные выборки "ДатыПоследнихДвиженийРаботников")
	// 3. Выборка "ПересекающиесяСтроки": 
	//		Среди остальных строк документа ищем строки, имеющие одиноковый набор реквизитов <Сотрудник>.
	//
	// Вторая часть запроса - вид строки запроса "РабочиеМестаДоУвольнения" - выборка остающихся мест работы после увольнения
	// Данные выборки нужня для проверки "Работник не может быть уволен с основного места работы до тех пор, пока он оформлен внутренним совместителем"
	// 1. Выборка "ТЧРаботникиОрганизации":
	//		Выбираются строки документа 
	// 2. Выборка "ДанныеПоРаботникуДоУвольнения":
	//		Для каждой строки ТЧРаботникиОрганизации выполняем срез по выборке "ДвиженияРаботниковОрганизации" регистру РаботникиОрганизации на дату ДатаУвольнения.
	//		Где выборка "ДвиженияРаботниковОрганизации" есть объединение движений по регистру "РаботникиОрганизации" и движений, которые должны выполниться
	//		проверяемым документом. 

	// Третья часть запроса - вид строки запроса "КонфликтныйДокумент" - поиск конфликтных документов: 
	// 1. Выборка "ТЧРаботникиОрганизации":
	//		Выбираются строки документа 
   	// 2. Выборка "КонфликтныеДвижения":
	//		Для каждой строки ТЧРаботникиОрганизации ищем движения по регистрам РаботникиОрганизации и СостояниеРаботниковОрганизации
	//		на дату ДатаУвольнения по набору измерений <Сотрудник>

	
	//|		Документ.УвольнениеИзОрганизаций.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	//|	ГДЕ
	//|		ТЧРаботникиОрганизации.Ссылка = &ДокументСсылка
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.Физлицо КАК ФизЛицо,
	|	ТЧРаботникиОрганизации.ДатаУвольнения
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|	ИЗ
	|	&ТаблицаДокумента КАК ТЧРаботникиОрганизации
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТЧРаботникиОрганизации.НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.Физлицо,
	|	ТЧРаботникиОрганизации.ДатаУвольнения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""ДанныеДляДвиженийКадров"" КАК ВидСтрокиЗапроса,
	|	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник.Наименование КАК СотрудникНаименование,
	|	ТЧРаботникиОрганизации.ДатаУвольнения,
	|	ДанныеПоРаботникуДоНазначения.Сотрудник.ВидЗанятости КАК ВидЗанятости,
	|	ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизации КАК ПрежнееПодразделение,
	|	ДанныеПоРаботникуДоНазначения.ОбособленноеПодразделение КАК ПрежнееОбособленноеПодразделение,
	|	ВЫБОР
	|		КОГДА ТЧРаботникиОрганизации.Сотрудник.Организация = &ГоловнаяОрганизация
	|				ИЛИ ТЧРаботникиОрганизации.Сотрудник = ЗНАЧЕНИЕ(Справочник.СотрудникиОрганизаций.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации,
	|	ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок КАК ПрежняяСтавка,
	|	ДанныеПоРаботникуДоНазначения.Период КАК ДатаПоследнегоДвиженияПоРаботнику,
	|	ПересекающиесяСтроки.КонфликтнаяСтрокаНомер,
	|	NULL КАК КонфликтныйДокумент,
	|	NULL КАК ВидЗанятостиПоДругомуМестуРаботы
	|ИЗ
	|	ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ДанныеПоРаботникуДоНазначения
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				Док.Сотрудник КАК Сотрудник,
	|				МАКСИМУМ(СостояниеВнутри.Период) КАК ДатаПоследнегоИзменения
	|			ИЗ
	|				РегистрСведений.РаботникиОрганизаций КАК СостояниеВнутри
	|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДокумента КАК Док
	|					ПО СостояниеВнутри.Сотрудник = Док.Сотрудник
	|						И (СостояниеВнутри.Организация = &ГоловнаяОрганизация)
	|						И СостояниеВнутри.Период <= Док.ДатаУвольнения
	|						И (СостояниеВнутри.Регистратор <> &ДокументСсылка)
	|			ГДЕ
	|				СостояниеВнутри.Активность
	|			
	|			СГРУППИРОВАТЬ ПО
	|				Док.Сотрудник) КАК СписокДат
	|			ПО ДанныеПоРаботникуДоНазначения.Сотрудник = СписокДат.Сотрудник
	|				И ДанныеПоРаботникуДоНазначения.Период = СписокДат.ДатаПоследнегоИзменения
	|				И (ДанныеПоРаботникуДоНазначения.Организация = &ГоловнаяОрганизация)
	|				И (ДанныеПоРаботникуДоНазначения.Активность)
	|				И (ДанныеПоРаботникуДоНазначения.Регистратор <> &ДокументСсылка)
	|		ПО (ДанныеПоРаботникуДоНазначения.Сотрудник = ТЧРаботникиОрганизации.Сотрудник)
	|			И (ДанныеПоРаботникуДоНазначения.Организация = &ГоловнаяОрганизация)
	|			И (ДанныеПоРаботникуДоНазначения.Активность)
	|			И (ДанныеПоРаботникуДоНазначения.Регистратор <> &ДокументСсылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|			МИНИМУМ(ТЧРаботникиОрганизации2.НомерСтроки) КАК КонфликтнаяСтрокаНомер
	|		ИЗ
	|			ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДокумента КАК ТЧРаботникиОрганизации2
	|				ПО ТЧРаботникиОрганизации.Сотрудник = ТЧРаботникиОрганизации2.Сотрудник
	|					И ТЧРаботникиОрганизации.НомерСтроки <> ТЧРаботникиОрганизации2.НомерСтроки
	|
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТЧРаботникиОрганизации.НомерСтроки) КАК ПересекающиесяСтроки
	|		ПО ТЧРаботникиОрганизации.НомерСтроки = ПересекающиесяСтроки.НомерСтроки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	""РабочиеМестаДоУвольнения"",
	|	ТЧРаботникиОрганизации.НомерСтроки,
	|	ДанныеПоРаботникуДоУвольнения.Сотрудник.Наименование,
	|	NULL,
	|	ДанныеПоМестуУвольнения.Сотрудник.ВидЗанятости,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ДанныеПоРаботникуДоУвольнения.Сотрудник.ВидЗанятости
	|ИЗ
	|	ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ДанныеПоРаботникуДоУвольнения
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				ДвиженияРаботниковОрганизации.Сотрудник КАК Сотрудник,
	|				МАКСИМУМ(ДвиженияРаботниковОрганизации.Период) КАК ДатаПоследнегоИзменения
	|			ИЗ
	|				(ВЫБРАТЬ
	|					ДвиженияРаботниковОрганизации.Период КАК Период,
	|					ДвиженияРаботниковОрганизации.Сотрудник КАК Сотрудник,
	|					ДвиженияРаботниковОрганизации.Сотрудник.Физлицо КАК ФизЛицо
	|				ИЗ
	|					РегистрСведений.РаботникиОрганизаций КАК ДвиженияРаботниковОрганизации
	|				ГДЕ
	|					ДвиженияРаботниковОрганизации.Организация = &ГоловнаяОрганизация
	|					И ДвиженияРаботниковОрганизации.Активность
	|					И ДвиженияРаботниковОрганизации.Регистратор <> &ДокументСсылка
	|				
	|				ОБЪЕДИНИТЬ ВСЕ
	|				
	|				ВЫБРАТЬ
	|					ТЧРаботникиОрганизации.ДатаУвольнения,
	|					ТЧРаботникиОрганизации.Сотрудник,
	|					ТЧРаботникиОрганизации.ФизЛицо
	|				ИЗ
	|					ВТДанныеДокумента КАК ТЧРаботникиОрганизации) КАК ДвиженияРаботниковОрганизации
	|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДокумента КАК Док
	|					ПО ДвиженияРаботниковОрганизации.ФизЛицо = Док.ФизЛицо
	|						И (ДвиженияРаботниковОрганизации.Период <= ДОБАВИТЬКДАТЕ(Док.ДатаУвольнения, ДЕНЬ, 1))
	|			
	|			СГРУППИРОВАТЬ ПО
	|				ДвиженияРаботниковОрганизации.Сотрудник) КАК ДатыПоследнихДвиженийПоПриказам
	|			ПО ДанныеПоРаботникуДоУвольнения.Сотрудник = ДатыПоследнихДвиженийПоПриказам.Сотрудник
	|				И (ДанныеПоРаботникуДоУвольнения.Организация = &ГоловнаяОрганизация)
	|				И ДанныеПоРаботникуДоУвольнения.Период = ДатыПоследнихДвиженийПоПриказам.ДатаПоследнегоИзменения
	|				И (ДанныеПоРаботникуДоУвольнения.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение))
	|				И (ДанныеПоРаботникуДоУвольнения.Активность)
	|				И (ДанныеПоРаботникуДоУвольнения.Регистратор <> &ДокументСсылка)
	|		ПО (ДанныеПоРаботникуДоУвольнения.Сотрудник.Физлицо = ТЧРаботникиОрганизации.Сотрудник.Физлицо)
	|			И (ДанныеПоРаботникуДоУвольнения.Активность)
	|			И (ДанныеПоРаботникуДоУвольнения.Регистратор <> &ДокументСсылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|			МАКСИМУМ(РаботникиОрганизации.Период) КАК Период
	|		ИЗ
	|			ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|				ПО ТЧРаботникиОрганизации.Сотрудник = РаботникиОрганизации.Сотрудник
	|					И (РаботникиОрганизации.Организация = &ГоловнаяОрганизация)
	|					И (РаботникиОрганизации.Период <= ТЧРаботникиОрганизации.ДатаУвольнения)
	|					И (РаботникиОрганизации.Активность)
	|				    И (РаботникиОрганизации.Регистратор <> &ДокументСсылка)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТЧРаботникиОрганизации.НомерСтроки) КАК ДатыНазначенийПередУвольнением
	|		ПО ТЧРаботникиОрганизации.НомерСтроки = ДатыНазначенийПередУвольнением.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ДанныеПоМестуУвольнения
	|		ПО ТЧРаботникиОрганизации.Сотрудник = ДанныеПоМестуУвольнения.Сотрудник
	|			И (ДанныеПоМестуУвольнения.Организация = &ГоловнаяОрганизация)
	|			И (ДатыНазначенийПередУвольнением.Период = ДанныеПоМестуУвольнения.Период)
	|			И (ДанныеПоМестуУвольнения.Активность)
	|			И (ДанныеПоМестуУвольнения.Регистратор <> &ДокументСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	""КонфликтныйДокумент"",
	|	ТЧРаботникиОрганизации.НомерСтроки,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	КонфликтныеДвижения.Регистратор,
	|	NULL
	|ИЗ
	|	ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК КонфликтныеДвижения
	|		ПО (КонфликтныеДвижения.Сотрудник = ТЧРаботникиОрганизации.Сотрудник)
	|			И (КонфликтныеДвижения.Организация = &ГоловнаяОрганизация)
	|			И (КонфликтныеДвижения.Активность)
	|			И (КонфликтныеДвижения.Регистратор <> &ДокументСсылка)
	|			И (КонфликтныеДвижения.Период = ДОБАВИТЬКДАТЕ(ТЧРаботникиОрганизации.ДатаУвольнения, ДЕНЬ, 1)
	|				ИЛИ ДОБАВИТЬКДАТЕ(ТЧРаботникиОрганизации.ДатаУвольнения, ДЕНЬ, 1) = КонфликтныеДвижения.Период)";
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

#КонецЕсли
