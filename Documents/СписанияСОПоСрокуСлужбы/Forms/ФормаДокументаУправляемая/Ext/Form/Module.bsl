﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
		Объект.ПериодСписанияС  = НачалоМесяца(ТекущаяДата());
		Объект.ПериодСписанияПо = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	ПересчитатьСуммыВТабличнойЧасти(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// РедактированиеДокументовПользователей
	ПраваДоступаКОбъектам.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец РедактированиеДокументовПользователей
	
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("Списание", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("Списание", Объект.Ссылка, ЭтаФорма);
	ПересчитатьСуммыВТабличнойЧасти(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ТаблицаТовары.Склад КАК Склад
	               |ПОМЕСТИТЬ СписокСкладов
	               |ИЗ
	               |	&ТаблицаТовары КАК ТаблицаТовары
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СписокСкладов.Склад.Наименование КАК СкладНаименование
	               |ИЗ
	               |	СписокСкладов КАК СписокСкладов";
	
	Запрос.УстановитьПараметр("ТаблицаТовары", Объект.Товары.Выгрузить(, "Склад"));
	Результат = Запрос.Выполнить().Выбрать();
	Представление = "";
	
	Пока Результат.Следующий() Цикл 
		Представление = ?(Представление = "", Представление, Представление + ", ")+ Результат.СкладНаименование;
	КонецЦикла;
	
	Объект.СкладыПредставление = Представление;
	            
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПериодСписания(Команда)
	
	ДиалогВыбораПериода = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогВыбораПериода.Период.ДатаНачала 	 = Объект.ПериодСписанияС;
	ДиалогВыбораПериода.Период.ДатаОкончания = Объект.ПериодСписанияПо;
	
	Если ДиалогВыбораПериода.Редактировать() Тогда
		Объект.ПериодСписанияС  = ДиалогВыбораПериода.Период.ДатаНачала;
		Объект.ПериодСписанияПо = ДиалогВыбораПериода.Период.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

// Заполнение остатками по сроку службы

&НаКлиенте
Процедура ЗаполнитьПоМАТ2(Команда)
	
	ЕстьОшибки = Ложь;
	Если Объект.ПериодСписанияС = '00010101' Тогда
		ЕстьОшибки = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Поле = "ПериодСписанияС";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = "Не указано начало периода!";
		Сообщение.Сообщить();
	КонецЕсли;	
		
	Если Объект.ПериодСписанияПо = '00010101' Тогда
		ЕстьОшибки = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Поле = "ПериодСписанияПо";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = "Не указан конец периода!";
		Сообщение.Сообщить();
	КонецЕсли;	
		
	Если НЕ ЕстьОшибки Тогда
		Если Объект.Товары.Количество() > 0 Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("ПослеПодтвержденияПерезаполнитьПоМАТ2", ЭтотОбъект), "Табличная часть будет перезаполнена, продолжить?", РежимДиалогаВопрос.ДаНет, 10, КодВозвратаДиалога.Нет, "Внимание!", КодВозвратаДиалога.Нет);
		Иначе 	
			ЗаполнитьПоМАТ2НаСервере();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеПодтвержденияПерезаполнитьПоМАТ2(Результат, ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ЗаполнитьПоМАТ2НаСервере();
	КонецЕсли;		
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоМАТ2НаСервере()
	
	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	СрокСлужбыСООстатки.Номенклатура,
	             |	СрокСлужбыСООстатки.ДатаОкончания,
	             |	СрокСлужбыСООстатки.ДатаВыдачи,
	             |	СрокСлужбыСООстатки.СрокСлужбы,
				 |	ЗНАЧЕНИЕ(ПланСчетов.Типовой.СписанныеПокупныеМатериалыКомплектующиеИзделия) КАК СчетУчетаБУ,
				 |	СрокСлужбыСООстатки.Номенклатура.БазоваяЕдиницаИзмерения КАК ЕдиницаИзмерения,
	             |	СУММА(СрокСлужбыСООстатки.КоличествоОстаток) КАК Количество,
	             |	СрокСлужбыСООстатки.СкладПолучатель КАК Склад,
				 |	1 КАК Коэффициент,
	             |	СрокСлужбыСООстатки.МОЛПолучатель КАК МОЛ
	             |ИЗ
	             |	РегистрНакопления.СрокСлужбыСО.Остатки(
	             |			&Дата2,
	             |			ДатаОкончания >= &Дата1
	             |				И ДатаОкончания <= &Дата2
	             |				"+?(ЗначениеЗаполнено(Объект.ЗаполнитьПо),"И СкладПолучатель = &ЗаполнитьПо","")+") КАК СрокСлужбыСООстатки
	             |
				 |ГДЕ
				 |	СрокСлужбыСООстатки.КоличествоОстаток > 0
	             |СГРУППИРОВАТЬ ПО
	             |	СрокСлужбыСООстатки.Номенклатура,
	             |	СрокСлужбыСООстатки.ДатаОкончания,
	             |	СрокСлужбыСООстатки.ДатаВыдачи,
	             |	СрокСлужбыСООстатки.СрокСлужбы,
	             |	СрокСлужбыСООстатки.МОЛПолучатель,
	             |	СрокСлужбыСООстатки.СкладПолучатель";
	Запрос.УстановитьПараметр("Дата1",Началодня(Объект.ПериодСписанияС));
	Запрос.УстановитьПараметр("Дата2",Конецдня(Объект.ПериодСписанияПо));
	Запрос.УстановитьПараметр("ЗаполнитьПо",Объект.ЗаполнитьПо);
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСкладПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		Если НЕ ТекущиеДанные.Склад.Пустая() Тогда
			ТекущиеДанные.МОЛ = ПолучитьМОЛСклада(ТекущиеДанные.Склад, Объект.Дата);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМОЛСклада(Склад, Дата)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОтветственныеЛицаСрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо
	               |ИЗ
	               |	РегистрСведений.ОтветственныеЛица.СрезПоследних(&ДатаСреза, СтруктурнаяЕдиница = &Склад) КАК ОтветственныеЛицаСрезПоследних";
	Запрос.УстановитьПараметр("ДатаСреза", Дата);
	Запрос.УстановитьПараметр("Склад", Склад);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Возврат Результат.ФизическоеЛицо;
	Иначе 
		Возврат Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли;	
	
КонецФункции	

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Копирование Тогда
		
		Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо = Неопределено;
		Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.Председатель = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если НЕ ОтменаРедактирования Тогда
		
		УсловияПоиска = Новый Структура("ФизЛицо", Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо);
		СтрокиФЛ = Объект.ИнвентаризационнаяКомиссия.НайтиСтроки(УсловияПоиска);
		
		Если СтрокиФЛ.Количество() > 1 Тогда
			
			Отказ = Истина;
			ТекстПредупреждения = НСтр("ru='Физическое лицо %1 уже включено в состав комиссии!'");
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", 
															Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо);
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо = Неопределено;
			ТекущийЭлемент = Элементы.ИнвентаризационнаяКомиссияФизЛицо;
			
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ ОтменаРедактирования Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ПроверитьФлагиПредседателя(Элемент.ТекущиеДанные);
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияФизЛицоПриИзменении(Элемент)
	
	Если Объект.ИнвентаризационнаяКомиссия.Количество() = 1 Тогда
		
		Объект.ИнвентаризационнаяКомиссия[0].Председатель = Истина;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПредседательПриИзменении(Элемент)
	
	Для Каждого Строка Из Объект.ИнвентаризационнаяКомиссия Цикл
			
		Если НЕ (Строка.НомерСтроки = Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.НомерСтроки) Тогда
			
			Строка.Председатель = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ПодборКомиссии(Команда)
	
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФлагиПредседателя(СтрокаТЧ)
    
	СтрокаПредседателя = ?(СтрокаТЧ <> Неопределено И СтрокаТЧ.Председатель, СтрокаТЧ, Неопределено);
	
	Для Каждого СтрокаКомиссии Из Объект.ИнвентаризационнаяКомиссия Цикл
		
		Если СтрокаКомиссии.Председатель И СтрокаПредседателя = Неопределено Тогда
			СтрокаПредседателя = СтрокаКомиссии;
			Продолжить;
		КонецЕсли;	
		
		Если СтрокаКомиссии.Председатель И СтрокаКомиссии <> СтрокаПредседателя Тогда
			СтрокаКомиссии.Председатель = Ложь;
		КонецЕсли;	
		
	КонецЦикла;	

	Если СтрокаПредседателя = Неопределено И Объект.ИнвентаризационнаяКомиссия.Количество() > 0 Тогда
		Объект.ИнвентаризационнаяКомиссия[0].Председатель = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПослеУдаления(Элемент)
	
	Если Объект.ИнвентаризационнаяКомиссия.Количество() > 0 Тогда
		ПроверитьФлагиПредседателя(Неопределено);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборСпецОдежды.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);		
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СтрокаТабличнойЧасти = Неопределено;
			
		// Ищем выбранную позицию в таблице подобранной номенклатуры.
		//  Если найдем - увеличим количество; не найдем - добавим новую строку.
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Склад", 		  	 СтрокаТовара.Склад);
		СтруктураОтбора.Вставить("МОЛ", 			 СтрокаТовара.МОЛ);
		СтруктураОтбора.Вставить("Номенклатура", 	 СтрокаТовара.Номенклатура);
		СтруктураОтбора.Вставить("Цена", 			 СтрокаТовара.Цена);
		СтруктураОтбора.Вставить("Количество",		 СтрокаТовара.Количество);
		СтруктураОтбора.Вставить("ДатаВыдачи", 	  	 СтрокаТовара.ДатаВыдачи);
		СтруктураОтбора.Вставить("СрокСлужбы", 	  	 СтрокаТовара.СрокСлужбы);
		СтруктураОтбора.Вставить("ДатаОкончания", 	 СтрокаТовара.ДатаОкончания);
		
		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(Объект, "Товары", СтруктураОтбора);
	
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + СтрокаТовара.Количество;
		Иначе
			// Не нашли - добавляем новую строку.
			СтрокаТабличнойЧасти = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара);
			СтрокаТабличнойЧасти.Коэффициент = 1;
			СтрокаТабличнойЧасти.СчетУчетаБУ = ПланыСчетов.Типовой.СпецОдежда;
			СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтрокаТабличнойЧасти.Номенклатура.БазоваяЕдиницаИзмерения;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ПересчитатьСуммыВТабличнойЧасти(Объект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьСуммыВТабличнойЧасти(Объект)

	Для Каждого СтрокаТаб Из Объект.Товары Цикл
		СтрокаТаб.Сумма = СтрокаТаб.Цена * СтрокаТаб.Количество;		       	
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
КонецПроцедуры

&НаКлиенте
Процедура ПодборСпецОдежды(Команда)
	
	ПараметрыПодбора = ПолучитьПараметрыПодбора();
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборСпецОдежды.Форма.Форма", ПараметрыПодбора, ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора()

	ПараметрыФормы = Новый Структура;

	ПараметрыФормы.Вставить("Склад.ОтноситсяК", 		Объект.ЗаполнитьПо);
	ПараметрыФормы.Вставить("МОЛ",   		ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка"));
	ПараметрыФормы.Вставить("Дата",  		Объект.Дата);
	ПараметрыФормы.Вставить("Организация", 	Объект.Организация);

	Возврат ПараметрыФормы;

КонецФункции

&НаСервере
Процедура ПодписантПриИзмененииНаСервере()
	ДанныеМОЛ = ПроцедурыУправленияПерсоналомВызовСервера.ДанныеФизЛица(Объект.Организация, Объект.Подписант, Объект.Дата);
	Объект.ДолжностьПодписанта = ДанныеМОЛ.Должность;
КонецПроцедуры

&НаКлиенте
Процедура ПодписантПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьСчетМАТ2()
	Возврат ПланыСчетов.Типовой.СписанныеПокупныеМатериалыКомплектующиеИзделия;
КонецФункции

&НаСервере
Функция ПолучитьЕдиницуИзмеренияИзНоменклатуры(Номенклатура)
	Возврат Номенклатура.БазоваяЕдиницаИзмерения; 
КонецФункции 

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные; 
	
	ТекущиеДанные.ЕдиницаИзмерения = ПолучитьЕдиницуИзмеренияИзНоменклатуры(ТекущиеДанные.Номенклатура);
	ТекущиеДанные.Коэффициент = 1;
	ТекущиеДанные.СчетУчетаБУ =	ПолучитьСчетМАТ2(); 
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Приказ = Справочники.ПриказыОрганизации.НайтиПоРеквизиту("ОсновнойПриказ", Истина);		
		Если Объект.Приказ.Пустая() Тогда
		     Объект.Приказ = Справочники.ПриказыОрганизации.НайтиПоКоду("0001");
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры


	// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

