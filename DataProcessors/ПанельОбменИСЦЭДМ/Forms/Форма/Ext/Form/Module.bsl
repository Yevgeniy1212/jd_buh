﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВосстановитьНастройкиФормы();
		
	УправлениеФормой();
	СобытияФормИСМПТКПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КонстантыМаркировки_Изменение" Тогда
		УправлениеФормой();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ДокументыИСЦЭДМ_ИСМПТСУЗ

#Область Производство

#Область ЗаказНаЭмиссиюКодовМаркировкиСУЗ

&НаКлиенте
Процедура ОткрытьЗаказНаЭмиссиюКодовМаркировкиСУЗ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.ЗаказКодовМаркировкиСУЗИСМПТК.Форма.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область НанесениеКодовМаркировкиСУЗ

&НаКлиенте
Процедура ОткрытьНанесениеКодовМаркировкиСУЗ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.НанесениеКодовМаркировкиСУЗИСМПТК.Форма.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область АгрегацияКодовМаркировкиСУЗ

&НаКлиенте
Процедура ОткрытьАгрегацияКодовМаркировкиСУЗ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.АгрегацияКодовМаркировкиСУЗИСМПТК.Форма.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область АгрегацияИСЦЭДМ

&НаКлиенте
Процедура ОткрытьАгрегацияВнеПроизводстваЦЭДМ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.АгрегацияВнеПроизводстваИСЦЭДМ.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Запасы

#Область АктПриемаПередачиИСЦЭДМ

&НаКлиенте
Процедура ОткрытьАктПриемаПередачиКодовМаркировкиИСМПВходящие(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.АктПриемаПередачиИСЦЭДМ.Форма.ФормаСпискаВходящих", ПараметрыФормыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктПриемаПередачиКодовМаркировкиИСМПИсходящие(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.АктПриемаПередачиИСЦЭДМ.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
		
КонецПроцедуры

#КонецОбласти

#Область АктВнутреннегоПеремещенияИСЦЭДМ

&НаКлиенте
Процедура ОткрытьАктВнутреннегоПеремещенияИсходящие(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.АктВнутреннегоПеремещенияИСЦЭДМ.ФормаСписка", ПараметрыФормыВыбора);
		
КонецПроцедуры

#КонецОбласти

#Область УведомлениеОВыводеИзОборотаИСЦЭДМ

&НаКлиенте
Процедура ОткрытьУведомлениеОВыводеИзОборотаИСМПТ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОВыводеИзОборотаИСЦЭДМ.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
	                                       
КонецПроцедуры                             

#КонецОбласти

#Область УведомлениеОВводеВОборотИСЦЭДМ

&НаКлиенте
Процедура ОткрытьУведомлениеОВводеВОборотИСМПТ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОВводеВОборотИСЦЭДМ.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
	                                       
КонецПроцедуры                             

#КонецОбласти

#Область ОтчетОПередачеКИОтНерезидентаРКИСЦЭДМ

&НаКлиенте
Процедура ОткрытьОтчетыОПередачеКИИмпортеруВходящие(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.ОтчетОПередачеКИОтНерезидентаРКИСЦЭДМ.Форма.ФормаСпискаВходящих", ПараметрыФормыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетыОПередачеКИИмпортеруИсходящие(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.ОтчетОПередачеКИОтНерезидентаРКИСЦЭДМ.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
		
КонецПроцедуры

#КонецОбласти

#Область УведомлениеОРасхожденияхИСЦЭДМ

&НаКлиенте
Процедура ОткрытьУведомлениеОРасхожденияхИСЦЭДМВходящие(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОРасхожденияхИСЦЭДМ.Форма.ФормаСпискаВходящих", ПараметрыФормыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУведомлениеОРасхожденияхИСЦЭДМИсходящие(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОРасхожденияхИСЦЭДМ.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
		
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОткрытьУведомлениеОВвозеЕАЭС(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОВвозеИзЕАЭСИСЦЭДМ.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
	                                       
КонецПроцедуры 

&НаКлиенте
Процедура ОткрытьУведомлениеОВвозеИмпорт(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОВвозеИзТретьихСтранИСЦЭДМ.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
	                                       
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

#Область ОбъектыСУЗ

&НаКлиенте
Процедура ОткрытьСтанцииУправленияЗаказами(Команда)
	
	ОткрытьФорму("Справочник.СтанцииУправленияЗаказамиИСМПТК.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПулКодовМаркировкиСУЗ(Команда)
	
	ОткрытьФорму("РегистрСведений.ПулКодовМаркировкиСУЗИСМПТК.Форма.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗависшиеЗаказыКМ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	Отбор = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	
	СписокЗависшихЗаказовСУЗ = РаботаСДокументамиИСМПТКВызовСервера.ПолучитьСписокЗависшихЗаказовСУЗ(Организация);
	Отбор.Вставить("Ссылка", СписокЗависшихЗаказовСУЗ);
	
	ПараметрыФормыВыбора.Вставить("Отбор", 	   Отбор);
	ПараметрыФормыВыбора.Вставить("Заголовок", НСтр("ru = 'Незавершенные ""Заказы на эмиссию кодов маркировки (СУЗ)""'"));
	ПараметрыФормыВыбора.Вставить("ЭтоСписокИсправления", Истина);
	
	ОткрытьФорму("Документ.ЗаказКодовМаркировкиСУЗИСМПТК.ФормаСписка", ПараметрыФормыВыбора);
		
КонецПроцедуры

#КонецОбласти

#Область ПрикладныеОбъекты

&НаКлиенте
Процедура ОткрытьВидыНоменклатуры(Команда)
	
	ИнтеграцияИСМПТККлиентПереопределяемый.ОткрытьФормуСпискаВидыНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНоменклатуру(Команда)

	ИнтеграцияИСМПТККлиентПереопределяемый.ОткрытьФормуСпискаНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СправочникиИСМП

&НаКлиенте
Процедура ОткрытьШаблоныЭтикеток(Команда)
	
	ОткрытьФорму("Справочник.ХранилищеШаблоновИСМПТК.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСкладыИСЦЭДМ(Команда)
	
	ОткрытьФорму("Справочник.СкладыИСЦЭДМ.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура КодыГрупповыхУпаковокSSCC(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	Отбор = Новый Структура();
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
		ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.ШтрихкодыSSCCИСМПТК.ФормаСписка", ПараметрыФормыВыбора);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область ОтборПоОрганизации

&НаКлиенте
Процедура ОтборОрганизацииПриИзменении(Элемент)
	
	РаботаСДокументамиИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСДокументамиИСМПТККлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", , ОповещениеВыбораОрганизаций());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСДокументамиИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСДокументамиИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	РаботаСДокументамиИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСДокументамиИСМПТККлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", , ОповещениеВыбораОрганизаций());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСДокументамиИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСДокументамиИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДействияСНастройкамиФормы

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	ОбщегоНазначенияИСМПТКПереопределяемый.ХранилищеОбщихНастроекСохранить("ПанельОбменИСЦЭДМ", "Организация",              Организация);
	ОбщегоНазначенияИСМПТКПереопределяемый.ХранилищеОбщихНастроекСохранить("ПанельОбменИСЦЭДМ", "ОрганизацииПредставление", ОрганизацииПредставление);
	ОбщегоНазначенияИСМПТКПереопределяемый.ХранилищеОбщихНастроекСохранить("ПанельОбменИСЦЭДМ", "Организации",              Организации);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиФормы()
	
	Организации              = ОбщегоНазначенияИСМПТКПереопределяемый.ХранилищеОбщихНастроекЗагрузить("ПанельОбменИСЦЭДМ", "Организации");
	Организация              = ОбщегоНазначенияИСМПТКПереопределяемый.ХранилищеОбщихНастроекЗагрузить("ПанельОбменИСЦЭДМ", "Организация", 				Организация);
	ОрганизацииПредставление = ОбщегоНазначенияИСМПТКПереопределяемый.ХранилищеОбщихНастроекЗагрузить("ПанельОбменИСЦЭДМ", "ОрганизацииПредставление", ОрганизацииПредставление);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеЭлементовФормы

&НаСервере
Процедура ОбновитьСпискиДокументов()
	
	УправлениеФормой();
	СохранитьНастройкиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОтборПоОрганизации

&НаКлиенте
Функция ОповещениеВыбораОрганизаций()
	
	Возврат Новый ОписаниеОповещения("ПослеВыбораОрганизации", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПослеВыбораОрганизации(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УправлениеФормой()
	
	////////ОБЩИЕ СВЕДЕНИЯ////////
	//КОНСТАНТЫ УЧЕТА
	ВедетсяУчетМарокПоОбуви 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойОбувиИСМПТК");
	ВедетсяУчетМарокПоТабаку 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоТабакаИСМПТК");
	ВедетсяУчетМарокПоМолочке 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойМолочкиИСМПТК");
	ВедетсяУчетМарокПоАлкоголю 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоАлкоголяИСМПТК");
	ВедетсяУчетМарокПоЛекарствам = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемыхЛекарствИСМПТК");
	ВедетсяУчетМарокПоТекстилю 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоТекстиляИСМПТК");
	ВедетсяУчетМарокОбщая	 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМПТК");
	ВедетсяУчетПоСкладам 		 = ПолучитьФункциональнуюОпцию("ВестиУчетПоСкладамИСЦЭДМ");
	//////////////////////////////
	
	//===========================
	
	///////ПЕРЕОПРЕДЕЛЯЕМЫЕ///////
	//Получение параметров настроек модуля с учетом особенностей конфигурации.
	МассивПереопределяемыхНастроек = СобытияФормИСМПТКПереопределяемый.ПолучитьСписокПереопределяемыхНастроекФормыОсновноеРабочееМестоИСМПТ();
	Для Каждого СтруктураПараметров Из МассивПереопределяемыхНастроек Цикл
		
		ИмяЭлемента = СтруктураПараметров.ИмяЭлементаФормы;
		Свойство	= СтруктураПараметров.Свойство;
		ЗначениеСвойства = СтруктураПараметров.Значение;
		
		ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ИмяЭлемента, Свойство, ЗначениеСвойства);
		
	КонецЦикла;
	//////////////////////////////
	
	//===========================
	
	//////МАРКИРОВКА ТОВАРОВ/////
	//ГРУППА ТОВАРОДВИЖЕНИЕ
	//Акты внутреннего перемещения
	ВидимостьГруппаАВП = ПравоДоступа("Просмотр", Метаданные.Документы.АктВнутреннегоПеремещенияИСЦЭДМ) И ВедетсяУчетПоСкладам;
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаАктВнутреннегоПеремещенияИСЭДО", "Видимость", ВидимостьГруппаАВП);
	
	//Акты приема/передачи
	ВидимостьГруппаАПП = ПравоДоступа("Просмотр", Метаданные.Документы.АктПриемаПередачиИСЦЭДМ);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаАктПриемаПередачиМаркировкиИСЭДО", "Видимость", ВидимостьГруппаАПП);
	
	//ГРУППА ИМПОРТ
	//Уведомления о ввозе ЕАЭС
	ВидимостьГруппаВвозЕАЭС = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОВвозеИзЕАЭСИСЦЭДМ);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаВвозТоваровЕАЭС", "Видимость", ВидимостьГруппаВвозЕАЭС);
	
	//Уведомления о ввозе Импорт
	ВидимостьГруппаВвозИмпорт = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОВвозеИзТретьихСтранИСЦЭДМ);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаВвозТоваровИмпорт", "Видимость", ВидимостьГруппаВвозИмпорт);
	
	//Отчет о передаче КИ импортеру
	ВидимостьГруппаОтчетОПередаче = ПравоДоступа("Просмотр", Метаданные.Документы.ОтчетОПередачеКИОтНерезидентаРКИСЦЭДМ);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОтчетыОПередачеКИИмпортеру", "Видимость", ВидимостьГруппаОтчетОПередаче);
	
	//ГРУППА ИНВЕНТАРИЗАЦИЯ
	//Уведомления о вводе в оборот
	ВидимостьВводВОборот = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОВводеВОборотИСЦЭДМ);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаВозвратВОборотКодовМаркировкиИСЭДО", "Видимость", ВидимостьВводВОборот);
	
	//Уведомления о вывводе из оборота
	ВидимостьВыводИЗОборота = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОВыводеИзОборотаИСЦЭДМ);							  
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСписаниеКодовМаркировкиИСЭДО", "Видимость", ВидимостьВыводИЗОборота);
	///////////////////////////////
	
	//Уведомления о расхождениях
	ВидимостьГруппаУОР = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОРасхожденияхИСЦЭДМ);							  
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаУведомленияОРасхождениях", "Видимость", ВидимостьГруппаУОР);
		
	//===========================
	
	//СТАНЦИЯ УПРАВЛЕНИЯ ЗАКАЗАМИ//
	//1. ГРУППА ПРОИЗВОДСТВО
	//Заказы на эмиссию кодов маркировки
	ВидимостьЗаказКМ = ПравоДоступа("Просмотр", Метаданные.Документы.ЗаказКодовМаркировкиСУЗИСМПТК);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаЗаказНаЭмиссиюКодовМаркировкиСУЗ", "Видимость", ВидимостьЗаказКМ);
		
	//Отчеты о нанесениеи кодов маркировки
	ВидимостьНанесениеКМ = ПравоДоступа("Просмотр", Метаданные.Документы.НанесениеКодовМаркировкиСУЗИСМПТК);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаНанесениеКодовМаркировкиСУЗ", "Видимость", ВидимостьНанесениеКМ);
	
	//Агрегации КМ
	ВидимостьАгрегацияКМ = ПравоДоступа("Просмотр", Метаданные.Документы.АгрегацияКодовМаркировкиСУЗИСМПТК);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьАгрегацияКодовМаркировкиСУЗ", "Видимость", ВидимостьАгрегацияКМ);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрупповоеСозданиеАгрегаций", 		   "Видимость", ВидимостьАгрегацияКМ);
	
	ВидимостьАгрегацияЦЭДМ = ПравоДоступа("Просмотр", Метаданные.Документы.АгрегацияВнеПроизводстваИСЦЭДМ);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьАгрегацияВнеПроизводстваЦЭДМ", "Видимость", ВидимостьАгрегацияЦЭДМ);
	
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Декорация2", "Видимость",
																	  (ВидимостьЗаказКМ ИЛИ ВидимостьНанесениеКМ) И (ВидимостьАгрегацияКМ ИЛИ ВидимостьАгрегацияЦЭДМ));
    //2. ГРУППА СЕРВИС
	//Пул кодов маркировки
	ВидимостьПулКодов = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПулКодовМаркировкиСУЗИСМПТК);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьПулКодовМаркировкиСУЗ", "Видимость", ВидимостьПулКодов);
	
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Декорация1", "Видимость",
																	  (ВидимостьЗаказКМ ИЛИ ВидимостьНанесениеКМ ИЛИ ВидимостьАгрегацияКМ ИЛИ ВидимостьАгрегацияЦЭДМ) 
																	  И (ВидимостьПулКодов ИЛИ ВидимостьАгрегацияЦЭДМ));
	///////////////////////////////
	
	//===========================
	
	////СЕРВИСНЫЕ ВОЗМОЖНОСТИ/////
	//1. НАСТРОЙКИ И СПРАВОЧНИКИ
	//Настройка обмена с ИС ЦЭДМ
	ВидимостьНастройкиОбмена = ПравоДоступа("Использование", Метаданные.Обработки.ПанельАдминистрированияИСМПТК);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НастройкаИСЦЭДМ", "Видимость", ВидимостьНастройкиОбмена);
							   
	//Справочник Станции управления заказами
	ВидимостьСУЗ = ПравоДоступа("Изменение", Метаданные.Справочники.СтанцииУправленияЗаказамиИСМПТК); //Просматривать рядовому пользователю незачем.
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтанцииУправленияЗаказами", "Видимость", ВидимостьСУЗ);
	
	//Справочник Шаблоны этикеток
	ВидимостьШаблоныЭтикетокКМ = ПравоДоступа("Просмотр", Метаданные.Справочники.ХранилищеШаблоновИСМПТК);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьШаблоныЭтикеток", "Видимость", ВидимостьШаблоныЭтикетокКМ);
	
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьСкладыЦЭДМ", "Видимость", ВедетсяУчетПоСкладам);
	
	//2. РАБОТА С ФАЙЛАМИ
	//РМ Печать КМ из загруженного файла
	ВидимостьРМПечатьИзФайла = ПравоДоступа("Просмотр", Метаданные.Обработки.РабочиеМестаИСМПТК.Команды.ОткрытьРМПечатьКМИзФайла);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПечатьКМИзЗагруженногоФайла", "Видимость", ВидимостьРМПечатьИзФайла);
	
	//РМ Объединение загруженных файлов
	ВидимостьРМОбъединениеФайлов = ПравоДоступа("Просмотр", Метаданные.Обработки.РабочиеМестаИСМПТК.Команды.ОткрытьРМОбъединениеФайлов);
	ОбщегоНазначенияИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОбъединениеФайлов", "Видимость", ВидимостьРМОбъединениеФайлов);
				
КонецПроцедуры

#КонецОбласти