﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
			
		Если Источник.ИмяФормы = "Документ.АгрегацияКодовМаркировкиСУЗИСМПТК.Форма.ФормаДокумента" Тогда
			
			ИнтеграцияИСМПТККлиент.ОтправитьИсходящиеДокументыСУЗ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
			
		Иначе
			
			ИспользоватьФоновуюОтправкуДокументИСМПТ = ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуДокументовИСМПТ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуДокументИСМПТ, Источник.КлючУникальности);
			
			ИнтеграцияИСМПТККлиент.ОтправитьИсходящиеДокументыСУЗ(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры