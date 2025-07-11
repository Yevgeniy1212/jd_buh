﻿////////////////////////////////////////////////////////////////////////////////
// ПроцедурыНалоговогоУчетаВызовСервераПовтИсп: 
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция СформироватьСписокПустыхСсылокТиповСубконто() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ВидыСубконто.ТипЗначения
	|ИЗ
	|	ПланВидовХарактеристик.ВидыСубконтоТиповые КАК ВидыСубконто
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	СписокПустыхЗначений = Новый СписокЗначений;
	
	МассивОдногоТипа = Новый Массив(1);
	
	Пока Выборка.Следующий() Цикл
		МассивТипы = Выборка.ТипЗначения.Типы();
		Для Каждого ЭлементМассива Из МассивТипы Цикл
		    МассивОдногоТипа[0] = ЭлементМассива;			
			НовоеОписаниеТипов = Новый ОписаниеТипов(МассивОдногоТипа);
			ПустоеЗначениеТипа = НовоеОписаниеТипов.ПривестиЗначение(Неопределено);
			СписокПустыхЗначений.Добавить(ПустоеЗначениеТипа);
		КонецЦикла;
	КонецЦикла;
	Возврат СписокПустыхЗначений;
КонецФункции	

// Функция возвращает счет учета расчетов с контрагентом НУ,
// соответствующий указанному счету БУ, если соответствия нет, 
// или счет БУ не указан, то возвращается счет расчетов по-умолчанию
//
Функция ПолучитьСчетРасчетовСКонтрагентомНУ(СчетБУ = Неопределено) Экспорт
	Результат = ПланыСчетов.Налоговый.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(СчетБУ) Тогда
		Результат = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СчетБУ));
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Результат = ПланыСчетов.Налоговый.ПоступлениеИВыбытиеИмуществаработУслугПрав;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

//Функция определяет счет учета НДС к начислению
// по соответствию указанному счету БУ, если соответствия нет,
// или счет БУ не указан, то возвращается счет расчетов по-умолчанию
//
//Параметры
//	СчетУчетаБУ - ПланСчетовСсылка.Типовой - Счет учета БУ, для которого необходимо получить соответствующий счет НУ
//	Дата - Дата - Дата на которую необходимо получить срез соответствия счетов БУ и НУ
//
Функция ПолучитьСчетУчетаНДСКНачислениюНУ(СчетУчетаБУ = Неопределено, Дата = Неопределено)Экспорт
	
	СчетНУПоУмолчанию = ПланыСчетов.Налоговый.НДСНачисленныйПриПокупке;
	Если СчетУчетаБУ = Неопределено Тогда
		Возврат СчетНУПоУмолчанию;
	Иначе
		Возврат ПроцедурыБухгалтерскогоучета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, Дата, СчетНУПоУмолчанию);
	КонецЕсли;
	
КонецФункции

//Функция определяет счет учета НДС к возмещению
// по соответствию указанному счету БУ, если соответствия нет,
// или счет БУ не указан, то возвращается счет расчетов по-умолчанию
//
//Параметры
//	СчетУчетаБУ - ПланСчетовСсылка.Типовой - Счет учета БУ, для которого необходимо получить соответствующий счет НУ
//	Дата - Дата - Дата на которую необходимо получить срез соответствия счетов БУ и НУ
//
Функция ПолучитьСчетУчетаНДСКВозмещениюНУ(СчетУчетаБУ = Неопределено, Дата = Неопределено)Экспорт
	
	СчетНУПоУмолчанию = ПланыСчетов.Налоговый.НалогНаДобавленнуюСтоимостьКВозмещению;
	Если СчетУчетаБУ = Неопределено Тогда
		Возврат СчетНУПоУмолчанию;
	Иначе
		Возврат ПроцедурыБухгалтерскогоучета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, Дата, СчетНУПоУмолчанию);
	КонецЕсли;
	
КонецФункции

//Функция возвращает счет учета НДС
//
//Параметры
//	СчетУчетаБУ - ПланСчетовСсылка.Типовой - Счет учета БУ, для которого необходимо получить соответствующий счет НУ
//	Дата - Дата - Дата на которую необходимо получить срез соответствия счетов БУ и НУ
//
Функция ПолучитьСчетУчетаНДСНачисленногоНУ(СчетУчетаБУ = Неопределено, Дата = Неопределено)  Экспорт
	
	СчетНУПоУмолчанию = ПланыСчетов.Налоговый.НалогНаДобавленнуюСтоимость;
	Если СчетУчетаБУ = Неопределено Тогда
		Возврат СчетНУПоУмолчанию;
	Иначе
		Возврат ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, Дата, СчетНУПоУмолчанию);
	КонецЕсли;
	
КонецФункции

//Функция возвращает счет учета акциза
//
Функция ПолучитьСчетУчетаАкцизаНУ(СчетУчетаБУ = Неопределено, Дата = Неопределено) Экспорт
	
	СчетНУПоУмолчанию = ПланыСчетов.Налоговый.НалогНаДобавленнуюСтоимость;
	Если СчетУчетаБУ = Неопределено Тогда
		Возврат СчетНУПоУмолчанию;
	Иначе
		Возврат ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, Дата, СчетНУПоУмолчанию);
	КонецЕсли;
	
КонецФункции

//Функция возвращает счет учетп ИПН по НУ
Функция ПолучитьСчетУчетаНУИПН(СчетУчетаБУ = Неопределено, ТекДата = Неопределено)Экспорт
	
	СчетНУ = Справочники.НалогиСборыОтчисления.ИндивидуальныйПодоходныйНалог.СчетУчетаРасчетовСКонтрагентомНУ;
	Если НЕ ЗначениеЗаполнено(СчетНУ) Тогда
		СчетНУПоУмолчанию = ПланыСчетов.Налоговый.ПрочиеНалоги;
		Если СчетУчетаБУ = Неопределено Тогда
			СчетНУ = СчетНУПоУмолчанию;
		Иначе
			СчетНУ = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, ТекДата, СчетНУПоУмолчанию);
		КонецЕсли; 		
	КонецЕсли;  	
	Возврат СчетНУ;
	
КонецФункции

//Функция возвращает счет учета ОПВ по НУ
//
Функция ПолучитьСчетУчетаНУОПВ(СчетУчетаБУ = Неопределено, ТекДата = Неопределено) Экспорт
	
	СчетНУ = Справочники.НалогиСборыОтчисления.ОбязательныеПенсионныеВзносы.СчетУчетаРасчетовСКонтрагентомНУ;
	Если НЕ ЗначениеЗаполнено(СчетНУ) Тогда
		СчетНУПоУмолчанию = ПланыСчетов.Налоговый.ОбязательстваПоПенсионнымОтчислениям;
		Если СчетУчетаБУ = Неопределено Тогда
			СчетНУ = СчетНУПоУмолчанию;
		Иначе
			СчетНУ = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, ТекДата, СчетНУПоУмолчанию);
		КонецЕсли; 		
	КонецЕсли;  	
	Возврат СчетНУ;
	
КонецФункции

//Функция возвращает счет учета ОППВ по НУ
//
Функция ПолучитьСчетУчетаНУОППВ(СчетУчетаБУ = Неопределено, ТекДата = Неопределено) Экспорт
	
	СчетНУ = Справочники.НалогиСборыОтчисления.ОбязательныеПрофессиональныеПенсионныеВзносы.СчетУчетаРасчетовСКонтрагентомНУ;
	Если НЕ ЗначениеЗаполнено(СчетНУ) Тогда
		СчетНУПоУмолчанию = ПланыСчетов.Налоговый.ОбязательстваПоПенсионнымОтчислениям;
		Если СчетУчетаБУ = Неопределено Тогда
			СчетНУ = СчетНУПоУмолчанию;
		Иначе
			СчетНУ = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, ТекДата, СчетНУПоУмолчанию);
		КонецЕсли; 		
	КонецЕсли;  	
	Возврат СчетНУ;
	
КонецФункции

//Функция возвращает счет учета ОПВР по НУ
//
Функция ПолучитьСчетУчетаНУОПВР(СчетУчетаБУ = Неопределено, ТекДата = Неопределено) Экспорт
	
	СчетНУ = Справочники.НалогиСборыОтчисления.ОбязательныеПенсионныеВзносыРаботодателя.СчетУчетаРасчетовСКонтрагентомНУ;
	Если НЕ ЗначениеЗаполнено(СчетНУ) Тогда
		СчетНУПоУмолчанию = ПланыСчетов.Налоговый.ОбязательстваПоОбязательнымПенсионнымВзносамРаботодателя;
		Если СчетУчетаБУ = Неопределено Тогда
			СчетНУ = СчетНУПоУмолчанию;
		Иначе
			СчетНУ = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, ТекДата, СчетНУПоУмолчанию);
		КонецЕсли; 		
	КонецЕсли;  	
	Возврат СчетНУ;
	
КонецФункции

//Функция возвращает счет учета СО по НУ
//
Функция ПолучитьСчетУчетаНУСО(СчетУчетаБУ = Неопределено, ТекДата = Неопределено) Экспорт
	
	СчетНУ = Справочники.НалогиСборыОтчисления.ОбязательныеСоциальныеОтчисления.СчетУчетаРасчетовСКонтрагентомНУ;
	Если НЕ ЗначениеЗаполнено(СчетНУ) Тогда
		СчетНУПоУмолчанию = ПланыСчетов.Налоговый.ОбязательстваПоСоциальномуСтрахованию;
		Если СчетУчетаБУ = Неопределено Тогда
			СчетНУ = СчетНУПоУмолчанию;
		Иначе
			СчетНУ = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, ТекДата, СчетНУПоУмолчанию);
		КонецЕсли; 		
	КонецЕсли;  	
	Возврат СчетНУ;
	
КонецФункции 

//Функция возвращает счет учета СН по НУ
//
Функция ПолучитьСчетУчетаНУСН(СчетУчетаБУ = Неопределено, ТекДата = Неопределено)Экспорт
	
	СчетНУ = Справочники.НалогиСборыОтчисления.СоциальныйНалог.СчетУчетаРасчетовСКонтрагентомНУ;
	Если НЕ ЗначениеЗаполнено(СчетНУ) Тогда
		СчетНУПоУмолчанию = ПланыСчетов.Налоговый.ПрочиеНалоги;
		Если СчетУчетаБУ = Неопределено Тогда
			СчетНУ = СчетНУПоУмолчанию;
		Иначе
			СчетНУ = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, ТекДата, СчетНУПоУмолчанию);
		КонецЕсли; 		
	КонецЕсли;  	
	Возврат СчетНУ;
	
КонецФункции 

//Функция возвращает счет учета Взносов ОСМС по НУ
//
Функция ПолучитьСчетУчетаНУВОСМС(СчетУчетаБУ = Неопределено, ТекДата = Неопределено) Экспорт
	
	СчетНУ = Справочники.НалогиСборыОтчисления.ВзносыОбязательноеСоциальноеМедицинскоеСтрахование.СчетУчетаРасчетовСКонтрагентомНУ;
	Если НЕ ЗначениеЗаполнено(СчетНУ) Тогда
		СчетНУПоУмолчанию = ПланыСчетов.Налоговый.ОбязательстваПоВзносамОСМС;
		Если СчетУчетаБУ = Неопределено Тогда
			СчетНУ = СчетНУПоУмолчанию;
		Иначе
			СчетНУ = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, ТекДата, СчетНУПоУмолчанию);
		КонецЕсли; 		
	КонецЕсли;  	
	Возврат СчетНУ;
	
КонецФункции 

//Функция возвращает счет учета Отчислений ОСМС по НУ
//
Функция ПолучитьСчетУчетаНУООСМС(СчетУчетаБУ = Неопределено, ТекДата = Неопределено) Экспорт
	
	СчетНУ = Справочники.НалогиСборыОтчисления.ОтчисленияОбязательноеСоциальноеМедицинскоеСтрахование.СчетУчетаРасчетовСКонтрагентомНУ;
	Если НЕ ЗначениеЗаполнено(СчетНУ) Тогда
		СчетНУПоУмолчанию = ПланыСчетов.Налоговый.ОбязательстваПоОтчислениямОСМС;
		Если СчетУчетаБУ = Неопределено Тогда
			СчетНУ = СчетНУПоУмолчанию;
		Иначе
			СчетНУ = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, ТекДата, СчетНУПоУмолчанию);
		КонецЕсли; 		
	КонецЕсли;  	
	Возврат СчетНУ;
	
КонецФункции 

//Функция возвращает счет учета Отчислений ОСМС по НУ
//
Функция ПолучитьСчетУчетаНУЕП(СчетУчетаБУ = Неопределено, ТекДата = Неопределено) Экспорт
	
	СчетНУ = Справочники.НалогиСборыОтчисления.ЕдиныйПлатеж.СчетУчетаРасчетовСКонтрагентомНУ;
	Если НЕ ЗначениеЗаполнено(СчетНУ) Тогда
		СчетНУПоУмолчанию = ПланыСчетов.Налоговый.ПрочиеНалоги;
		Если СчетУчетаБУ = Неопределено Тогда
			СчетНУ = СчетНУПоУмолчанию;
		Иначе
			СчетНУ = ПроцедурыБухгалтерскогоУчета.ЗаполнитьСчетНалоговогоУчетаПоУмолчанию(СчетУчетаБУ, ТекДата, СчетНУПоУмолчанию);
		КонецЕсли; 		
	КонецЕсли;  	
	Возврат СчетНУ;
	
КонецФункции 

// Определяет является ли счет - счетом доходов
//
Функция СчетДоходов(Счет) Экспорт
	СписокСчетовДоходов = Новый Массив;
	// группы доходов
	// 6000
	СписокСчетовДоходов.Добавить(ПланыСчетов.Типовой.ДоходОтРеализацииПродукцииИОказанияУслуг_);
	// 6100
	СписокСчетовДоходов.Добавить(ПланыСчетов.Типовой.ДоходыОтФинансирования);
	// 6200
	СписокСчетовДоходов.Добавить(ПланыСчетов.Типовой.ПрочиеДоходы_);
	// 6300
	СписокСчетовДоходов.Добавить(ПланыСчетов.Типовой.ДоходыСвязанныеСПрекращаемойДеятельностью_);
	// 6400
	СписокСчетовДоходов.Добавить(ПланыСчетов.Типовой.ДоляПрибылиОрганизацийУчитываемыхПоМетодуДолевогоУчастия);
	
	Запрос = новый Запрос("ВЫБРАТЬ
	                      |	Типовой.Ссылка
	                      |ИЗ
	                      |	ПланСчетов.Типовой КАК Типовой
	                      |ГДЕ
	                      |	(Типовой.Ссылка В ИЕРАРХИИ(&СписокСчетовДоходов)) и (Типовой.Ссылка В ИЕРАРХИИ(&Счет))");
	Запрос.УстановитьПараметр("СписокСчетовДоходов", СписокСчетовДоходов);
	Запрос.УстановитьПараметр("Счет", Счет);
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
КонецФункции // СчетДоходов()

// Определяет является ли счет - счетом затрат
//
Функция СчетЗатрат(Счет) Экспорт
	СписокСчетовЗатрат = Новый Массив;
	// группы затрат
	// 7000
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.СебестоимостьРеализованнойПродукцииИОказанныхУслуг_);
	// 7100
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.РасходыПоРеализацииПродукцииИОказаниюУслуг_);
	// 7200
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.АдминистративныеРасходы_);
	// 7300 
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.РасходыНаФинансирование);
	// 7400
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.ПрочиеРасходы_);
	// 7500
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.РасходыСвязанныеСПрекращаемойДеятельностью_);
	// 7600
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.ДоляВУбыткеОрганизацийУчитываемыхМетодомДолевогоУчастия);
	// 7700
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.РасходыПоКорпоративномуПодоходномуНалогу_);
	
	// 8100 - производственные затраты
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.ОсновноеПроизводство_);	
	// 8200 - производственные затраты
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.ПолуфабрикатыСобственногоПроизводства_);	
	// 8300 - производственные затраты
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.ВспомогательныеПроизводства_);	
	// 8400 - производственные затраты
	СписокСчетовЗатрат.Добавить(ПланыСчетов.Типовой.НакладныеРасходы_);	
	
	Запрос = новый Запрос("ВЫБРАТЬ
	                      |	Типовой.Ссылка
	                      |ИЗ
	                      |	ПланСчетов.Типовой КАК Типовой
	                      |ГДЕ
	                      |	(Типовой.Ссылка В ИЕРАРХИИ(&СписокСчетовЗатрат)) и (Типовой.Ссылка В ИЕРАРХИИ(&Счет))");
	Запрос.УстановитьПараметр("СписокСчетовЗатрат", СписокСчетовЗатрат);
	Запрос.УстановитьПараметр("Счет", Счет);
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
КонецФункции // СчетЗатрат()

// Определяет относится ли счет к категории, отражаемых в НУ
// (является счетом доходов/затрат)
Функция ВлияетНаНалогооблагаемыйДоход(Счет) Экспорт
	// считаем, что счет оказывает влияние на налогооблагаемый доход 
	// если он относится к доходам, либо затратам предприятия
	
	Возврат СчетЗатрат(Счет) или СчетДоходов(Счет);	
КонецФункции // ВлияетНаНалогооблагаемыйДоход()

// Возвращает налоговый счет учета актива
// 
//
Функция ПолучитьСчетУчетаНУВнеоборотногоАктива(ВнеоборотныйАктив, Организация,Дата, ПризнакФА = Неопределено, ПризнакПримененияДвойнойНормыАмортизации = Неопределено) Экспорт
	
	СчетУчетуНУ = ПланыСчетов.Налоговый.ПустаяСсылка();
	
	Если НЕ ЗначениеЗаполнено(ВнеоборотныйАктив) ИЛИ НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат СчетУчетуНУ;
	КонецЕсли;
	
	// инициализация необходимых признаков
	Если ПризнакФА = Неопределено  Тогда
		ПризнакФА = ЯвляетсяФиксированнымАктивом(ВнеоборотныйАктив, Организация,Дата);
	КонецЕсли;	
	
	Если ПризнакПримененияДвойнойНормыАмортизации = Неопределено Тогда
		ПризнакПримененияДвойнойНормыАмортизации = ФиксированныйАктивУчитываемыйОтдельно(ВнеоборотныйАктив, Организация,Дата);
	КонецЕсли;	
	
	// Определение счета учета
	Если ПризнакФА Тогда
		Если ПризнакПримененияДвойнойНормыАмортизации Тогда
			// фиксированные активы, учитываемые отдельно
			СчетУчетуНУ = ПланыСчетов.Налоговый.ВАНеВключенныеВСтоимостнойБаланс;	
		Иначе
			// фиксированные активы
			СчетУчетуНУ = ПланыСчетов.Налоговый.ВАВключенныеВСтоимостнойБаланс;	
		КонецЕсли;	
		
	Иначе
		// активы не подлежащий амортизации в налоговом учете
		СчетУчетуНУ = ПланыСчетов.Налоговый.ВАНеПодлежащиеАмортизации;
	КонецЕсли; 

	Возврат СчетУчетуНУ
КонецФункции // ПолучитьСчетУчетаНУВнеоборотногоАктива()

// Функция возвращает счет налога по виду налога
//
Функция ПолучитьДанныеПоВидуНалога(СтруктураВидовНалоговПоСчетам, ВидНалогаСтрока, ВидНалогаСсылка) Экспорт
	
	Перем ПолученныйСчет;
	
	ДанныеПоВидуНалога = Новый Структура("СчетНалога, СтатьяЗатрат");
	
	ПолученныйСчет = ПланыСчетов.Типовой.ПустаяСсылка();
	СтатьяЗатрат   = Справочники.СтатьиЗатрат.ПустаяСсылка();
	
	Если НЕ ВидНалогаСсылка.Пустая() Тогда
		// получим счет из элемента справочника "Налоги, сборы, отчисления"
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	НалогиСборыОтчисления.Наименование,
		               |	НалогиСборыОтчисления.Ссылка,
		               |	НалогиСборыОтчисления.СчетУчетаРасчетовСКонтрагентомБУ КАК СчетНалога,
		               |	НалогиСборыОтчисления.СтатьяЗатрат,
		               |	НалогиСборыОтчисления.СчетУчетаРасчетовСКонтрагентомНУ Как СчетНалогаНУ
		               |ИЗ
		               |	Справочник.НалогиСборыОтчисления КАК НалогиСборыОтчисления
		               |ГДЕ
		               |	НалогиСборыОтчисления.Ссылка = &ВидНалогаСсылка";
		Запрос.УстановитьПараметр("ВидНалогаСсылка", ВидНалогаСсылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ПолученныйСчет = Выборка.СчетНалога;
			СтатьяЗатрат   = Выборка.СтатьяЗатрат;
		КонецЕсли;
		Если ПолученныйСчет = ПланыСчетов.Типовой.ПустаяСсылка() Тогда
			СтруктураВидовНалоговПоСчетам.Свойство(ВидНалогаСтрока,ПолученныйСчет);
		КонецЕсли;			
	Иначе			
		СтруктураВидовНалоговПоСчетам.Свойство(ВидНалогаСтрока,ПолученныйСчет);
	КонецЕсли;
	
	ДанныеПоВидуНалога.СчетНалога   = ПолученныйСчет;
	ДанныеПоВидуНалога.СтатьяЗатрат = СтатьяЗатрат;
	
	Возврат ДанныеПоВидуНалога;
	
КонецФункции

// Функция возвращает элемент справочника "Налоги, сборы, отчисления"
// в зависимости от требуемого налога и КБК
Функция ПолучитьВидНалогаПоКБК(ВидНалога, КБК) Экспорт
	
	Попытка
		// найдем предопределенный элемент по имени, если он есть
		ПолученныйВидНалога = Справочники.НалогиСборыОтчисления[ВидНалога];
	Исключение
		// иначе ищем по КБК
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	НалогиСборыОтчисления.Наименование,
		               |	НалогиСборыОтчисления.Ссылка
		               |ИЗ
		               |	Справочник.НалогиСборыОтчисления КАК НалогиСборыОтчисления
		               |ГДЕ
		               |	НалогиСборыОтчисления.КодБК = &КодБК";
		Запрос.УстановитьПараметр("КодБК", КБК);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ПолученныйВидНалога = Выборка.Ссылка;
		Иначе
			ПолученныйВидНалога = Справочники.НалогиСборыОтчисления.ПустаяСсылка();
		КонецЕсли;
		
	КонецПопытки;	
	
	Возврат ПолученныйВидНалога;
	
КонецФункции

// Возвращает дату начала применения единой суммы заявленного дохода ИП,
// применяемой при расчете ОПВ, СО, ВОСМС для ИП
Функция ПолучитьДатуВводаЗаявленногоДоходаИП() Экспорт
	
	Возврат Дата(2023,7,1);
	
КонецФункции

// Возвращает дату начала применения налогового режима "Розничный налог"
//
Функция ПолучитьДатуВводаРозничногоНалога() Экспорт
	
	Возврат Дата(2023,1,1);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет проверку принадлежности внеоборотного актива к фиксированным активам организации
// Функция возвращает
// 					Истина - в случае, если ВА является фиксированным активом
//					Ложь - в противном случае
Функция ЯвляетсяФиксированнымАктивом(ВнеоборотныйАктив, Организация,Дата) Экспорт	
	
	Если НЕ ЗначениеЗаполнено(ВнеоборотныйАктив) ИЛИ НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ОбъектыНалоговогоУчетаФАСрезПоследних.ФиксированныйАктив
	                      |ИЗ
	                      |	РегистрСведений.ОбъектыНалоговогоУчетаФА.СрезПоследних(
	                      |		&Дата,
	                      |		Организация = &Организация
	                      |			И ФиксированныйАктив = &ВнеоборотныйАктив
	                      |			И СостояниеФиксированногоАктива = &СостояниеФА) КАК ОбъектыНалоговогоУчетаФАСрезПоследних");
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ВнеоборотныйАктив);
	Запрос.УстановитьПараметр("СостояниеФА", Перечисления.ВидыСостоянийФА.ПринятКУчету);
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
КонецФункции	

// Выполняет проверку учета фиксированного актива отдельно от стоимостного баланса подгрупп
// в связи с применением двойной нормы амортизации в первый год эксплуатации
// Функция возвращает
// 					Истина - в случае, если ВА является фиксированным активом, учитываемым отдельно
//							 и он еще не включен в состав группы
//					Ложь - в противном случае
Функция ФиксированныйАктивУчитываемыйОтдельно(ВнеоборотныйАктив, Организация,Дата) Экспорт	
	
	Если НЕ ЗначениеЗаполнено(ВнеоборотныйАктив) ИЛИ НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ФиксированныеАктивыУчитываемыеОтдельноСрезПоследних.ФиксированныйАктив
	                      |ИЗ
	                      |	РегистрСведений.ФиксированныеАктивыУчитываемыеОтдельно.СрезПоследних(
	                      |		&Дата,
	                      |		Организация = &Организация
	                      |			И ФиксированныйАктив = &ВнеоборотныйАктив
	                      |			) КАК ФиксированныеАктивыУчитываемыеОтдельноСрезПоследних
						  |ГДЕ Событие = &СобытиеФА");
						  
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ВнеоборотныйАктив);
	Запрос.УстановитьПараметр("СобытиеФА", Перечисления.СобытияФАУчитываемыхОтдельно.ПринятиеКУчету);
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
			
КонецФункции	

// Функция возвращает налогоплательщика для переданной структурной единицы
//
// Параметры:
//	СтруктурнаяЕдиница - Организация/Подразделение организации
//	Организация - организация из шапки документа
//	РазделНУ - значение перечисления РазделыНалоговогоУчета
//
Функция ПолучитьНалогоплательщикаСтруктурнойЕдиницы(СтруктурнаяЕдиница, Организация, РазделНУ) Экспорт
	
	ЗаписьОСтруктурнойЕдинице = Неопределено;
	ИсчислениеНалоговСтруктурныхЕдиниц =  ПолныеПраваПовтИсп.ЗаполнитьИсчислениеНалоговСтруктурныхЕдиниц();
	
	Если ИсчислениеНалоговСтруктурныхЕдиниц <> Неопределено Тогда
		ЗаписьОСтруктурнойЕдинице = ИсчислениеНалоговСтруктурныхЕдиниц[СтруктурнаяЕдиница];
		Если ЗаписьОСтруктурнойЕдинице = Неопределено Тогда
			ЗаписьОСтруктурнойЕдинице = ИсчислениеНалоговСтруктурныхЕдиниц[Организация];
		КонецЕсли;
	КонецЕсли;

	Если ЗаписьОСтруктурнойЕдинице = Неопределено Тогда
		Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.Организации") Тогда
			Возврат СтруктурнаяЕдиница;
		Иначе
			Возврат Организация;
		КонецЕсли;
	Иначе
		ИмяРазделаНУ = Метаданные.Перечисления.РазделыНалоговогоУчета.ЗначенияПеречисления[Перечисления.РазделыНалоговогоУчета.Индекс(РазделНУ)].Имя;
		Возврат ЗаписьОСтруктурнойЕдинице[ИмяРазделаНУ].Налогоплательщик;
    КонецЕсли;

КонецФункции // ПолучитьНалогоплательщикаСтруктурнойЕдиницы()

Функция СформироватьСписокОрганизацийНалогоплательщика(Налогоплательщик, РазделНалоговогоУчета, ТолькоГоловныеОрганизации = Ложь) Экспорт

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Налогоплательщик", Налогоплательщик);
	Запрос.УстановитьПараметр("РазделНалоговогоУчета", РазделНалоговогоУчета);
	
	Если ТолькоГоловныеОрганизации Тогда
		УчетнаяПолитикаПоПерсоналуОрганизацииТаблица = ПолныеПраваПовтИсп.СформироватьТаблицуУчетнойПолитикиПоПерсоналу();		
		Запрос.УстановитьПараметр("парамУчетнаяПолитикаПоПерсоналуОрганизации", УчетнаяПолитикаПоПерсоналуОрганизацииТаблица);		
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	УчетнаяПолитика.Организация,
		|	УчетнаяПолитика.ВедениеУчетаПоГоловнойОрганизации
		|ПОМЕСТИТЬ ВТ_УчетнаяПолитикаПоПерсоналуОрганизации
		|ИЗ
		|	&парамУчетнаяПолитикаПоПерсоналуОрганизации КАК УчетнаяПолитика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ВЫБОР
		|		КОГДА Организации.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|				ИЛИ (НЕ ВТ_УчетнаяПолитикаПоПерсоналуОрганизации.ВедениеУчетаПоГоловнойОрганизации)
		|			ТОГДА Организации.Ссылка
		|		ИНАЧЕ Организации.ГоловнаяОрганизация
		|	КОНЕЦ КАК Ссылка,
		|	ВЫБОР
		|		КОГДА Организации.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|				ИЛИ (НЕ ВТ_УчетнаяПолитикаПоПерсоналуОрганизации.ВедениеУчетаПоГоловнойОрганизации)
		| 			ТОГДА Организации.Наименование
		| 		ИНАЧЕ Организации.ГоловнаяОрганизация.Наименование
		|	КОНЕЦ КАК Наименование
		|ИЗ
		|	Справочник.Организации КАК Организации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов
		|		ПО Организации.Ссылка = ИсчислениеНалогов.СтруктурнаяЕдиница
		|			И (ИсчислениеНалогов.РазделНалоговогоУчета = &РазделНалоговогоУчета)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УчетнаяПолитикаПоПерсоналуОрганизации КАК ВТ_УчетнаяПолитикаПоПерсоналуОрганизации
		|		ПО Организации.Ссылка = ВТ_УчетнаяПолитикаПоПерсоналуОрганизации.Организация
		|ГДЕ
		|	ЕСТЬNULL(ИсчислениеНалогов.Налогоплательщик, Организации.Ссылка) = &Налогоплательщик";
	Иначе
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка,
		|	Организации.Наименование
		|ИЗ
		|	Справочник.Организации КАК Организации
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов
		|		ПО Организации.Ссылка = ИсчислениеНалогов.СтруктурнаяЕдиница
		|			И ИсчислениеНалогов.РазделНалоговогоУчета = &РазделНалоговогоУчета
		|ГДЕ
		|	ЕСТЬNULL(ИсчислениеНалогов.Налогоплательщик, Организации.Ссылка) = &Налогоплательщик
		|";
	КонецЕсли;
	
	СписокОрганизаций = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовыйЭлемент 				= СписокОрганизаций.Добавить();
		НовыйЭлемент.Значение 		= Выборка.Ссылка;
		НовыйЭлемент.Представление 	= Выборка.Наименование;
	КонецЦикла;
	
	Возврат СписокОрганизаций;

КонецФункции

Функция СформироватьСписокСтруктурныхЕдиниц(РазделНалоговогоУчета, НалоговыйКомитет = Неопределено, Налогоплательщик = Неопределено) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НалоговыйКомитет", 		НалоговыйКомитет);
	Запрос.УстановитьПараметр("РазделНалоговогоУчета", 	РазделНалоговогоУчета);
	Запрос.УстановитьПараметр("Налогоплательщик", 		Налогоплательщик);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
					|	Организации.Ссылка КАК СтруктурнаяЕдиница,
					|	Организации.Наименование КАК Наименование
					|ИЗ
					|	Справочник.Организации КАК Организации
					|
					|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов
					|		ПО Организации.Ссылка = ИсчислениеНалогов.СтруктурнаяЕдиница
					|			И ИсчислениеНалогов.РазделНалоговогоУчета = &РазделНалоговогоУчета";
	
	ТекстУсловия = "";
	
	Если ЗначениеЗаполнено(НалоговыйКомитет) Тогда
		ТекстУсловия = "ЕСТЬNULL(ИсчислениеНалогов.НалоговыйКомитет, Организации.НалоговыйКомитет) = &НалоговыйКомитет";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Налогоплательщик) Тогда
		Если Не ПустаяСтрока(ТекстУсловия) Тогда
			ТекстУсловия = ТекстУсловия + " 
			|	И ";
		КонецЕсли;
		ТекстУсловия = ТекстУсловия + "ЕСТЬNULL(ИсчислениеНалогов.Налогоплательщик, Организации.Ссылка) = &Налогоплательщик";
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстУсловия) Тогда
		Запрос.Текст = Запрос.Текст + "
		|ГДЕ " + ТекстУсловия;
	КонецЕсли;

	Если НЕ (РазделНалоговогоУчета = Перечисления.РазделыНалоговогоУчета.КПН 
		ИЛИ РазделНалоговогоУчета = Перечисления.РазделыНалоговогоУчета.НДС) Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодразделенияОрганизаций.Ссылка КАК СтруктурнаяЕдиница,
		|	ПодразделенияОрганизаций.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов_Подр
		|		ПО ПодразделенияОрганизаций.Ссылка = ИсчислениеНалогов_Подр.СтруктурнаяЕдиница
		|			И ИсчислениеНалогов_Подр.РазделНалоговогоУчета = &РазделНалоговогоУчета
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов_Орг
		|		ПО ПодразделенияОрганизаций.Владелец = ИсчислениеНалогов_Орг.СтруктурнаяЕдиница
		|			И ИсчислениеНалогов_Орг.РазделНалоговогоУчета = &РазделНалоговогоУчета
		|ГДЕ
		|	ПодразделенияОрганизаций.ЯвляетсяСтруктурнымПодразделением";
		
		Если ЗначениеЗаполнено(НалоговыйКомитет) Тогда
			Запрос.Текст = Запрос.Текст + "
			|	И ЕСТЬNULL(ИсчислениеНалогов_Подр.НалоговыйКомитет, ЕСТЬNULL(ИсчислениеНалогов_Подр.НалоговыйКомитет, ПодразделенияОрганизаций.Владелец.НалоговыйКомитет)) = &НалоговыйКомитет";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Налогоплательщик) Тогда
			Запрос.Текст = Запрос.Текст + "
			|	И ЕСТЬNULL(ИсчислениеНалогов_Подр.Налогоплательщик, ЕСТЬNULL(ИсчислениеНалогов_Орг.Налогоплательщик, ПодразделенияОрганизаций.Владелец)) = &Налогоплательщик";
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
	|УПОРЯДОЧИТЬ ПО
	|	Наименование
	|";

	СписокСтруктурныхЕдиниц = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовыйЭлемент 				= СписокСтруктурныхЕдиниц.Добавить();
		НовыйЭлемент.Значение 		= Выборка.СтруктурнаяЕдиница;
		НовыйЭлемент.Представление 	= Выборка.Наименование;
	КонецЦикла;
	
	Возврат СписокСтруктурныхЕдиниц;

КонецФункции // СформироватьСписокСтруктурныхЕдиниц()

// Функция формирует список налоговых комитетов, в которые может сдавать отчетность выбранных налогоплательщик
//
// Параметры:
//	Налогоплательщик - СправочникСсылка.Организации/СправочникСсылка.ПодразделенияОрганизаций - налогоплательщик
//	РазделНалоговогоУчета - значение перечисления РазделыНалоговогоУчета
//
// Возвращаемое значение:
//		Список значений, содержащий налоговых комитетов, удовлетворяющие условию отбора
//
Функция СформироватьСписокНалоговыхКомитетов(Налогоплательщик, РазделНалоговогоУчета) Экспорт

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Налогоплательщик", Налогоплательщик);
	Запрос.УстановитьПараметр("РазделНалоговогоУчета", РазделНалоговогоУчета);
	Запрос.УстановитьПараметр("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВЫБОР
	|		КОГДА ИсчислениеНалогов.НалоговыйКомитет = &ПустойКонтрагент
	|			ТОГДА ИсчислениеНалогов.Налогоплательщик.НалоговыйКомитет
	|		ИНАЧЕ ИсчислениеНалогов.НалоговыйКомитет
	|	КОНЕЦ КАК НалоговыйКомитет,
	|	ВЫБОР
	|		КОГДА ИсчислениеНалогов.НалоговыйКомитет = &ПустойКонтрагент
	|			ТОГДА ИсчислениеНалогов.Налогоплательщик.НалоговыйКомитет.Наименование
	|		ИНАЧЕ ИсчислениеНалогов.НалоговыйКомитет.Наименование
	|	КОНЕЦ КАК НаименованиеНК
	|ИЗ
	|	РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов
	|ГДЕ
	|	ИсчислениеНалогов.Налогоплательщик = &Налогоплательщик
	|	И ИсчислениеНалогов.РазделНалоговогоУчета = &РазделНалоговогоУчета
	|
	|ОБЪЕДИНИТЬ // неповторяющиеся
	|
	|ВЫБРАТЬ 
	|	// если самого налогоплательщика нет в регистре, то берем налоговый комитет из справочника Организации
	|	ВЫБОР
	|		КОГДА НЕ(ИсчислениеНалогов.НалоговыйКомитет ЕСТЬ NULL)
	|			ТОГДА ВЫБОР
	|					КОГДА ИсчислениеНалогов.НалоговыйКомитет = &ПустойКонтрагент
	|						ТОГДА ИсчислениеНалогов.Налогоплательщик.НалоговыйКомитет
	|					ИНАЧЕ ИсчислениеНалогов.НалоговыйКомитет
	|				  КОНЕЦ
	|		ИНАЧЕ Организации.НалоговыйКомитет
	|	КОНЕЦ КАК НалоговыйКомитет,
	|	ВЫБОР
	|		КОГДА НЕ(ИсчислениеНалогов.НалоговыйКомитет ЕСТЬ NULL)
	|			ТОГДА ВЫБОР
	|					КОГДА ИсчислениеНалогов.НалоговыйКомитет = &ПустойКонтрагент
	|						ТОГДА ИсчислениеНалогов.Налогоплательщик.НалоговыйКомитет.Наименование
	|					ИНАЧЕ ИсчислениеНалогов.НалоговыйКомитет.Наименование
	|				  КОНЕЦ
	|		ИНАЧЕ Организации.НалоговыйКомитет.Наименование
	|	КОНЕЦ КАК НаименованиеНК
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсчислениеНалоговСтруктурныхЕдиниц КАК ИсчислениеНалогов
	|		ПО ИсчислениеНалогов.СтруктурнаяЕдиница = &Налогоплательщик
	|			И ИсчислениеНалогов.РазделНалоговогоУчета = &РазделНалоговогоУчета
	|
	|ГДЕ
	|	Организации.Ссылка = &Налогоплательщик
	|	
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеНК
	|";
	
	СписокНК = Новый СписокЗначений;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.НалоговыйКомитет) Тогда
			ЭлементСписка 				= СписокНК.Добавить();
			ЭлементСписка.Значение 		= Выборка.НалоговыйКомитет;
			ЭлементСписка.Представление = Выборка.НаименованиеНК;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокНК;

КонецФункции // СформироватьСписокНалоговыхКомитетов()

