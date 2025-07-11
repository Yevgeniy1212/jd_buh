﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	УправлениеФормой(ЭтаФорма);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетБУ");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетБУ");
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетБУ,,, Объект.СчетНУ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СпособСписанияПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетБУПриИзменении(Элемент)
		
	Объект.СчетНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", Объект.СчетБУ));
	
	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоБУ1", "СубконтоБУ2", "СубконтоБУ3");

	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(Объект.СчетБУ, Объект, ПоляФормы);
	
	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоНУ1", "СубконтоНУ2", "СубконтоНУ3");

	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(Объект.СчетНУ, Объект, ПоляФормы);

	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетБУ,,, Объект.СчетНУ);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетНУ");

КонецПроцедуры

&НаКлиенте
Процедура СчетНУПриИзменении(Элемент)
	
	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоНУ1", "СубконтоНУ2", "СубконтоНУ3");

	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(Объект.СчетНУ, Объект, ПоляФормы);

	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетБУ,,, Объект.СчетНУ);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоБУ1ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетБУ, Объект.СчетНУ, 1, Объект.СубконтоБУ1, "СубконтоНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетНУ", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоБУ2ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетБУ, Объект.СчетНУ, 2, Объект.СубконтоБУ2, "СубконтоНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетНУ", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоБУ3ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетБУ, Объект.СчетНУ, 3, Объект.СубконтоБУ3, "СубконтоНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетНУ", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоБУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоБУ", 1, "СчетБУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоБУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоБУ", 2, "СчетБУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоБУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоБУ", 3, "СчетБУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ1ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ2ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ3ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоНУ", 1, "СчетНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоНУ", 2, "СчетНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоНУ", 3, "СчетНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	НеобходимостьУказанияСуммыРБП = (Объект.СпособСписания = ПредопределенноеЗначение("Перечисление.СпособыСписанияРБП.Равномерно"));

	Элементы.Сумма.ОтметкаНезаполненного   = НеобходимостьУказанияСуммыРБП;
	Элементы.Сумма.АвтоВыборНезаполненного = НеобходимостьУказанияСуммыРБП;	

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, СчетУчета, Префикс = "", Постфикс = "", СчетУчетаНУ = Неопределено, ЭтоТаблица = Ложь)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		Префикс + "СубконтоБУ1" + Постфикс,
		Префикс + "СубконтоБУ2" + Постфикс,
		Префикс + "СубконтоБУ3" + Постфикс);
	
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоБУ1", "ЗаголовокСубконтоБУ2", "ЗаголовокСубконтоБУ3");
	
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчета, Форма, ПоляФормы, ЗаголовкиПолей);
	
	Если НЕ СчетУчетаНУ = Неопределено Тогда
		
		Для Каждого ПолеФормы Из ПоляФормы Цикл
			
			ПоляФормы.Вставить(ПолеФормы.Ключ, СтрЗаменить(ПолеФормы.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		Для Каждого ЗаголовоеПоля Из ЗаголовкиПолей Цикл
			
			ЗаголовкиПолей.Вставить(ЗаголовоеПоля.Ключ, СтрЗаменить(ЗаголовоеПоля.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчетаНУ, Форма, ПоляФормы, ЗаголовкиПолей);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(ДанныеОбъекта, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	
	СписокПараметров.Вставить("СчетУчета", ПараметрыОбъекта[ИмяСчета]);	

	Возврат СписокПараметров; 

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Суффикс, ИмяСчета, ЗаменаСубконтоНУ = Ложь)
	
	ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма.Объект, Форма.Объект, "Субконто" + Суффикс + "%Индекс%", ИмяСчета);
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект, "Субконто" + Суффикс + "%Индекс%", "Субконто" + Суффикс + "%Индекс%", ПараметрыДокумента, ЗаменаСубконтоНУ);	
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНачалоВыбора(Элемент, ИмяЭлементаСубконто, ИндексСубконто, ИмяЭлементаСчета, СтрокаТаблицы, СтандартнаяОбработка)	
	
	ПараметрыДокумента = СписокПараметровВыбораСубконто(Объект, СтрокаТаблицы, ИмяЭлементаСубконто + "%Индекс%", ИмяЭлементаСчета);
	ПроцедурыБухгалтерскогоУчетаКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, ИндексСубконто, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

