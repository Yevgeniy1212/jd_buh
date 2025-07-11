﻿
#Область СлужебныйПрограммныйИнтерфейс

// Процедура выбора номенклатуры в документах подсистемы "Спецодежда"
// Отбор производится по признаку "ЯвляетсяСпецодеждойИнвентарем"
//
Процедура МатериалыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка, Номенклатура) Экспорт
	СтандартнаяОбработка 	= Ложь;
	ПараметрыФормы 			= Новый Структура;
	ПараметрыФормы.Вставить("Отбор",Новый Структура("си_ЯвляетсяСпецодеждойИнвентарем",Истина));
	ФормаВыбора 			= ПолучитьФорму("Справочник.Номенклатура.ФормаВыбора",ПараметрыФормы,Элемент);
	ФормаВыбора.Открыть();
КонецПроцедуры

Процедура НачалоВыбораСотрудникФизлицо(Элемент, ЭлементТЧ,СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка 	= Ложь;
	УчетПоФизЛицам 			= си_УчетСпецодеждыСервер.ПолучитьВедениеУчетаПоФизЛицам();
	ТекущиеДанные 			= ЭлементТЧ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПараметрыФормы 			= Новый Структура("ТекущаяСтрока,РежимВыбора",ТекущиеДанные.Сотрудник,Истина);
	Если УчетПоФизЛицам Тогда
		ИмяСправочника 		= "ФизическиеЛица";
		ИмяФормы 			= ".ФормаВыбора";
	Иначе
		ИмяСправочника 		= си_ОбщегоНазначенияВызовСервераПовтИсп.ИмяСправочникаСотрудников();
		ИмяФормы 			= ".ФормаВыбора";
		ПараметрыФормы.Вставить("РежимВыбора",Истина);
	КонецЕсли;
	
	ФормаВыбора 			= ПолучитьФорму("Справочник."+ИмяСправочника+ИмяФормы,ПараметрыФормы,Элемент);
	
	Если ТипЗнч(ФормаВыбора)<>Тип("УправляемаяФорма") Тогда
		ФормаВыбора.РежимВыбора = Истина;
	КонецЕсли;
	
	ФормаВыбора.Открыть();
	
КонецПроцедуры

Процедура СотрудникПриИзменении(Элемент) Экспорт
	УчетПоФизЛицам 			= си_УчетСпецодеждыСервер.ПолучитьВедениеУчетаПоФизЛицам();
	
	МассивТипов = Новый Массив;
	Если УчетПоФизЛицам Тогда 
		МассивТипов.Добавить(Тип("СправочникСсылка.ФизическиеЛица"));
	Иначе
		МассивТипов.Добавить(Тип("СправочникСсылка."+си_ОбщегоНазначенияВызовСервераПовтИсп.ИмяСправочникаСотрудников()));
	КонецЕсли;
	
	Элемент.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработка результата редактирования пути СЛК
//
Процедура ОбработкаРезультатаРедактированияПутиСЛК(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия<>Истина Тогда
		
		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияПредупрежденияНетКлюча", си_УчетСпецодеждыКлиент,ДополнительныеПараметры); 
		ПоказатьПредупреждение(ОписаниеОповещенияОЗакрытии, "Ключ защиты не обнаружен!");
		
	КонецЕсли;
	
КонецПроцедуры

// Обработка результата предупреждения о том что не найден ключ
//
Процедура ПослеЗакрытияПредупрежденияНетКлюча(ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры<>Неопределено И ТипЗнч(ДополнительныеПараметры)=Тип("Структура") Тогда
		ДополнительныеПараметры.Вставить("Отказ",Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//процедура вызова формы подбора номенклатуры 
//
Процедура ПодборНоменклатуры(ЭлементФормы,УникальныйИдентификатор,ПараметрыПодбора,Форма) Экспорт
	//ПараметрыФормы 			= Новый Структура;
	//ПараметрыФормы.Вставить("Отбор",Новый Структура("си_ЯвляетсяСпецодеждойИнвентарем",Истина));
	//ФормаПодбора 			= ПолучитьФорму("Справочник.Номенклатура.ФормаВыбора",ПараметрыФормы,Владелец);
	//ФормаПодбора.Открыть();
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.ОсновнаяФорма", ПараметрыПодбора,
		Форма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

Процедура ПроверкаНеобходимостиОбновления() Экспорт
	
	ИнициализироватьПодсистемуСИ();
	ВерсияКонфигурации 			= си_УчетСпецодеждыСервер.НомерВерсииТекущейКонфигурации();
	НоваяВерсияКонфигурации		= си_УчетСпецодеждыСервер.НомерВерсииКонфигурации();
	Если Не ВерсияКонфигурации 	= НоваяВерсияКонфигурации Тогда 
		си_УчетСпецодеждыСервер.ЗаписатьИдентификаторыОбъектовМетаданных();
		Если Не си_УчетСпецодеждыСервер.ПроизвестиПервыйЗапуск() Тогда
			Если НЕ си_ЗащитаКлиентСервер.ВозможностьОбновления() Тогда
				ОписаниеОшибки = "Не удалось выполнить обновление до версии " + НоваяВерсияКонфигурации + ".";
				Сообщить(ОписаниеОшибки, СтатусСообщения.Внимание);
			Возврат;
			КонецЕсли;

			ФормаОбновления 	= ПолучитьФорму("Обработка.си_ОбновлениеИнформационнойБазы.Форма.ЗапускОбработчиковОбновления");
		Иначе
			ФормаОбновления 	= ПолучитьФорму("ОбщаяФорма.си_ПредупреждениеОбновление");
		КонецЕсли;
		ФормаОбновления.Открыть();
	Иначе
		ПоказатьПредупреждение(,"Обновление не требуется");
	КонецЕсли;
КонецПроцедуры

//Инициализировать подсистему СИ
//
Процедура ИнициализироватьПодсистемуСИ(Параметры=Неопределено) Экспорт

	Если НЕ си_ЗащитаКлиентСервер.ЗапускМенеджераЛицензий() Тогда
		Если си_ОбщегоНазначенияСервер.ПравоРедактированияПутиСЛК() Тогда
			ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ОбработкаРезультатаРедактированияПутиСЛК",си_УчетСпецодеждыКлиент,Параметры); 
			ОткрытьФорму("ОбщаяФорма.си_НастройкаСвязиССерверомЛицензий",,,,,,ОписаниеОповещенияОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		Иначе
			ПоказатьПредупреждение(,"Ключ защиты не обнаружен!");
			Если Параметры<>Неопределено И ТипЗнч(Параметры)=Тип("Структура") Тогда
				Параметры.Вставить("Отказ",Истина);
			КонецЕсли;
			//ЗавершитьРаботуСистемы();
		КонецЕсли;
	Иначе
		ВерсияБиблиотекЗащиты = си_ПроцедурыМеханизмаЗащиты.ВерсияБиблиотекЗащиты();
		Если си_ПроцедурыМеханизмаЗащиты.ВерсияБиблиотекЗащиты()<>ВерсияБиблиотекЗащиты Тогда
			ПоказатьПредупреждение(,"Версия библиотек защиты ("+ВерсияБиблиотекЗащиты+") не соответствует версии, 
			|требуемой для работы приложения ("+си_ПроцедурыМеханизмаЗащиты.ВерсияБиблиотекЗащиты()+")! 
			|Необходимо обновить библиотеки защиты, следуя рекомендациям из описания полученного обновления.
			|Обновление библиотек защиты при запущенных сеансах подключения к информационной базе
			|может привести к использованию библиотек защиты, имевшихся на момент запуска первого из сеансов,
			|поэтому рекомендуется обновлять библиотеки защиты без активных сеансов подключения.",120);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьНаличиеНовойРедакцииСпецодежды(Отказ) Экспорт
	
	си_УчетСпецодеждыСервер.ПроверитьНаличиеНовойРедакцииСпецодежды(Отказ);
	
	Если Отказ Тогда
		Предупреждение(НСтр("ru = 'Запрещено создавать документы старой редакции.'"), 10, НСтр("ru = 'Ошибка создания документа!'"));
	КонецЕсли;	
	
КонецПроцедуры

