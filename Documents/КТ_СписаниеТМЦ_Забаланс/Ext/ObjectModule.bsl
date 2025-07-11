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
	
	УчетТоваров.ЗаполнитьНаборыПоОрганизацииСтрутурномуПодразделениюСкладу(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение", "Склад");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	//ПараметрыПроведения = Документы.КТ_СписаниеТМЦ_Забаланс.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТиповойОстатки.Счет КАК Счет,
	|	ТиповойОстатки.Субконто1 КАК Субконто1,
	|	ТиповойОстатки.Субконто2 КАК Субконто2,
	|	ТиповойОстатки.Субконто3 КАК Субконто3,
	|	ТиповойОстатки.Организация КАК Организация,
	|	ТиповойОстатки.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	ТиповойОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрБухгалтерии.Типовой.Остатки(
	|			&ДатаСреза,
	|			Счет = &Счет,
	|			,
	|			Организация = &Организация
	|				И Субконто1 = &Контрагент
	|				И Субконто2 = &Номенклатура
	|				И Субконто3 = &Склад) КАК ТиповойОстатки
	|ГДЕ
	|	ТиповойОстатки.КоличествоОстаток >= &КоличествоОстаток";
	Запрос.УстановитьПараметр("ДатаСреза"   , Дата);
	Запрос.УстановитьПараметр("Организация" , Организация);
	Запрос.УстановитьПараметр("Контрагент"  , Контрагент);
	Запрос.УстановитьПараметр("Склад"       , Склад);
	
	ТекстОшибки = ""; ТО = "";
	Для Каждого СтрокаТаблицы Из Товары Цикл
		Запрос.УстановитьПараметр("Счет"             , СтрокаТаблицы.СчетУчетаБУ);
		Запрос.УстановитьПараметр("Номенклатура"     , СтрокаТаблицы.Номенклатура);
		Запрос.УстановитьПараметр("КоличествоОстаток", СтрокаТаблицы.Количество);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Не Выборка.Следующий() Тогда
			ТекстОшибки = "! ТМЦ - "+СтрокаТаблицы.Номенклатура+" не достаточно на складе "+Склад;
			
	    	ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект.Ссылка, СтрокаТаблицы.Номенклатура, "Объект");
			
			ТО = ТО + ТекстОшибки;
		КонецЕсли;
	КонецЦикла;
	
	Если ТО <> "" Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	Движения.Типовой.Записывать = Истина;
	Для Каждого СтрокаТаблицы Из Товары Цикл
		Проводка = Движения.Типовой.Добавить();
		
		Проводка.Период       = Дата;
		Проводка.Организация  = Организация;
		Проводка.Содержание   = "Списано с забаланса";
		
		Проводка.СчетКт       = СтрокаТаблицы.СчетУчетаБУ;
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Номенклатура", СтрокаТаблицы.Номенклатура);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Склады",       Склад);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт , "Контрагенты", Контрагент);			
		
		ПроцедурыБухгалтерскогоУчета.УстановитьПодразделениеПроводки(Проводка, СтруктурноеПодразделение, "Кт");
		
		Проводка.КоличествоКт = СтрокаТаблицы.Количество;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснования(ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(Отказ, ПараметрыПроверки = Неопределено)
	
	Для Каждого СтрокаТабличнойЧасти Из Товары Цикл
		
		СвойстваСчетаУчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТабличнойЧасти.СчетУчетаБУ);

		Если НЕ СвойстваСчетаУчета.Забалансовый И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетЗатратБУ) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = ' Счет списания затрат (БУ)'"),
				СтрокаТабличнойЧасти.НомерСтроки, "ТМЗ");
			Поле = "Товары[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетЗатратБУ";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;		
		
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура выполняет заполнение документа по документу-основанию
//
Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ИнвентаризацияТоваровНаСкладе") Тогда

		Документы.СписаниеТоваров.ЗаполнитьТоварыПоИнвентаризацииТоваров(ЭтотОбъект, Основание);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
					
		Документы.СписаниеТоваров.ЗаполнитьТоварыПоПеремещениюТоваров(ЭтотОбъект, Основание);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		
		Документы.СписаниеТоваров.ЗаполнитьТоварыПоПоступлениюТоваров(ЭтотОбъект, Основание);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		
		Документы.СписаниеТоваров.ЗаполнитьТоварыПоАвансовомуОтчету(ЭтотОбъект, Основание);
		
	КонецЕсли;

КонецПроцедуры

#КонецЕсли

