﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимОстатков = Истина;
	Период                  = Неопределено;
	Регистратор             = Неопределено;
	
	Если Параметры.Свойство("Дата", Период) И Параметры.Свойство("Регистратор", Регистратор) Тогда
		Если НЕ ЗначениеЗаполнено(Параметры.Регистратор) Тогда		
			Период = Новый Граница(Период, ВидГраницы.Включая);
		Иначе
			Период =  Новый Граница(Новый МоментВремени(Параметры.Дата, Параметры.Регистратор), ВидГраницы.Исключая)			
		КонецЕсли;	
	ИначеЕсли Параметры.Свойство("Дата", Период) Тогда
		Период = Новый Граница(Период, ВидГраницы.Включая);		
	КонецЕсли;
	
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "&УсловиеНаИзмерения", "{(Организация), (Склад), (Номенклатура)}");
		
	Если  Параметры.Свойство("РежимОстатков") Тогда
		РежимОстатков = Параметры.РежимОстатков;
	КонецЕсли;


	Список.Параметры.УстановитьЗначениеПараметра("РежимОстатков", РежимОстатков);
	Список.Параметры.УстановитьЗначениеПараметра("Период", Период);  
	Список.Параметры.УстановитьЗначениеПараметра("ТекстБезИсточникаПроисхождения", НСтр("ru='<Без источника происхождения>'"));

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИнформационнуюНадписьПараметрыВыбора(ЭтаФорма);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИнформационнуюНадписьПараметрыВыбора(Форма)

	ЭлементыОтбора = Форма.Список.Отбор.Элементы;

	ТекстНадписи = "";
	ПолеНоменклатура = Новый ПолеКомпоновкиДанных("Номенклатура"); 

	Для Каждого Элемент Из ЭлементыОтбора Цикл
		Если Не Форма.РежимОстатков И Элемент.ЛевоеЗначение <> ПолеНоменклатура Тогда
			Продолжить;
		КонецЕсли;		
		Если ЗначениеЗаполнено(Элемент.ПравоеЗначение) и Элемент.Использование Тогда			
			ТекстНадписи = ТекстНадписи + Элемент.ПравоеЗначение + "; ";
		КонецЕсли;
	КонецЦикла;

	ТекстНадписи = Лев(ТекстНадписи, СтрДлина(ТекстНадписи) - 2);

	Форма.ИнформационнаяНадписьПараметровВыбора = ТекстНадписи;

КонецПроцедуры


&НаКлиенте
Процедура ПоказыватьТолькоОстаткиПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("РежимОстатков", РежимОстатков);
	ОбновитьИнформационнуюНадписьПараметрыВыбора(ЭтаФорма);
КонецПроцедуры


&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если ВладелецФормы <> Неопределено И ТипЗнч(ВладелецФормы) = ЭСФКлиентПереопределяемый.ПолучитьТипФормаКлиентскогоПриложения() Тогда
		
		Если ТипЗнч(ВладелецФормы.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
			
			ТекущиеДанные = ВладелецФормы.ТекущийЭлемент.ТекущиеДанные;
			
			Если ТекущиеДанные <> Неопределено Тогда
				ТекущиеДанные.ИсточникПроисхождения = Значение;			
			КонецЕсли; 
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

