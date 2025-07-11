﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АВРСерверПереопределяемый.АВРФормаСпискаИВыбораПриСозданииНаСервере(ЭтаФорма);

	УстановитьУсловноеОформление();
	
	ПараметрыЗапроса = ПараметрыЗапросаСписокДокументовКОформлению();
	Для Каждого ТекПараметр Из ПараметрыЗапроса Цикл
		СписокДокументовКОформлению.Параметры.УстановитьЗначениеПараметра(ТекПараметр.Ключ, ТекПараметр.Значение);
	КонецЦикла;
	
	ЗаполнитьСписокДокументовКОформлению();
	СформироватьСписокВыбораТипаОснования();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = АВРКлиентСервер.ИмяСобытияЗаписьАВР() Тогда
		Элементы.СписокДокументовКОформлению.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьЭАВР(Команда)
	
	ТекущаяСтрока = Элементы.СписокДокументовКОформлению.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Укажите документ-основания для формирования электронных актов выполненных работ.'"));
		Возврат;
	КонецЕсли;
	
	Список = Элементы.СписокДокументовКОформлению;
	
	МассивОснований = Новый Массив;
	
	Если Список.ВыделенныеСтроки.Количество() = 1 Тогда
		
		МассивОснований.Добавить(ТекущаяСтрока.Ссылка);
		
	Иначе
		
		Для Каждого ТекСтрока Из Список.ВыделенныеСтроки Цикл
			МассивОснований.Добавить(Список.ДанныеСтроки(ТекСтрока).Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
	АВРКлиент.ВыполнитьКомандуСоздатьЭАВР(МассивОснований);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаИсходящиеЭлектронныеАВРОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	АВРКлиент.ОткрытьФормуСпискаИсходящихАВР();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	АВРКлиентСерверПереопределяемый.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументовКОформлению,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно, ,
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	АВРКлиентСерверПереопределяемый.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументовКОформлению,
		"Контрагент",
		Контрагент,
		ВидСравненияКомпоновкиДанных.Равно, ,
		ЗначениеЗаполнено(Контрагент));
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОснованияПриИзменении(Элемент)
	
	Если не ЗначениеЗаполнено(ВидОснования) Тогда
		ЭлементОтобра = Неопределено;
	Иначе
		Попытка
			ЭлементОтобра = Тип("ДокументСсылка."+ВидОснования)
		Исключение
			ЭлементОтобра = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	АВРКлиентСерверПереопределяемый.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументовКОформлению,
		"ВидОснования",
		ЭлементОтобра,
		ВидСравненияКомпоновкиДанных.Равно, ,
		ЗначениеЗаполнено(ВидОснования));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанные = Элемент.ТекущиеДанные;
	
	ПоказатьЗначение(, ТекДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументовКОформлению()
	
	УстановитьТекстЗапросаСписокДокументовКОформлению();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЗапросаСписокДокументовКОформлению()
	
	ТекстЗапроса = АВРСерверПереопределяемый.ТекстЗапросаДокументовКОформлениюЭАВР();
	СписокДокументовКОформлению.ТекстЗапроса = ТекстЗапроса;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыЗапросаСписокДокументовКОформлению()
	
	Параметры = Новый Структура;
	Параметры.Вставить("НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()));
	
	Возврат Параметры;
	
КонецФункции

&НаСервере
Процедура СформироватьСписокВыбораТипаОснования()
	
	Элементы.ВидОснования.СписокВыбора.Очистить();
	
	СписокИсключений = АВРСерверПереопределяемый.ПолучитьИсключаемыеТипыОснованийЭАВР();
	
	Для каждого Элемент Из Метаданные.ОпределяемыеТипы.ПервичныеДокументыАВР.Тип.Типы() Цикл
		Если СписокИсключений.НайтиПоЗначению(Элемент)<> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ДокументСсылка = Новый(Элемент);
		Имя = ДокументСсылка.Метаданные().Имя;
		Синоним = ДокументСсылка.Метаданные().Синоним;
		Элементы.ВидОснования.СписокВыбора.Добавить(Имя,Синоним);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыписатьИсправленныйАВР(Команда)
	
	ТекущаяСтрока = Элементы.СписокДокументовКОформлению.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Укажите документ-основания для формирования электронных актов выполненных работ.'"));
		Возврат;
	КонецЕсли;
	
	Список = Элементы.СписокДокументовКОформлению;
	
	МассивОснований = Новый Массив;
	
	Если Список.ВыделенныеСтроки.Количество() = 1 Тогда
		
		МассивОснований.Добавить(ТекущаяСтрока.Ссылка);
		
	Иначе
		
		Для Каждого ТекСтрока Из Список.ВыделенныеСтроки Цикл
			МассивОснований.Добавить(Список.ДанныеСтроки(ТекСтрока).Ссылка);
		КонецЦикла;
		
	КонецЕсли;
			
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ДокументОснование", МассивОснований);
	ДанныеЗаполнения.Вставить("ЭтоИсправленныйЭАВР", Истина);
	
	АВРКлиент.ВыполнитьКомандуСоздатьЭАВР(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти