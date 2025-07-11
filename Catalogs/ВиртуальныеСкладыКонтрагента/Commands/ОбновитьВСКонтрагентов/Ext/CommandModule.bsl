﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = ЭСФКлиентПереопределяемый.ПолучитьТипФормаКлиентскогоПриложения() Тогда
		
		Если Источник.ИмяФормы = "Справочник.ВиртуальныеСкладыКонтрагента.Форма.ФормаЭлемента" Тогда
			
			СНТКлиент.ОбновитьВиртуальныеСкладыКонтрагентовИзВС(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
			
		Иначе
			
			ИспользоватьФоновуюОтправкуЭСФ = СНТКлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуСНТ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуЭСФ, Источник.КлючУникальности);
			
			СНТКлиент.ОбновитьВиртуальныеСкладыКонтрагентовИзВС(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры
