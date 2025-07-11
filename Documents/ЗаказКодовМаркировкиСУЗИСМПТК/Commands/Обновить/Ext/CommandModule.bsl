﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
			
		Если Источник.ИмяФормы = "Документ.ЗаказКодовМаркировкиСУЗИСМПТК.Форма.ФормаДокумента" Тогда
			
			ИнтеграцияИСМПТККлиент.ПолучитьСтатусЗаказаЭмиссииКМ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
			
		Иначе
			
			ИспользоватьФоновуюОтправкуДокументИСМПТ_СУЗ = ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуДокументовИСМПТ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуДокументИСМПТ_СУЗ, Источник.КлючУникальности);
			
			ИнтеграцияИСМПТККлиент.ПолучитьСтатусЗаказаЭмиссииКМ(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
