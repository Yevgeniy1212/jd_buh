﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Имя файла выгрузки данных.
// 
// Возвращаемое значение: 
//  Строка - имя файла выгрузки данных.
Функция ИмяФайлаВыгрузкиДанных() Экспорт

	Возврат "data_dump.zip"

КонецФункции

Функция ПодсказкаДлительнойОперации() Экспорт
	Возврат НСтр("ru = 'Операция может занять длительное время. Пожалуйста, подождите...'");
КонецФункции

Функция ПредставлениеСостоянияПодготовкиВыгрузкиЗагрузкиОбластиДанных(ЗагрузкаОбластиДанных) Экспорт
	Если ЗагрузкаОбластиДанных Тогда
		ПредставлениеСостояния = НСтр("ru = 'Выполняется подготовка к загрузке данных.'");
	Иначе
		ПредставлениеСостояния = НСтр("ru = 'Выполняется подготовка к выгрузке данных.'");
	КонецЕсли;
	Возврат ПредставлениеСостояния;
КонецФункции

#КонецОбласти