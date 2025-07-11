﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

//Отображение подключаемой команды ПечатьАВР
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	АВРСерверПереопределяемый.ДобавитьКомандыПечати(КомандыПечати);
	
КонецПроцедуры

// Формирует печатные формы. Печать документа АВР.
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
	
	АВРСерверПереопределяемый.ПечатьАВР(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

// Подготовка табличных печатных документов.	
Функция ПечатьАВР(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ОбработкаОбменЭСФ = ЭСФСерверПовтИсп.ОбработкаОбменЭСФ();
	ТабличныйДокумент = ОбработкаОбменЭСФ.ПечатьАВР(МассивОбъектов, ОбъектыПечати);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецЕсли
