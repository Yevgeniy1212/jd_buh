﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//отклонение Уведомления
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
		Если Источник.ИмяФормы = "Документ.УведомлениеОРасхожденииИСМПТК.Форма.ФормаДокумента" Тогда
			ИнтеграцияИСМПТККлиент.ОтклонитьВходящиеДокументыИСМПТ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
		Иначе
			ИспользоватьФоновуюОтправкуДокументИСМПТ = ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуДокументовИСМПТ();
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуДокументИСМПТ, Источник.КлючУникальности);
			ИнтеграцияИСМПТККлиент.ОтклонитьВходящиеДокументыИСМПТ(ПараметрКоманды, ДополнительныеПараметры);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
