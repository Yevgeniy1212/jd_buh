﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
		ИнтеграцияИСМПТККлиент.ОбновитьДокументыИзИСЦЭДМ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
	КонецЕсли;
	
КонецПроцедуры
