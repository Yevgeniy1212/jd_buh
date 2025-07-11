﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЗначениеЗаполнено(ПараметрКоманды) Тогда
		ДокументОснование = ПараметрКоманды; 
		ФормаДокумента = ПолучитьФорму("Документ.ЭлектронныйДокументВС.Форма.ФормаДокумента");
		
		ЭтоОбычнаяФорма = ЭСФКлиентСервер.ЭтоОбычнаяФорма(ФормаДокумента);
		Объект = ?(ЭтоОбычнаяФорма, ФормаДокумента, ФормаДокумента.Объект);
		
		ЗаполнитьПоДокументуОснования(Объект, ДокументОснование);	
		
		Если Не ЭтоОбычнаяФорма Тогда
			КопироватьДанныеФормы(Объект, ФормаДокумента.Объект);
		КонецЕсли;
		
		ФормаДокумента.УправлениеФормой();
		ФормаДокумента.Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументуОснования(Объект, Основание)Экспорт
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЭлектронныйДокументВС") Тогда
		Документы.ЭлектронныйДокументВС.ЗаполнитьПоДокументуКорректировки(Объект, Основание);
	КонецЕсли;
	
КонецПроцедуры

