﻿
// Описание: Получает оборудование по организации
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияБПО - Организация.
// 
// Возвращаемое значение:
//  Структура - Структура по свойствами:
//   * Терминал - СправочникСсылка.ПодключаемоеОборудование - Терминал.
//   * ФискальныеУстройства - СправочникСсылка.ПодключаемоеОборудование - ФискальныеУстройства.
//
Процедура ОбработатьСостояниеСмены(Форма, ОписаниеОповещенияЗавершение) Экспорт
	
	//в БК не используется
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияЗавершение, Истина);
			
КонецПроцедуры

// Описание: Возвращает числовое значение ставки НДС по ссылка
//
// Параметры:
//  СтавкаНДС - СправочникСсылка.СтавкиНДС
// 
// Возвращаемое значение:
//  Числовове значение ставки НДС (0.12, 0 и тд)
//
Функция СтавкаНДСЧислом(СтавкаНДС) Экспорт
	
	ЗначениеСтавки = ?(ЗначениеЗаполнено(СтавкаНДС), ОбщегоНазначенияБКВызовСервера.ЗначениеРеквизитаОбъекта(СтавкаНДС, "Ставка"), 0);
	 
	Если НЕ ЗначениеСтавки = 0 Тогда
		Возврат ЗначениеСтавки / 100;
	КонецЕсли;
	
	Возврат 0;	
	
КонецФункции

// Описание: Обработка строки табличной части - вызывается из форм документов.
//
// Параметры:
//  СтрокаТаблицы		 - Структура - данные обрабатываемой строки.
//  СтруктураДействий	 - Структура - описывает действия, где Ключ - наименование действия, Значение - Структура - параметры действия.
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
//
Процедура ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Для каждого Действие Из СтруктураДействий Цикл
		Если Действие.Ключ = "ПересчитатьСумму"  Тогда
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТаблицы);
		ИначеЕсли Действие.Ключ = "ПересчитатьЦенуПоСумме"  Тогда
			ОбработкаТабличныхЧастейКлиентСервер.ПриИзмененииСуммыТабЧасти(СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

// Описание: Обработка полученных результатов после обработки чека оборудованием
//
Процедура ОбработатьРезультатаЧека(Форма, ВыходныеПараметры, Оплаты) Экспорт
	
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("Результат",         Истина);
	РезультатВыполнения.Вставить("ОписаниеОшибки",    НСтр("ru = 'Ошибок нет.'"));
	РезультатВыполнения.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	
	Форма.Закрыть(РезультатВыполнения);
	
КонецПроцедуры

// Описание: Открывает форму оплаты эквайринговым терминалом (если используется)
//
Процедура ОплатитьКартой(Форма, ОповещениеЗавершение) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ТипТранзакции",               Форма.ПараметрыЭквайринговойОперации.ТипТранзакции);
	ПараметрыОткрытияФормы.Вставить("Сумма",                       Форма.ПараметрыЭквайринговойОперации.Сумма);
	ПараметрыОткрытияФормы.Вставить("ПределСуммы",                 Форма.ПараметрыЭквайринговойОперации.Сумма);
	ПараметрыОткрытияФормы.Вставить("УказатьДополнительныеДанные", Форма.ПараметрыЭквайринговойОперации.ТипТранзакции = "AuthorizeRefund");
	
	Если ТипЗнч(Форма.ДокументСсылка) = Тип("ДокументСсылка.ОплатаОтПокупателяПлатежнойКартой") Тогда
		ПараметрыОткрытияФормы.Вставить("ЗапретРедактированияСуммы", Истина);
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ПодключаемоеОборудование.Форма.ФормаАвторизацииЭТ",
		ПараметрыОткрытияФормы,,,,,
		ОповещениеЗавершение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Описание: Записывает документ после оплаты по эквайрингу
//
Процедура ЗаписатьОбъектЭквайринговаяОперация(ВладелецФормы, ОповещениеЗавершение) Экспорт
	
	//в БК не используется
	ВыполнитьОбработкуОповещения(ОповещениеЗавершение, Истина);
		
КонецПроцедуры

// Проверяет соответствие ИИН / БИН требованиям.
//
// Параметры:
//  ИИН                - Строка - проверяемый Индивидуальный идентификационный номер (или БИН).
//  ТекстСообщения     - Строка - текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция ИИНСоответствуетТребованиям(Знач ИИН, ТекстСообщения = "") Экспорт
	
	СоответствуетТребованиям = Истина;
	ТекстСообщения = "";
	
	ИНН      = СокрЛП(ИИН);
	ДлинаИНН = СтрДлина(ИИН);
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ИНН) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'БИН/ИИН должен состоять только из цифр.'");
	КонецЕсли;

	Если ДлинаИНН <> 12 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
			+ НСтр("ru = 'БИН/ИИН должен состоять из 12 цифр.'");
	КонецЕсли;

	Если СоответствуетТребованиям Тогда
	// а12 = (а1*b1+а2*b2+а3*b3+а4*b4+а5*b5+а6*b6+а7*b7+а8*b8+а9*b9+a10*b10+a11*b11) mod 11
		
		ПодстрокаИН11 = Лев(ИНН,11);        // копируем первые 11 символов
		КонтрольноеЗначение = Прав(ИНН, 1); // контрольная сумма ИИН/БИН
		
		// Разряд ИИН: 1 2 3 4 5 6 7 8 9 10 11
		// Вес разряда: 1 2 3 4 5 6 7 8 9 10 11
		
		СуммаРазрядов = 1 * Сред(ИНН, 1, 1) + 2 * Сред(ИНН, 2, 1) +
		3 * Сред(ИНН, 3, 1) + 4 * Сред(ИНН, 4, 1) +
		5 * Сред(ИНН, 5, 1) + 6 * Сред(ИНН, 6, 1) +
		7 * Сред(ИНН, 7, 1) + 8 * Сред(ИНН, 8, 1) +
		9 * Сред(ИНН, 9, 1) + 10 * Сред(ИНН, 10, 1) + 11 * Сред(ИНН, 11, 1);
		ВычисленноеКонтрольноеЗначение = СуммаРазрядов - Цел(СуммаРазрядов / 11) * 11; // mod - остаток от деления Суммы разрядов на 11.
		
		Если ВычисленноеКонтрольноеЗначение = 10 Тогда
			
			// Разряд ИИН: 1 2 3 4 5 6 7 8 9 10 11 
			// Вес разряда: 3 4 5 6 7 8 9 10 11 1 2
			
			СуммаРазрядов = 3 * Сред(ИНН, 1, 1) + 4 * Сред(ИНН, 2, 1) +
			5 * Сред(ИНН, 3, 1) + 6 * Сред(ИНН, 4, 1) +
			7 * Сред(ИНН, 5, 1) + 8 * Сред(ИНН, 6, 1) +
			9 * Сред(ИНН, 7, 1) + 10 * Сред(ИНН, 8, 1) +
			11 * Сред(ИНН, 9, 1) + 1 * Сред(ИНН, 10, 1) + 2 * Сред(ИНН, 11, 1);
			ВычисленноеКонтрольноеЗначение = СуммаРазрядов - Цел(СуммаРазрядов / 11) * 11;   
			
		КонецЕсли;
		
		Если ВычисленноеКонтрольноеЗначение <> Число(КонтрольноеЗначение) Тогда
			
			СоответствуетТребованиям = Ложь;
			ТекстСообщения = НСтр("ru = 'Контрольное число БИН/ИИН не совпадает с рассчитанным.'");
			
		КонецЕсли;

	КонецЕсли;

	Возврат СоответствуетТребованиям;
	
КонецФункции
