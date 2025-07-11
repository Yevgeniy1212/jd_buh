﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;	
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
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	ПереопределяемыеЗапросы = Новый Массив;
	ДополнительныеПараметрыЗапросов = Новый Структура();
	
	ПараметрыПроведения = си_УчетСпецодеждыУправлениеПроведениемДокументовСервер.ПодготовитьПараметрыПроведения(ДокументСсылка,Отказ,,,,,,ПереопределяемыеЗапросы,ДополнительныеПараметрыЗапросов);
	
	ЭтоБСО = си_УчетСпецодеждыСерверПовтИсп.ПроверкаНаБСО();
	
	Для Каждого СтрокаТЧ Из ПараметрыПроведения.ТаблицаМатериалы Цикл
		СтрокаТЧ.Количество = СтрокаТЧ.Количество * СтрокаТЧ.Коэффициент;
		Если ЭтоБСО Тогда
			СтрокаТЧ.ОбъектСтроительства = Справочники.ОбъектыСтроительства.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
		
	Возврат ПараметрыПроведения;

КонецФункции

#КонецОбласти

#КонецЕсли
