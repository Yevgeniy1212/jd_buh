﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Представление = НСтр("ru='Заказ на эмиссию кодов маркировки (СУЗ) №%1 от %2'");
	Представление = ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(Представление, Данные.Номер, Формат(Данные.Дата, "ДЛФ=DT")); 
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#Область СлужебныйПрограммныйИнтерфейс

// Удаляет использованные коды маркировки из пула в случаях:
//   * Все коды маркировки по основанию распечатаны, основание полностью оформлено (по основанию)
//   * Основание не указано или архивировано, коды маркировки распечатаны (по использованным кодам).
//
Процедура ПолучитьИнформациюПоСтатусамЗаказов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаказКодовМаркировкиСУЗИСМПТК КАК ЗаказНаЭмиссиюКодовМаркировкиСУЗ
	|ГДЕ
	|	НЕ ЗаказНаЭмиссиюКодовМаркировкиСУЗ.OrderID = &ПустаяСтрока
	|	И НЕ ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиЗаказовНаЭмиссиюКодовМаркировкиИСМПТК.Выполнен)
	|	И НЕ ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиЗаказовНаЭмиссиюКодовМаркировкиИСМПТК.НеПодтвержденИСМП)";
	
	Запрос.УстановитьПараметр("ПустаяСтрока", "");
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда 
		
		Выгрузка = Результат.Выгрузить();
		МассивДокументов = Выгрузка.ВыгрузитьКолонку("Ссылка");
		
		КоллекцияСгруппированныхДокументовСУЗ = ИнтеграцияИСМПТКВызовСервера.СгруппироватьДокументыСУЗПоСтруктурнымЕдиницам(МассивДокументов);
		
		Для Каждого СгруппированныеСУЗ Из КоллекцияСгруппированныхДокументовСУЗ Цикл
			
			СтруктурнаяЕдиница = СгруппированныеСУЗ.Ключ;
			МассивСУЗ = СгруппированныеСУЗ.Значение;
			
			Результат = ИнтеграцияИСМПТКВызовСервера.ОтправитьЗапросСтатусовЗаказовКМ(МассивСУЗ, СтруктурнаяЕдиница);
			//Так же в случае если имеются отказы со стороны сервера получим их причины
			ИнтеграцияИСМПТКВызовСервера.ОтправитьЗапросПричинОтказаЗаказовКМ(МассивСУЗ, СтруктурнаяЕдиница);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	РаботаСДокументамиИСМПТКПереопределяемый.ПриЗаполненииОграниченияДоступа(Ограничение, ОбщегоНазначенияИСМПТКВызовСервера.ИмяДокументаЗаказКодовМаркировкиСУЗИСМПТК());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли