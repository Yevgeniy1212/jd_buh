﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СтандартныеПодсистемы

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	РаботаСДокументамиИСМПТКПереопределяемый.ПриЗаполненииОграниченияДоступа(Ограничение, "СкладыИСЦЭДМ");

КонецПроцедуры

Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

	
КонецПроцедуры

#КонецОбласти

#КонецЕсли