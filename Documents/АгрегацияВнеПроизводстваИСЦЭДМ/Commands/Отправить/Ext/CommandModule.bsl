﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
		Если Источник.ИмяФормы = "Документ.АгрегацияВнеПроизводстваИСЦЭДМ.Форма.ФормаДокумента" Тогда
			ИнтеграцияИСМПТККлиент.ОтправитьИсходящиеДокументыИСЦЭДМ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
		Иначе
			ИспользоватьФоновуюОтправкуДокументИСЦЭДМ = ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуДокументовИСЦЭДМ();
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуДокументИСЦЭДМ, Источник.КлючУникальности);
			ИнтеграцияИСМПТККлиент.ОтправитьИсходящиеДокументыИСЦЭДМ(ПараметрКоманды, ДополнительныеПараметры);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
