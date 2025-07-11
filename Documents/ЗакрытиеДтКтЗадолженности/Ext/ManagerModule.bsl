﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура заполняет ТЧ Задолженность остатками по бухгалтерскому учету
//
Процедура ЗаполнитьОстатками(СтруктураПараметров, АдресХранилища) Экспорт
	
	Запрос = Новый Запрос;
	
	ЕстьРасчетыПоДокументам = Ложь;
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Контрагенты);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Договоры);
	Если ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.НаСчетеВедетсяУчетПоДокументамРасчетов(СтруктураПараметров.СчетДт) Тогда
		ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.ДокументыРасчетовСКонтрагентами);
		ЕстьРасчетыПоДокументам = Истина;
	КонецЕсли;
	
 	Запрос.УстановитьПараметр("Счет", СтруктураПараметров.СчетДт);
	Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
	
	Если ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями") Тогда
		Запрос.УстановитьПараметр("СтруктурноеПодразделение", СтруктураПараметров.СтруктурноеПодразделение);
		УсловиеСтруктурноеПодразделение = " И СтруктурноеПодразделение = &СтруктурноеПодразделение ";
	Иначе
		УсловиеСтруктурноеПодразделение = "";
	КонецЕсли;

	Запрос.УстановитьПараметр("ДатаОкончания", Новый Граница(СтруктураПараметров.Дата, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ВидыСубконто",  ВидыСубконто);
	Запрос.УстановитьПараметр("ВидСчета",      ВидСчета.Пассивный);
	Запрос.УстановитьПараметр("Знак",          1);
	
	Запрос.Текст = "ВЫБРАТЬ
		|	ТиповойОстатки.Субконто1 КАК Контрагент,
		|	ТиповойОстатки.Субконто2 КАК Договор,
		|	ТиповойОстатки.Валюта КАК Валюта,";
	Если ЕстьРасчетыПоДокументам Тогда
		Запрос.Текст = Запрос.Текст+"
		|	ТиповойОстатки.Субконто3 КАК Сделка,
		|	ТиповойОстатки.Субконто3.Дата КАК ДатаСделки,";           
	Иначе
		Запрос.Текст = Запрос.Текст+"
		|	НЕОПРЕДЕЛЕНО КАК Сделка,
		|	НЕОПРЕДЕЛЕНО КАК ДатаСделки,";
	КонецЕсли; 
	Запрос.Текст = Запрос.Текст+"
		|	СУММА(ВЫБОР
		|			КОГДА ТиповойОстатки.Счет.Вид = &ВидСчета
		|				ТОГДА ВЫБОР
		|						КОГДА &Знак * ТиповойОстатки.СуммаОстаток > 0
		|							ТОГДА ТиповойОстатки.СуммаОстаток
		|						ИНАЧЕ 0
		|					КОНЕЦ
		|			ИНАЧЕ ТиповойОстатки.СуммаОстаток
		|		КОНЕЦ) КАК Сумма,
		|	СУММА(ВЫБОР
		|			КОГДА ТиповойОстатки.Счет.Вид = &ВидСчета
		|				ТОГДА ВЫБОР
		|						КОГДА &Знак * ТиповойОстатки.ВалютнаяСуммаОстаток > 0
		|							ТОГДА ТиповойОстатки.ВалютнаяСуммаОстаток
		|						ИНАЧЕ 0
		|					КОНЕЦ
		|			ИНАЧЕ ТиповойОстатки.ВалютнаяСуммаОстаток
		|		КОНЕЦ) КАК ВалютнаяСумма
		|ИЗ
		|	РегистрБухгалтерии.Типовой.Остатки(&ДатаОкончания, Счет = &Счет, &ВидыСубконто, Организация = &Организация " + УсловиеСтруктурноеПодразделение + ") КАК ТиповойОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	ТиповойОстатки.Субконто1,
		|	ТиповойОстатки.Субконто2,
		|	ТиповойОстатки.Валюта,";
	Если ЕстьРасчетыПоДокументам Тогда
		Запрос.Текст = Запрос.Текст+"
		|	ТиповойОстатки.Субконто3,
		|	ТиповойОстатки.Субконто3.Дата";
	Иначе
		Запрос.Текст = Запрос.Текст+"
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО";
	КонецЕсли;                                                         
	Запрос.Текст = Запрос.Текст+"
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаСделки
		|ИТОГИ
		|	СУММА(Сумма),
		|	СУММА(ВалютнаяСумма)
		|ПО
		|	Контрагент,
		|	Валюта";
	
	ДеревоОстатковДт = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Запрос.УстановитьПараметр("Счет",     СтруктураПараметров.СчетКт);
	Запрос.УстановитьПараметр("ВидСчета", ВидСчета.Активный);
	Запрос.УстановитьПараметр("Знак",     -1);
	
	ДеревоОстатковКт = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Для ИндексКонтрагента = 0 По ДеревоОстатковДт.Строки.Количество()-1 Цикл
		СтрокаПоКонтрагентуДт = ДеревоОстатковДт.Строки[ИндексКонтрагента];
		СтрокаПоКонтрагентуКт = ДеревоОстатковКт.Строки.Найти(СтрокаПоКонтрагентуДт.Контрагент,"Контрагент", Ложь);
		Если СтрокаПоКонтрагентуКт = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Для ИндексВалюты = 0 По СтрокаПоКонтрагентуДт.Строки.Количество()-1 Цикл
			СтрокаПоВалютеДт = СтрокаПоКонтрагентуДт.Строки[ИндексВалюты];
			СтрокаПоВалютеКт = СтрокаПоКонтрагентуКт.Строки.Найти(СтрокаПоВалютеДт.Валюта, "Валюта", Ложь);
			Если СтрокаПоВалютеКт = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Для ИндексДеталейДт = 0 По СтрокаПоВалютеДт.Строки.Количество() - 1 Цикл
				СтрокаДеталейДт = СтрокаПоВалютеДт.Строки[ИндексДеталейДт];
				Для ИндексДеталейКт = 0 По СтрокаПоВалютеКт.Строки.Количество() - 1 Цикл
					СтрокаДеталейКт = СтрокаПоВалютеКт.Строки[ИндексДеталейКт];
					
					Если СтрокаДеталейДт.Сумма = 0 Тогда
						Прервать;
					КонецЕсли;
					Если СтрокаДеталейКт.Сумма = 0 Тогда
						Продолжить;
					КонецЕсли;
					
					Если СтрокаДеталейДт.Сумма >= 0 Тогда
						ЗнакДт = 1;
					Иначе
						ЗнакДт = -1
					КонецЕсли;
					Если СтрокаДеталейКт.Сумма >= 0 Тогда
						ЗнакКт = 1;
					Иначе
						ЗнакКт = -1
					КонецЕсли;
					Если ЗнакДт = ЗнакКт Тогда
						Продолжить;
					КонецЕсли;
					
					Сумма = ЗнакДт*МИН(СтрокаДеталейДт.Сумма*ЗнакДт,СтрокаДеталейКт.Сумма*ЗнакКт);
					СуммаВзаиморасчетов   = ЗнакДт*МИН(СтрокаДеталейДт.ВалютнаяСумма*ЗнакДт,СтрокаДеталейКт.ВалютнаяСумма*ЗнакКт);
					СтрокаДеталейДт.Сумма = СтрокаДеталейДт.Сумма - Сумма*ЗнакДт;
					СтрокаДеталейКт.Сумма = СтрокаДеталейКт.Сумма - Сумма*ЗнакКт;
					СтрокаДеталейДт.ВалютнаяСумма = СтрокаДеталейДт.ВалютнаяСумма - СуммаВзаиморасчетов*ЗнакДт;
					СтрокаДеталейКт.ВалютнаяСумма = СтрокаДеталейКт.ВалютнаяСумма - СуммаВзаиморасчетов*ЗнакКт;
					
					НоваяСтрока = СтруктураПараметров.Задолженность.Добавить();
					НоваяСтрока.Сумма = Сумма;
					НоваяСтрока.Контрагент = СтрокаДеталейДт.Контрагент;
					НоваяСтрока.ВалютаВзаиморасчетов = СтрокаДеталейДт.Валюта;
					НоваяСтрока.ДоговорКонтрагентаДт = СтрокаДеталейДт.Договор;
					НоваяСтрока.ДоговорКонтрагентаКт = СтрокаДеталейКт.Договор;
					НоваяСтрока.СделкаПоСчетуДебета  = СтрокаДеталейДт.Сделка;
					НоваяСтрока.СделкаПоСчетуКредита = СтрокаДеталейКт.Сделка;
					НоваяСтрока.СуммаВзаиморасчетов  = СуммаВзаиморасчетов;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	СтруктураДанныхЗаполнения = Новый Структура;
	СтруктураДанныхЗаполнения.Вставить("Задолженность", СтруктураПараметров.Задолженность);
	
	ПоместитьВоВременноеХранилище(СтруктураДанныхЗаполнения, АдресХранилища);
	
Конецпроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	Если ОбщегоНазначенияБККлиентСервер.ЭтоПростаяВерсияКонфигурации() Тогда
		БлокируемыеРеквизиты.Добавить("Дата");
		БлокируемыеРеквизиты.Добавить("Номер");
		БлокируемыеРеквизиты.Добавить("СуммаДокумента");
		БлокируемыеРеквизиты.Добавить("Организация; СтруктурноеПодразделениеОрганизация; ПредставлениеСпискаСтруктурныхЕдиниц");
		БлокируемыеРеквизиты.Добавить("СтруктурноеПодразделение");
		
		// таб. часть Задолженность
		БлокируемыеРеквизиты.Добавить("Задолженность; ЗадолженностьЗаполнитьПоОстаткам");
		БлокируемыеРеквизиты.Добавить("Задолженность.Контрагент; ЗадолженностьКонтрагент");
		БлокируемыеРеквизиты.Добавить("Задолженность.ДоговорКонтрагентаДт; ЗадолженностьДоговорКонтрагентаДт");
		БлокируемыеРеквизиты.Добавить("Задолженность.ДоговорКонтрагентаКт; ЗадолженностьДоговорКонтрагентаКт");
		БлокируемыеРеквизиты.Добавить("Задолженность.Сумма; ЗадолженностьСумма");
		БлокируемыеРеквизиты.Добавить("Задолженность.ВалютаВзаиморасчетов; ЗадолженностьВалютаВзаиморасчетов");
		БлокируемыеРеквизиты.Добавить("Задолженность.СуммаВзаиморасчетов; ЗадолженностьСуммаВзаиморасчетов");
					
	КонецЕсли;
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

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

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента();
	Результат = Запрос.Выполнить();
	ПараметрыПроведения.Вставить("ТаблицаРеквизитов", Результат.Выгрузить());
	
	Реквизиты = ПараметрыПроведения.ТаблицаРеквизитов[0];
	
	Если НЕ УчетнаяПолитикаСервер.Существует(Реквизиты.Организация, Реквизиты.Период, "БУ", Истина, ДокументСсылка)
		ИЛИ НЕ УчетнаяПолитикаСервер.Существует(Реквизиты.Организация, Реквизиты.Период, "НУ", Истина, ДокументСсылка) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	ОрганизацияПлательщикНалогаНаПрибыль 			= ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Реквизиты.Организация, Реквизиты.Период);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Реквизиты.Организация, Реквизиты.Период);
	
	НеобходимостьОтраженияВНУ 						= ОрганизацияПлательщикНалогаНаПрибыль И Реквизиты.УчитыватьКПН И (ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ Реквизиты.ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ);
	
	ПараметрыПроведения.ТаблицаРеквизитов.ЗаполнитьЗначения(НеобходимостьОтраженияВНУ					  , "НеобходимостьОтраженияВНУ");
	ПараметрыПроведения.ТаблицаРеквизитов.ЗаполнитьЗначения(ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль, "ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль");
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаТаблицаЗадолженность(НомераТаблиц);
		
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;

КонецФункции 

Функция ТекстЗапросаРеквизитыДокумента()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	Реквизиты.СчетДт КАК СчетДт,
	|	Реквизиты.СчетКт КАК СчетКт,
	|	Реквизиты.УчитыватьКПН КАК УчитыватьКПН,
	|	Реквизиты.ВидУчетаНУ КАК ВидУчетаНУ,
	|	ЛОЖЬ КАК НеобходимостьОтраженияВНУ,
	|	ЛОЖЬ КАК ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль
	|ИЗ
	|	Документ.ЗакрытиеДтКтЗадолженности КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса 
	
КонецФункции

Функция ТекстЗапросаТаблицаЗадолженность(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаЗадолженность", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаЗадолженность.Ссылка,
	|	ТаблицаЗадолженность.НомерСтроки,
	|	ТаблицаЗадолженность.Контрагент,
	|	ТаблицаЗадолженность.ДоговорКонтрагентаДт КАК ДоговорДебет,
	|	ТаблицаЗадолженность.ДоговорКонтрагентаКт КАК ДоговорКредит,
	|	ТаблицаЗадолженность.СделкаПоСчетуДебета КАК СделкаДебет,
	|	ТаблицаЗадолженность.СделкаПоСчетуКредита КАК СделкаКредит,
	|	ТаблицаЗадолженность.Сумма,
	|	ТаблицаЗадолженность.ВалютаВзаиморасчетов,
	|	ТаблицаЗадолженность.СуммаВзаиморасчетов
	|ИЗ
	|	Документ.ЗакрытиеДтКтЗадолженности.Задолженность КАК ТаблицаЗадолженность
	|ГДЕ
	|	ТаблицаЗадолженность.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаЗадолженность.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры формирования движений

Процедура СформироватьДвиженияЗакрытиеДтКтЗадолженности(Таблица, ТаблицаРеквизитов, Движения, Отказ) Экспорт
	
	Если Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = ТаблицаРеквизитов[0];
	
	КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	
	СвойстваСчетаДт = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(Реквизиты.СчетДт);
	СвойстваСчетаКт = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(Реквизиты.СчетКт);
	
	Для Каждого СтрокаТаблицы ИЗ Таблица Цикл
		
		Проводка = Движения.Типовой.Добавить();
		
		Проводка.Период      = Реквизиты.Период;
		Проводка.Организация = Реквизиты.Организация;
		Проводка.Содержание  = НСтр("ru = 'Закрытие дт/кт задолженности'", КодОсновногоЯзыка);
		
		Проводка.СчетДт      = Реквизиты.СчетКт;
		Проводка.СчетКт      = Реквизиты.СчетДт;
		
		Если СвойстваСчетаДт.Валютный Тогда 
			Проводка.ВалютаКт        = СтрокаТаблицы.ВалютаВзаиморасчетов;
			Проводка.ВалютнаяСуммаКт = СтрокаТаблицы.СуммаВзаиморасчетов;
		КонецЕсли;
		
		Если СвойстваСчетаКт.Валютный Тогда 
			Проводка.ВалютаДт        = СтрокаТаблицы.ВалютаВзаиморасчетов;
			Проводка.ВалютнаяСуммаДт = СтрокаТаблицы.СуммаВзаиморасчетов;
		КонецЕсли;
		
		Проводка.Сумма = СтрокаТаблицы.Сумма;
		
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", СтрокаТаблицы.Контрагент, Истина);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Договоры",    СтрокаТаблицы.ДоговорКредит);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "ДокументыРасчетовСКонтрагентами",    СтрокаТаблицы.СделкаКредит);
		
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", СтрокаТаблицы.Контрагент, Истина);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Договоры",    СтрокаТаблицы.ДоговорДебет);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "ДокументыРасчетовСКонтрагентами",    СтрокаТаблицы.СделкаДебет);
		
		ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
				Проводка, Реквизиты.СтруктурноеПодразделение, Реквизиты.СтруктурноеПодразделение);
				
		//формирование проводок по НУ
		//
		Если Реквизиты.НеобходимостьОтраженияВНУ Тогда
			//если договра равны, то проводки не делаем
			Если СтрокаТаблицы.ДоговорКредит = СтрокаТаблицы.ДоговорДебет Тогда
				Продолжить;
			КонецЕсли;
			
			ПроводкаНУ = Движения.Налоговый.Добавить();
			
			ПроводкаНУ.Период      = Реквизиты.Период;
			ПроводкаНУ.Организация = Реквизиты.Организация;
			ПроводкаНУ.Содержание  = НСтр("ru = 'Закрытие дт/кт задолженности'", КодОсновногоЯзыка);
			
			ПроводкаНУ.СчетДт      = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.ПолучитьСчетРасчетовСКонтрагентомНУ(Реквизиты.СчетКт);
			ПроводкаНУ.СчетКт      = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.ПолучитьСчетРасчетовСКонтрагентомНУ(Реквизиты.СчетДт);
							
			ПроводкаНУ.Сумма = СтрокаТаблицы.Сумма;
						
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, "Контрагенты", СтрокаТаблицы.Контрагент, Истина);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, "Договоры",    СтрокаТаблицы.ДоговорКредит);
						
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, "Контрагенты", СтрокаТаблицы.Контрагент, Истина);
			ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, "Договоры",    СтрокаТаблицы.ДоговорДебет);
						
			ПроцедурыБухгалтерскогоУчета.УстановитьПодразделенияПроводки(
				ПроводкаНУ, Реквизиты.СтруктурноеПодразделение, Реквизиты.СтруктурноеПодразделение);
				
			ПроцедурыНалоговогоУчета.ВидУчетаНУ(ПроводкаНУ, Реквизиты.ВидУчетаНУ);	
		КонецЕсли;
				
	КонецЦикла;
	
	Движения.Типовой.Записывать = Истина;
	Если Реквизиты.НеобходимостьОтраженияВНУ Тогда
		Движения.Налоговый.Записывать = Истина;
	КонецЕсли;
	
КонецПроцедуры

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
