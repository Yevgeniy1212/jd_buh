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
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Списание 
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Списание";
	КомандаПечати.Представление = НСтр("ru = 'Списание вспомогательных ТМЦ'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.Порядок = 50;

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
	
	// Печать Списание товаров
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Списание") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Списание",
			НСтр("ru = 'Списание вспомогательных ТМЦ'"),
			ПечатьСписания(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.СписаниеВспомогательныхТМЗ.Макет");
	КонецЕсли;                                             

КонецПроцедуры

Функция ПечатьСписания(МассивОбъектов, ОбъектыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	Макет       = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеВспомогательныхТМЗ.Макет");
	
	секц_шапка          = Макет.ПолучитьОбласть("Заголовок");
	ОбластьНоменклатура = Макет.ПолучитьОбласть("Номенклатура");
	ОбластьОбщийИтог    = Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьПодвал       = Макет.ПолучитьОбласть("подвал");
	
	секц_шапка.Параметры.Организация          = МассивОбъектов[0].Организация;
	секц_шапка.Параметры.Дата                 = Формат(МассивОбъектов[0].Дата,"ДФ=dd.MM.yyyy");
	секц_шапка.Параметры.Номер                = МассивОбъектов[0].Номер;
	секц_шапка.Параметры.периодСтр            = "период с " + Формат(НачалоМесяца(МассивОбъектов[0].Дата), "ДФ=dd.MM.yyyy") + " по " + Формат(МассивОбъектов[0].Дата, "ДФ=dd.MM.yyyy");
	секц_шапка.Параметры.СтрокаНастроекОтбора = "МОЛ: " + МассивОбъектов[0].МОЛ;
	секц_шапка.Параметры.видМатериалов        = ?(МассивОбъектов[0].флТолькоНормируемыеМатериалы, " нормируемых ", " вспомогательных ");
	
	ТабДокумент.Вывести(секц_шапка);
	
	Для Каждого Стр Из МассивОбъектов[0].тбСписание Цикл
		номпп = Стр.НомерСтроки;
		ОбластьНоменклатура.Параметры.номпп = номпп;
		ОбластьНоменклатура.Параметры.Заполнить(Стр);
		ОбластьНоменклатура.Параметры.Код   = Стр.Номенклатура.Код;
		ОбластьНоменклатура.Параметры.ЕдИзм = Стр.Номенклатура.БазоваяЕдиницаИзмерения;
		
		ТабДокумент.Вывести(ОбластьНоменклатура);
	КонецЦикла;
	
	тбИтоги = МассивОбъектов[0].тбСписание.Выгрузить();
	тбИтоги.Колонки.Добавить("ит");
	тбИтоги.Свернуть("ит", "КоличествоНач, ПриходФакт, РасходФакт, КоличествоКон, КоличествоСписать, ОстатокПослеСписания");
	Если тбИтоги.Количество() = 0 Тогда
	    стрИтогов = тбИтоги.Добавить();
	Иначе
	    стрИтогов = тбИтоги[0];
	КонецЕсли;
	
	ОбластьОбщийИтог.Параметры.Заполнить(стрИтогов);
	ТабДокумент.Вывести(ОбластьОбщийИтог);

	ТабДокумент.Вывести(ОбластьПодвал);
	
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	ТабДокумент.ТолькоПросмотр      = Истина;
	ТабДокумент.ОтображатьСетку     = Ложь;

	Возврат ТабДокумент;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.
#КонецЕсли