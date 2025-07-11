﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	ОбязательныеРеквизитыШапки = "Организация";

	СтруктураОбязательныхПолей = Новый Структура(ОбязательныеРеквизитыШапки);

	// Теперь позовем общую процедуру проверки.
	ОбщегоНазначения.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ)
	////Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	////
	////// Проверка ручной корректировки
	////Если ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект) Тогда
	////	Возврат ;
	////КонецЕсли;
	////
	////// Сформируем структуру реквизитов шапки документа
	////СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	////
	////// Проверим правильность заполнения шапки документа
	////ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	////
	////Если СчетДт.Пустая() Тогда
	////	Отказ = истина;
	////	Сообщить("Не выбран СчетДт !!");
	////	Возврат ;
	////
	////КонецЕсли;
	////
	////Если  Отказ Тогда
	////	Возврат;
	////КонецЕсли;
	////
	////
	//////-------основные проводки --------------
	////
	////зпОстСредней = новый Запрос;
	////зпОстСредней.Текст =
	////"ВЫБРАТЬ
	////|	Остатки.Склад КАК Склад,
	////|	Остатки.Счет КАК Счет,
	////|	Остатки.Номенклатура КАК Номенклатура,
	////|	Остатки.КоличествоКон КАК КоличествоКон,
	////|	ТМЗдок.РасходФакт КАК РасходФакт,
	////|	Остатки.СуммаКон,
	////|	ВЫБОР
	////|		КОГДА ЕСТЬNULL(Остатки.КоличествоКон, 0) = 0
	////|			ТОГДА 0
	////|		ИНАЧЕ ЕСТЬNULL(Остатки.СуммаКон, 0) / Остатки.КоличествоКон
	////|	КОНЕЦ КАК срЦена
	////|ИЗ
	////|	(ВЫБРАТЬ
	////|		СВТМЗтбСписание.Номенклатура КАК Номенклатура,
	////|		СВТМЗтбСписание.Счет КАК Счет,
	////|		СУММА(СВТМЗтбСписание.РасходФакт) КАК РасходФакт
	////|	ИЗ
	////|		Документ.СписаниеВспомогательныхТМЗ.тбСписание КАК СВТМЗтбСписание
	////|	ГДЕ
	////|		СВТМЗтбСписание.Ссылка = &Ссылка
	////|	
	////|	СГРУППИРОВАТЬ ПО
	////|		СВТМЗтбСписание.Номенклатура,
	////|		СВТМЗтбСписание.Счет) КАК ТМЗдок
	////|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	////|			ТОИОб.Счет КАК Счет,
	////|			ВЫРАЗИТЬ(ТОИОб.Субконто2 КАК Справочник.Склады) КАК Склад,
	////|			ВЫРАЗИТЬ(ТОИОб.Субконто1 КАК Справочник.Номенклатура) КАК Номенклатура,
	////|			СУММА(ТОИОб.КоличествоКонечныйОстатокДт) КАК КоличествоКон,
	////|			СУММА(ТОИОб.СуммаКонечныйОстатокДт) КАК СуммаКон
	////|		ИЗ
	////|			РегистрБухгалтерии.Типовой.ОстаткиИОбороты(
	////|					&ДатаНач,
	////|					&ДатаКон,
	////|					Период,
	////|					Движения,
	////|					ПОДСТРОКА(Счет.Код, 1, 3) = ""131"",
	////|					,
	////|					Субконто1 В (&списТМЗ)
	////|						И Субконто2 = &ВыбСклад) КАК ТОИОб
	////|		
	////|		СГРУППИРОВАТЬ ПО
	////|			ТОИОб.Счет,
	////|			ВЫРАЗИТЬ(ТОИОб.Субконто1 КАК Справочник.Номенклатура),
	////|			ВЫРАЗИТЬ(ТОИОб.Субконто2 КАК Справочник.Склады)) КАК Остатки
	////|		ПО ТМЗдок.Номенклатура = Остатки.Номенклатура
	////|			И ТМЗдок.Счет = Остатки.Счет"
	////;
	////зпОстСредней.УстановитьПараметр("Ссылка",Ссылка);
	////зпОстСредней.УстановитьПараметр("ВыбСклад",МОЛ);
	////зпОстСредней.УстановитьПараметр("списТМЗ",тбСписание.ВыгрузитьКолонку("Номенклатура"));
	////зпОстСредней.УстановитьПараметр("ДатаНач",Дата);
	////зпОстСредней.УстановитьПараметр("ДатаКон",КонецДня(Дата));
	////
	////
	////
	////массивСубДт = новый Массив;
	////массивСубДт.Добавить(СубконтоДт1);
	////массивСубДт.Добавить(СубконтоДт2);
	////массивСубДт.Добавить(СубконтоДт3);
	////
	////результЗП = зпОстСредней.Выполнить();
	////выборка00 = результЗП.Выбрать();
	////
	////пока выборка00.Следующий() Цикл
	////	Если выборка00.РасходФакт>выборка00.КоличествоКон  Тогда
	////		Сообщить("Недостаточно " +выборка00.Номенклатура.Код +" "+выборка00.Номенклатура+ " на складе !! "+МОЛ);
	////		Отказ = истина;
	////	КонецЕсли;
	////	
	////	
	////	Движение = Движения.Типовой.Добавить();
	////	Движение.Организация = Организация;
	////	Движение.Сумма = выборка00.РасходФакт*выборка00.срЦена;
	////	Движение.Содержание = "списание вспомог. тмз";
	////	
	////	Движение.Период = Дата;
	////	СчетДт = СчетДт;
	////
	////	Движение.СчетДт = СчетДт;
	////	Для каждого видС Из СчетДт.ВидыСубконто Цикл
	////		Движение.СубконтоДт[видС.ВидСубконто] = массивСубДт[видС.НомерСтроки-1];
	////	КонецЦикла;
	////	
	////	Движение.СчетКт = выборка00.Счет;
	////	Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоТиповые.Номенклатура] = выборка00.Номенклатура;
	////	Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоТиповые.Склады] = МОЛ;
	////	Движение.КоличествоКт = выборка00.РасходФакт;
	////	
	////КонецЦикла;
	////
	////Движения.Типовой.Записать();
	
КонецПроцедуры

//Процедура ОформитьПустыеКолонки()
//	
//	Для Каждого Стр Из тбСписание Цикл
//		Если ЗначениеЗаполнено(Стр.Номенклатура) Тогда
//			Стр.Код = Стр.Номенклатура.Код;
//			Стр.ЕдИзм = Стр.Номенклатура.БазоваяЕдиницаИзмерения;
//		КонецЕсли;
//	КонецЦикла;

//КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	
	флДоступЕсть= ВернутьДоступРоли();
	Если Статус = Перечисления.СтатусыСогласования.Согласовано и не флДоступЕсть Тогда
		Сообщить("Документ согласован и закрыт для редактирования.");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ВернутьДоступРоли() Экспорт
	
	флДоступЕсть = Ложь;
	Если РольДоступна("ПолныеПрава") Тогда
		//ИЛИ РольДоступна("ГлавныйБухгалтер") 
		//ИЛИ РольДоступна("бит_ПолныеПрава") Тогда
		флДоступЕсть = Истина;
	КонецЕсли;
	
	Возврат флДоступЕсть;

КонецФункции 

#КонецЕсли
