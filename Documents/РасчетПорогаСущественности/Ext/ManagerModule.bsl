﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//Расчет ПС
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РасчетПС";
	КомандаПечати.Представление = НСтр("ru = 'Расчет ПС'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Расчет ПС'");
	КомандаПечати.Порядок = 50;
	
	//Справка о значениях ПС 
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СправкаИтог";
	КомандаПечати.Представление = НСтр("ru = 'Справка о значениях ПС'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Справка о значениях ПС'");
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	КомандаПечати.Порядок = 75;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Печать Расчет ПС
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасчетПС") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"РасчетПС",
			НСтр("ru = 'Расчет ПС'"),
			ПечатьРасчетПС(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.РасчетПорогаСущественности.РасчетПС");                         
	КонецЕсли;         
		
	// Печать Справка о значениях ПС
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СправкаИтог") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СправкаИтог",
			НСтр("ru = 'Справка о значениях ПС'"),
			ПечатьСправкаИтог(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.РасчетПорогаСущественности.СправкаИтог");
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.

Функция ПечатьРасчетПС(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетПорогаСущественности.ДатаСозданияДокумента,
	|	РасчетПорогаСущественности.ПроцентОПСДляОпераций,
	|	РасчетПорогаСущественности.ПроцентОПСДляСверокВГО,
	|	РасчетПорогаСущественности.ПроцентИПСДляОперацийИСверокВГО,
	|	РасчетПорогаСущественности.ВидБазовогоПоказателя КАК ИсходныеДанные,
	|	РасчетПорогаСущественности.СуммаИсходныхДанных,
	|	РасчетПорогаСущественности.СреднемесячныйПоказатель,
	|	РасчетПорогаСущественности.ОПСДляОпераций,
	|	РасчетПорогаСущественности.ОПСДляСверокВГО,
	|	РасчетПорогаСущественности.ИПСДляОпераций,
	|	РасчетПорогаСущественности.ИПСДляСверокВГО,
	|	РасчетПорогаСущественности.ДатаНачалаРасчета,
	|	РасчетПорогаСущественности.ДатаОкончанияРасчета,
	|	РасчетПорогаСущественности.ДополнительнаяСумма,
	|	РасчетПорогаСущественности.ДополнительнаяИнформация
	|ИЗ
	|	Документ.РасчетПорогаСущественности КАК РасчетПорогаСущественности
	|ГДЕ
	|	РасчетПорогаСущественности.Ссылка В(&МассивОбъектов)";
	ВыборкаДвижений = Запрос.Выполнить().Выбрать();
	
 	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РасчетПорогаСущественности.РасчетПС");

	// Получаем области макета для вывода в табличный документ.
	ОбастьМакета   = Макет.ПолучитьОбласть("Шапка");
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Загрузим настройки пользователя.
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасчетПС";

	// Выведем шапку документа.
	ОбастьМакета.Параметры.Валюта    			  = Константы.ВалютаРегламентированногоУчета.Получить();
	Если МассивОбъектов[0].ВидБазовогоПоказателя = Перечисления.ВидБазовогоПоказателя.ВеличинаТекущихАктивов Тогда
		ОбастьМакета.Параметры.ТекстИсходныхДанных    = "Величина всех активов Общества на "+Лев(Строка(МассивОбъектов[0].ДатаОкончанияРасчета),10);
	ИначеЕсли МассивОбъектов[0].ВидБазовогоПоказателя = Перечисления.ВидБазовогоПоказателя.СобственныйКапитал Тогда
		ОбастьМакета.Параметры.ТекстИсходныхДанных    = "Собственный капитал Общества на "+Лев(Строка(МассивОбъектов[0].ДатаОкончанияРасчета),10);
	ИначеЕсли МассивОбъектов[0].ВидБазовогоПоказателя = Перечисления.ВидБазовогоПоказателя.ВыручкаОтРеализации Тогда
		ОбастьМакета.Параметры.ТекстИсходныхДанных    = "Выручка от реализации Общества на "+Лев(Строка(МассивОбъектов[0].ДатаОкончанияРасчета),10);
	КонецЕсли;	
	
	ОбастьМакета.Параметры.ТекстРасчетаСреднемесячногоПоказателя    = "Среднемесячное значение базового показателя на "+Лев(Строка(МассивОбъектов[0].ДатаОкончанияРасчета),10);;

	ОбастьМакета.Параметры.СуммаИсходныхДанных    = МассивОбъектов[0].СуммаИсходныхДанных;
	ОбастьМакета.Параметры.ТекстДопИнформации     = МассивОбъектов[0].ДополнительнаяИнформация;
	ОбастьМакета.Параметры.СуммаДополнительная    = МассивОбъектов[0].ДополнительнаяСумма;
	ОбастьМакета.Параметры.СреднемесячноеЗначение = МассивОбъектов[0].СреднемесячныйПоказатель;
	ОбастьМакета.Параметры.БазовыйПоказатель      = МассивОбъектов[0].СреднемесячныйПоказатель;
	ОбастьМакета.Параметры.ПроцентОПСОпераций     = Строка(МассивОбъектов[0].ПроцентОПСДляОпераций)+" %";
	ОбастьМакета.Параметры.ПроцентОПССвверокВГОО  = Строка(МассивОбъектов[0].ПроцентОПСДляСверокВГО)+" %";
	ОбастьМакета.Параметры.ПроцентИПСиОПС         = Строка(МассивОбъектов[0].ПроцентИПСДляОперацийИСверокВГО)+" %";
	ОбастьМакета.Параметры.ОПСОпераций    		  = МассивОбъектов[0].ОПСДляОпераций;
	ОбастьМакета.Параметры.ОПССверокВГОО    	  = МассивОбъектов[0].ОПСДляСверокВГО;
	ОбастьМакета.Параметры.ИПСОпераций    		  = МассивОбъектов[0].ИПСДляОпераций;
	ОбастьМакета.Параметры.ИПССверокВГОО    	  = МассивОбъектов[0].ИПСДляСверокВГО;
	
	ТабДокумент.Вывести(ОбастьМакета);
	
	Возврат ТабДокумент;
		
КонецФункции // ПечатьБухгалтерскойСправки()

Функция ПечатьСправкаИтог(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетПорогаСущественности.ДатаСозданияДокумента,
	|	РасчетПорогаСущественности.ПроцентОПСДляОпераций,
	|	РасчетПорогаСущественности.ПроцентОПСДляСверокВГО,
	|	РасчетПорогаСущественности.ПроцентИПСДляОперацийИСверокВГО,
	|	РасчетПорогаСущественности.ВидБазовогоПоказателя КАК ИсходныеДанные,
	|	РасчетПорогаСущественности.СуммаИсходныхДанных,
	|	РасчетПорогаСущественности.СреднемесячныйПоказатель,
	|	РасчетПорогаСущественности.ОПСДляОпераций,
	|	РасчетПорогаСущественности.ОПСДляСверокВГО,
	|	РасчетПорогаСущественности.ИПСДляОпераций,
	|	РасчетПорогаСущественности.ИПСДляСверокВГО,
	|	РасчетПорогаСущественности.ДатаНачалаРасчета,
	|	РасчетПорогаСущественности.ДатаОкончанияРасчета,
	|	РасчетПорогаСущественности.ДополнительнаяСумма,
	|	РасчетПорогаСущественности.ДополнительнаяИнформация
	|ИЗ
	|	Документ.РасчетПорогаСущественности КАК РасчетПорогаСущественности
	|ГДЕ
	|	РасчетПорогаСущественности.Ссылка В(&МассивОбъектов)";
	ВыборкаДвижений = Запрос.Выполнить().Выбрать();
	ВыборкаДвижений.Следующий();

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РасчетПорогаСущественности.СправкаИтог");

	// Получаем области макета для вывода в табличный документ.
	ОбастьМакета   = Макет.ПолучитьОбласть("Область");
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Загрузим настройки пользователя.
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СправкаИтог";

	// Выведем шапку документа.
	//ОбастьМакета.Параметры.Валюта    			  = Константы.ВалютаРегламентированногоУчета.Получить();
	Если МассивОбъектов[0].ВидБазовогоПоказателя = Перечисления.ВидБазовогоПоказателя.ВеличинаТекущихАктивов Тогда
		ОбастьМакета.Параметры.БазовыйПоказатель    = "Величина всех активов Общества";
	ИначеЕсли МассивОбъектов[0].ВидБазовогоПоказателя = Перечисления.ВидБазовогоПоказателя.СобственныйКапитал Тогда
		ОбастьМакета.Параметры.БазовыйПоказатель    = "Собственный капитал Общества";
	КонецЕсли;	
	
	ОбастьМакета.Параметры.Организация = МассивОбъектов[0].Организация.НаименованиеПолное;
	ОбастьМакета.Параметры.Период = ПредставлениеПериода(МассивОбъектов[0].ДатаНачалаРасчета, МассивОбъектов[0].ДатаОкончанияРасчета, "ФП = истина");
	
	Если МассивОбъектов[0].ВидОперации = Перечисления.ВидыОперацийРасчетПорогаСущественности.РасчетКонтрольногоПорогаСущественности Тогда
		ЗапросПС = Новый Запрос("ВЫБРАТЬ
		                        |	РасчетПорогаСущественности.ПроцентОПСДляОпераций,
		                        |	РасчетПорогаСущественности.ПроцентОПСДляСверокВГО,
		                        |	РасчетПорогаСущественности.ПроцентИПСДляОперацийИСверокВГО,
		                        |	РасчетПорогаСущественности.СуммаИсходныхДанных,
		                        |	РасчетПорогаСущественности.СреднемесячныйПоказатель,
		                        |	РасчетПорогаСущественности.ОПСДляОпераций,
		                        |	РасчетПорогаСущественности.ОПСДляСверокВГО,
		                        |	РасчетПорогаСущественности.ИПСДляОпераций,
		                        |	РасчетПорогаСущественности.ИПСДляСверокВГО,
		                        |	РасчетПорогаСущественности.ДополнительнаяСумма
		                        |ИЗ
		                        |	Документ.РасчетПорогаСущественности КАК РасчетПорогаСущественности
		                        |ГДЕ
		                        |	РасчетПорогаСущественности.ДатаНачалаРасчета = &ДатаНачалаРасчета
		                        |	И РасчетПорогаСущественности.ДатаОкончанияРасчета = &ДатаОкончанияРасчета
		                        |	И РасчетПорогаСущественности.ВидБазовогоПоказателя = &ВидБазовогоПоказателя
		                        |	И РасчетПорогаСущественности.ВидОперации = &ВидОперации");
		ЗапросПС.УстановитьПараметр("ДатаНачалаРасчета"    , МассивОбъектов[0].ДатаНачалаРасчета);
		ЗапросПС.УстановитьПараметр("ДатаОкончанияРасчета" , МассивОбъектов[0].ДатаОкончанияРасчета);
        ЗапросПС.УстановитьПараметр("ВидБазовогоПоказателя", МассивОбъектов[0].ВидБазовогоПоказателя);
        ЗапросПС.УстановитьПараметр("ВидОперации"          , Перечисления.ВидыОперацийРасчетПорогаСущественности.РасчетПорогаСущественности);
        ВыборкаПС = ЗапросПС.Выполнить().Выбрать();
		
		Если ВыборкаПС.Количество() > 0 Тогда
			ВыборкаПС.Следующий();
			ОбастьМакета.Параметры.БазПоказатель   = ВыборкаПС.СуммаИсходныхДанных;
			ОбастьМакета.Параметры.ПроцентОПСДляОпераций = ВыборкаПС.ПроцентОПСДляОпераций;
			ОбастьМакета.Параметры.ОПСДляОпераций  = ВыборкаПС.ОПСДляОпераций;
			ОбастьМакета.Параметры.ПроцентОПСДляСверокВГО = ВыборкаПС.ПроцентОПСДляСверокВГО;
			ОбастьМакета.Параметры.ОПСДляСверокВГО = ВыборкаПС.ОПСДляСверокВГО;
			ОбастьМакета.Параметры.ПроцентИПСДляОперацийИСверокВГО = ВыборкаПС.ПроцентИПСДляОперацийИСверокВГО;
			ОбастьМакета.Параметры.ИПСДляОпераций  = ВыборкаПС.ИПСДляОпераций;
			ОбастьМакета.Параметры.ИПСДляСверокВГО = ВыборкаПС.ИПСДляСверокВГО;			
		Иначе
			Сообщить ("Не осуществлен расчет общего порога существенности за период: " + ПредставлениеПериода(МассивОбъектов[0].ДатаНачалаРасчета, МассивОбъектов[0].ДатаОкончанияРасчета, "ФП = истина"));
		КонецЕсли;
		// КПС
		ОбастьМакета.Параметры.БазовыйОперации_КПС = ВыборкаДвижений.СуммаИсходныхДанных;
		ОбастьМакета.Параметры.ОПС_операции_КПС    = ВыборкаДвижений.ОПСДляОпераций;
		ОбастьМакета.Параметры.ИПС_операции_КПС    = ВыборкаДвижений.ИПСДляОпераций;
		ОбастьМакета.Параметры.ОПС_ВГО_КПС         = ВыборкаДвижений.ОПСДляСверокВГО;
		ОбастьМакета.Параметры.ИПС_ВГО_КПС         = ВыборкаДвижений.ИПСДляСверокВГО;
	Иначе
		ОбастьМакета.Параметры.БазПоказатель       = ВыборкаДвижений.СуммаИсходныхДанных;
		ОбастьМакета.Параметры.ПроцентОПСДляОпераций = ВыборкаДвижений.ПроцентОПСДляОпераций;
		ОбастьМакета.Параметры.ОПСДляОпераций      = ВыборкаДвижений.ОПСДляОпераций;
		ОбастьМакета.Параметры.ПроцентОПСДляСверокВГО = ВыборкаДвижений.ПроцентОПСДляСверокВГО;
		ОбастьМакета.Параметры.ОПСДляСверокВГО     = ВыборкаДвижений.ОПСДляСверокВГО;
		ОбастьМакета.Параметры.ПроцентИПСДляОперацийИСверокВГО = ВыборкаДвижений.ПроцентИПСДляОперацийИСверокВГО;
		ОбастьМакета.Параметры.ИПСДляОпераций      = ВыборкаДвижений.ИПСДляОпераций;
		ОбастьМакета.Параметры.ИПСДляСверокВГО     = ВыборкаДвижений.ИПСДляСверокВГО;			
	КонецЕсли;
		
	ТабДокумент.Вывести(ОбастьМакета);
	
	Возврат ТабДокумент;
		
КонецФункции // ПечатьБухгалтерскойСправки()

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли
