﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗапускатьФоновоеЗадание", ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуДокументовИСМПТ());
	ПараметрыФормы.Вставить("РежимЗапуска", "СинхронизацияСИСМПТ");
	
	ОрганизацияОтбор = ПараметрыВыполненияКоманды.Источник.ЭтотОбъект.Организация;
	Если ЗначениеЗаполнено(ОрганизацияОтбор) Тогда
		ПараметрыФормы.Вставить("ОрганизацияОтбор", ОрганизацияОтбор);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.РабочиеМестаИСМПТК.Форма.РабочееМестоСинхронизацияСИСМПТ", ПараметрыФормы, , "ФормаСинхронизацииИСМПТ");

КонецПроцедуры
