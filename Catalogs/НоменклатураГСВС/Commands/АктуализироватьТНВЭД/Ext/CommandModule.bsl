﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = ЭСФКлиентПереопределяемый.ПолучитьТипФормаКлиентскогоПриложения() Тогда
		
		ОткрытьФорму("Обработка.АктуализацияКодовТНВЭДПоГСВС.Форма.ФормаАктуализацииКодов");
		
	КонецЕсли;	
	
КонецПроцедуры
