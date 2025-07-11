﻿
////////////////////////////////////////////////////////////////////////////////
//ОБРАБОТЧИКИ СОБЫТИЙ  ФОРМЫ

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если  ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.НоменклатураГСВС.Форма.ФормаВыбора") Тогда
		
		УстановитьКодТНВЭД(ВыбранноеЗначение);
			
		Модифицированность = Истина;
		
	КонецЕсли;
	
	ОбновитьНаименование();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не Параметры.ЗначениеКопирования.Пустая() ИЛИ Параметры.Ключ.Пустая() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗаполнитьСписокВыбораПоляНаименование();
	УправлениеФормой(ЭтаФорма);
	
	Элементы.ФормаРедактироватьНедоступныеРеквизиты.Видимость = РольДоступна("ПолныеПрава");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
//ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте

Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВСКлиентПереопределяемый.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте

&НаКлиенте
Процедура НомерСтрокиГТДПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерСертификатаПроисхожденияТовараПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСертификатаПроисхожденияТовараПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПроисхожденияПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВСКлиентПереопределяемый.КодТНВЭДНачалоВыбора(Объект.КодТНВЭД, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДПриИзменении(Элемент)
	
	ОбновитьНаименование();
	
	//ЗаполнитьГСВС();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;	
	Объект = Форма.Объект;
	ВидимостьДанныхГТД = НЕ(Объект.ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.НеУстановлено"));
	
	Элементы.ДатаСертификатаПроисхожденияТовара.Видимость = НЕ ВидимостьДанныхГТД;
	
	Элементы.НомерЗаявленияВРамкахТС.Заголовок = ?(ВидимостьДанныхГТД, НСтр("ru = 'Номер ГТД/ФНО 328'"), НСтр("ru = 'Номер сертификата'"));
	//Элементы.НомерПозицииВДекларацииИлиЗаявлении.Видимость = ВидимостьДанныхГТД;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораПоляНаименование()
	//ВариантыНаименованийНомераГТД = Справочники.НомераГТД.ВариантыНаименованийНомераГТД(Объект);
	//Элементы.Наименование.СписокВыбора.ЗагрузитьЗначения(ВариантыНаименованийНомераГТД);	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименование()
		
	//ВариантыНаименованийНомераГТД = Справочники.НомераГТД.ВариантыНаименованийНомераГТД(Объект);
	//Элементы.Наименование.СписокВыбора.ЗагрузитьЗначения(ВариантыНаименованийНомераГТД);
	//Объект.Наименование = ВариантыНаименованийНомераГТД[ВариантыНаименованийНомераГТД.ВГраница()];
		
КонецПроцедуры

&НаКлиенте
Процедура ГСВСПриИзменении(Элемент)
	ГСВСПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ГСВСПриИзмененииНаСервере()
	
КонецПроцедуры

&НаКлиенте
Процедура НомерГТДПриИзменении(Элемент)
	ОбновитьНаименование();
КонецПроцедуры

&НаКлиенте
Процедура ФормаРедактироватьНедоступныеРеквизиты(Команда)
	Если Элементы.ФормаРедактироватьНедоступныеРеквизиты.Пометка Тогда
		РедактироватьНедоступныеРеквизитыНаСервере(Ложь);
	Иначе
		ТекстВопроса = НСтр("ru = 'Разрешить редактирование реквизитов справочника?'");
		РедактироватьНедоступныеРеквизитыЗавершение = Новый ОписаниеОповещения("РедактироватьНедоступныеРеквизитыЗавершение", ЭтаФорма);
		ПоказатьВопрос(РедактироватьНедоступныеРеквизитыЗавершение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНедоступныеРеквизитыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		РедактироватьНедоступныеРеквизитыНаСервере(Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура РедактироватьНедоступныеРеквизитыНаСервере(Знач НовоеЗначениеПометки)
	
	Элементы.ФормаРедактироватьНедоступныеРеквизиты.Пометка	= НовоеЗначениеПометки;
	
	Если НовоеЗначениеПометки Тогда
		Элементы.НомерЗаявленияВРамкахТС.ТолькоПросмотр 			= Ложь;
		Элементы.НомерПозицииВДекларацииИлиЗаявлении.ТолькоПросмотр = Ложь;
		Элементы.НаименованиеТовара.ТолькоПросмотр 					= Ложь;
		Элементы.СтранаПроисхождения.ТолькоПросмотр					= Ложь;
	Иначе
		Элементы.НомерЗаявленияВРамкахТС.ТолькоПросмотр 			= Истина;
		Элементы.НомерПозицииВДекларацииИлиЗаявлении.ТолькоПросмотр = Истина;
		Элементы.НаименованиеТовара.ТолькоПросмотр 					= Истина;
		Элементы.СтранаПроисхождения.ТолькоПросмотр 				= Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьКодТНВЭД(НомеклатураГСВС)
	
	Объект.КодТНВЭД = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НомеклатураГСВС, "КодГСВС");
	
КонецПроцедуры
