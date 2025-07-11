﻿
&НаСервере
Процедура ПриОткрытииНаСервере()
	
	Объект.ДатаАктуальности = КонецМесяца(ТекущаяДата());
	Объект.ДатаУволенных = НачалоДня(НачалоМесяца(ТекущаяДата()) - 1);
	
	Организация = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

Функция ВернутьТекстЗапроса(Уникальность = Ложь, ВыбиратьМестоРаботы = Истина)

	Если НЕ ЗначениеЗаполнено(Подразделение) И НЕ ЗначениеЗаполнено(Должность) И НЕ ЗначениеЗаполнено(Работник) Тогда
	
		ТекстЗапроса =  
		"ВЫБРАТЬ
		|	РаботникиОрганизаций.Сотрудник КАК Сотрудник,
		|	ПриемНаРаботуВОрганизацию.Ссылка КАК Приказ,
		|	РаботникиОрганизаций.Сотрудник.Код КАК СотрудникКод,
		|	РаботникиОрганизаций.Должность КАК Должность,
		|	РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|	РаботникиОрганизаций.Сотрудник.ДатаУвольнения КАК СотрудникДатаУвольнения
		|ИЗ
		|	РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуВОрганизацию КАК ПриемНаРаботуВОрганизацию
		|		ПО РаботникиОрганизаций.Регистратор = ПриемНаРаботуВОрганизацию.Ссылка
		|ГДЕ
		|	РаботникиОрганизаций.Организация = &Организация
		|	И НЕ ПриемНаРаботуВОрганизацию.Ссылка ЕСТЬ NULL";
	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Подразделение) И НЕ ЗначениеЗаполнено(Должность) И НЕ ЗначениеЗаполнено(Работник) Тогда
	
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	РаботникиОрганизаций.Сотрудник КАК Сотрудник,
		|	ПриемНаРаботуВОрганизацию.Ссылка КАК Приказ,
		|	РаботникиОрганизаций.Сотрудник.Код КАК СотрудникКод,
		|	РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|	РаботникиОрганизаций.Должность КАК Должность,
		|	РаботникиОрганизаций.Сотрудник.ДатаУвольнения КАК СотрудникДатаУвольнения
		|ИЗ
		|	РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуВОрганизацию КАК ПриемНаРаботуВОрганизацию
		|		ПО РаботникиОрганизаций.Регистратор = ПриемНаРаботуВОрганизацию.Ссылка
		|ГДЕ
		|	РаботникиОрганизаций.Организация = &Организация
		|	И РаботникиОрганизаций.Сотрудник.ТекущееПодразделениеОрганизации В (&ПодразделениеОрганизации)
		|	И НЕ ПриемНаРаботуВОрганизацию.Ссылка ЕСТЬ NULL";
	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Подразделение) И ЗначениеЗаполнено(Должность) И НЕ ЗначениеЗаполнено(Работник) Тогда
	
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	РаботникиОрганизаций.Сотрудник КАК Сотрудник,
		|	ПриемНаРаботуВОрганизацию.Ссылка КАК Приказ,
		|	РаботникиОрганизаций.Сотрудник.Код КАК СотрудникКод,
		|	РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|	РаботникиОрганизаций.Должность КАК Должность,
		|	РаботникиОрганизаций.Сотрудник.ДатаУвольнения КАК СотрудникДатаУвольнения
		|ИЗ
		|	РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуВОрганизацию КАК ПриемНаРаботуВОрганизацию
		|		ПО РаботникиОрганизаций.Регистратор = ПриемНаРаботуВОрганизацию.Ссылка
		|ГДЕ
		|	РаботникиОрганизаций.Организация = &Организация
		|	И НЕ ПриемНаРаботуВОрганизацию.Ссылка ЕСТЬ NULL
		|	И РаботникиОрганизаций.Должность В(&Должность)";
	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Подразделение) И НЕ ЗначениеЗаполнено(Должность) И ЗначениеЗаполнено(Работник) Тогда
	
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	РаботникиОрганизаций.Сотрудник КАК Сотрудник,
		|	ПриемНаРаботуВОрганизацию.Ссылка КАК Приказ,
		|	РаботникиОрганизаций.Сотрудник.Код КАК СотрудникКод,
		|	РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|	РаботникиОрганизаций.Должность КАК Должность,
		|	РаботникиОрганизаций.Сотрудник.ДатаУвольнения КАК СотрудникДатаУвольнения
		|ИЗ
		|	РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуВОрганизацию КАК ПриемНаРаботуВОрганизацию
		|		ПО РаботникиОрганизаций.Регистратор = ПриемНаРаботуВОрганизацию.Ссылка
		|ГДЕ
		|	РаботникиОрганизаций.Организация = &Организация
		|	И НЕ ПриемНаРаботуВОрганизацию.Ссылка ЕСТЬ NULL
		|	И РаботникиОрганизаций.Сотрудник В(&Сотрудник)";	
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Подразделение) И ЗначениеЗаполнено(Должность) И НЕ ЗначениеЗаполнено(Работник) Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	РаботникиОрганизаций.Сотрудник КАК Сотрудник,
		|	ПриемНаРаботуВОрганизацию.Ссылка КАК Приказ,
		|	РаботникиОрганизаций.Сотрудник.Код КАК СотрудникКод,
		|	РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|	РаботникиОрганизаций.Должность КАК Должность,
		|	РаботникиОрганизаций.Сотрудник.ДатаУвольнения КАК СотрудникДатаУвольнения
		|ИЗ
		|	РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуВОрганизацию КАК ПриемНаРаботуВОрганизацию
		|		ПО РаботникиОрганизаций.Регистратор = ПриемНаРаботуВОрганизацию.Ссылка
		|ГДЕ
		|	РаботникиОрганизаций.Организация = &Организация
		|	И РаботникиОрганизаций.Сотрудник.ТекущееПодразделениеОрганизации В (&ПодразделениеОрганизации)
		|	И НЕ ПриемНаРаботуВОрганизацию.Ссылка ЕСТЬ NULL
		|	И РаботникиОрганизаций.Должность В(&Должность)";
	КонецЕсли; 

		
	Возврат ТекстЗапроса;

КонецФункции

&НаСервере
Функция ТекстЗапросаГПХ()
	Если ЗначениеЗаполнено(Подразделение) И ЗначениеЗаполнено(Должность) Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.ДатаНачалаДействияДоговора КАК ДатаНачалаДействияДоговора,
		|	ДоговорыКонтрагентов.ДатаОкончанияДействияДоговора КАК ДатаОкончанияДействияДоговора,
		|	СчетаУчетаРасчетовСКонтрагентами.киб_Должность КАК Должность,
		|	СчетаУчетаРасчетовСКонтрагентами.киб_Подразделение КАК ПодразделениеОрганизации,
		|	ДоговорыКонтрагентов.Владелец.ФизЛицо КАК ФизЛицо
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаРасчетовСКонтрагентами КАК СчетаУчетаРасчетовСКонтрагентами
		|		ПО ДоговорыКонтрагентов.Ссылка = СчетаУчетаРасчетовСКонтрагентами.Договор
		|ГДЕ
		|	ДоговорыКонтрагентов.ПризнакГПХ = ИСТИНА
		|	И &ДатаПоиска МЕЖДУ ДоговорыКонтрагентов.ДатаНачалаДействияДоговора И ДоговорыКонтрагентов.ДатаОкончанияДействияДоговора
		|	И СчетаУчетаРасчетовСКонтрагентами.киб_Должность  В(&Должность)
		|	И СчетаУчетаРасчетовСКонтрагентами.киб_Подразделение В( &Подразделение)";   
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Подразделение) И Не ЗначениеЗаполнено(Должность) Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.ДатаНачалаДействияДоговора КАК ДатаНачалаДействияДоговора,
		|	ДоговорыКонтрагентов.ДатаОкончанияДействияДоговора КАК ДатаОкончанияДействияДоговора,
		|	СчетаУчетаРасчетовСКонтрагентами.киб_Должность КАК Должность,
		|	СчетаУчетаРасчетовСКонтрагентами.киб_Подразделение КАК ПодразделениеОрганизации,
		|	ДоговорыКонтрагентов.Владелец.ФизЛицо КАК ФизЛицо
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаРасчетовСКонтрагентами КАК СчетаУчетаРасчетовСКонтрагентами
		|		ПО ДоговорыКонтрагентов.Ссылка = СчетаУчетаРасчетовСКонтрагентами.Договор
		|ГДЕ
		|	ДоговорыКонтрагентов.ПризнакГПХ = ИСТИНА
		|	И &ДатаПоиска МЕЖДУ ДоговорыКонтрагентов.ДатаНачалаДействияДоговора И ДоговорыКонтрагентов.ДатаОкончанияДействияДоговора
		|	И СчетаУчетаРасчетовСКонтрагентами.киб_Подразделение  В(&Подразделение)";   
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Подразделение) И ЗначениеЗаполнено(Должность) Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.ДатаНачалаДействияДоговора КАК ДатаНачалаДействияДоговора,
		|	ДоговорыКонтрагентов.ДатаОкончанияДействияДоговора КАК ДатаОкончанияДействияДоговора,
		|	СчетаУчетаРасчетовСКонтрагентами.киб_Должность КАК Должность,
		|	СчетаУчетаРасчетовСКонтрагентами.киб_Подразделение КАК ПодразделениеОрганизации,
		|	ДоговорыКонтрагентов.Владелец.ФизЛицо КАК ФизЛицо
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаРасчетовСКонтрагентами КАК СчетаУчетаРасчетовСКонтрагентами
		|		ПО ДоговорыКонтрагентов.Ссылка = СчетаУчетаРасчетовСКонтрагентами.Договор
		|ГДЕ
		|	ДоговорыКонтрагентов.ПризнакГПХ = ИСТИНА
		|	И &ДатаПоиска МЕЖДУ ДоговорыКонтрагентов.ДатаНачалаДействияДоговора И ДоговорыКонтрагентов.ДатаОкончанияДействияДоговора
		|	И СчетаУчетаРасчетовСКонтрагентами.киб_Должность В( &Должность)";   
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Подразделение) И Не ЗначениеЗаполнено(Должность) Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.ДатаНачалаДействияДоговора КАК ДатаНачалаДействияДоговора,
		|	ДоговорыКонтрагентов.ДатаОкончанияДействияДоговора КАК ДатаОкончанияДействияДоговора,
		|	СчетаУчетаРасчетовСКонтрагентами.киб_Должность КАК Должность,
		|	СчетаУчетаРасчетовСКонтрагентами.киб_Подразделение КАК ПодразделениеОрганизации,
		|	ДоговорыКонтрагентов.Владелец.ФизЛицо КАК ФизЛицо
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаРасчетовСКонтрагентами КАК СчетаУчетаРасчетовСКонтрагентами
		|		ПО ДоговорыКонтрагентов.Ссылка = СчетаУчетаРасчетовСКонтрагентами.Договор
		|ГДЕ
		|	ДоговорыКонтрагентов.ПризнакГПХ = ИСТИНА
		|	И &ДатаПоиска МЕЖДУ ДоговорыКонтрагентов.ДатаНачалаДействияДоговора И ДоговорыКонтрагентов.ДатаОкончанияДействияДоговора";   
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;	
	
КонецФункции

&НаКлиенте
Процедура Выполнить1(Команда)
	Адрес = Выполнить1НаСервере();
	ОповеститьОВыборе(Адрес);
КонецПроцедуры

&НаСервере
Функция Выполнить1НаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст = ВернутьТекстЗапроса();
	
	Запрос.УстановитьПараметр("Организация", Справочники.Организации.ОрганизацияПоУмолчанию());
	Запрос.УстановитьПараметр("ПодразделениеОрганизации", Подразделение);
	Запрос.УстановитьПараметр("Должность", Должность);
	Запрос.УстановитьПараметр("Сотрудник", Работник);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	//Запрос по справочнику Договоры ГПХ
	ЗапросГПХ = Новый Запрос;
	ЗапросГПХ.Текст = ТекстЗапросаГПХ();
	ЗапросГПХ.УстановитьПараметр("Должность", Должность);
	ЗапросГПХ.УстановитьПараметр("Подразделение", Подразделение);
	ЗапросГПХ.УстановитьПараметр("ДатаПоиска", Объект.ДатаАктуальности);
	
	РезультатЗапросаГПХ = ЗапросГПХ.Выполнить().Выгрузить();
	
	
	тз = Новый ТаблицаЗначений;
	тз.Колонки.Добавить("Сотрудник");
	тз.Колонки.Добавить("Приказ");
	тз.Колонки.Добавить("Подразделение");
	тз.Колонки.Добавить("Должность");
	тз.Колонки.Добавить("ДатаУвольнения");
	тз.Колонки.Добавить("Договорник");
	
	Если Объект.ВключатьУволенных Тогда
		Для каждого Строка Из РезультатЗапроса Цикл
			//Пока Строка.СотрудникДатаУвольнения <= Объект.ДатаАктуальности Цикл
			Если ЗначениеЗаполнено(Строка.СотрудникДатаУвольнения) Тогда 
				Если Строка.СотрудникДатаУвольнения >= Объект.ДатаУволенных Тогда 
					СтрокаТз = тз.Добавить();
					СтрокаТз.Сотрудник = Строка.Сотрудник;
					СтрокаТз.Приказ = Строка.Приказ;
					СтрокаТз.Подразделение = Строка.ПодразделениеОрганизации;
					СтрокаТз.Должность = Строка.Должность;
					СтрокаТз.ДатаУвольнения = Строка.СотрудникДатаУвольнения;
					СтрокаТз.Договорник = Ложь;
				КонецЕсли;
			Иначе 
				СтрокаТз = тз.Добавить();
				СтрокаТз.Сотрудник = Строка.Сотрудник;
				СтрокаТз.Приказ = Строка.Приказ;
				СтрокаТз.Подразделение = Строка.ПодразделениеОрганизации;
				СтрокаТз.Должность = Строка.Должность;
				СтрокаТз.ДатаУвольнения = Строка.СотрудникДатаУвольнения;
				СтрокаТз.Договорник = Ложь;
			КонецЕсли;
			//КонецЦикла;
		КонецЦикла;
	Иначе
		Для каждого Строка Из РезультатЗапроса Цикл
			Если НЕ ЗначениеЗаполнено(Строка.СотрудникДатаУвольнения) Тогда 
				СтрокаТз = тз.Добавить();
				СтрокаТз.Сотрудник = Строка.Сотрудник;
				СтрокаТз.Приказ = Строка.Приказ;
				СтрокаТз.Подразделение = Строка.ПодразделениеОрганизации;
				СтрокаТз.Должность = Строка.Должность;
				СтрокаТз.ДатаУвольнения = Строка.СотрудникДатаУвольнения;
				СтрокаТз.Договорник = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для каждого СтрокаГПХ Из РезультатЗапросаГПХ Цикл
		СтрокаТз = тз.Добавить();
		СтрокаТз.Сотрудник = СтрокаГПХ.ФизЛицо;
		СтрокаТз.Подразделение = СтрокаГПХ.ПодразделениеОрганизации;
		СтрокаТз.Должность = СтрокаГПХ.Должность;
		СтрокаТз.Договорник = Истина;
	КонецЦикла;
	
	//<--  Контротек|Артем
	
	Для каждого СтрокаТаб из тз Цикл
		
		ДанныеПоСотруднику = РегистрыСведений.РаботникиОрганизаций.СрезПоследних(Объект.ДатаАктуальности, Новый Структура("Сотрудник", СтрокаТаб.Сотрудник));		
		
		Если ДанныеПоСотруднику <> Неопределено И ДанныеПоСотруднику.Количество() > 0 Тогда
			СтрокаТаб.Должность = ДанныеПоСотруднику[0].Должность;
			СтрокаТаб.Подразделение = ДанныеПоСотруднику[0].ПодразделениеОрганизации;
		КонецЕсли;		
		
	КонецЦикла;
	
	// -->
	
	Возврат ПоместитьВоВременноеХранилище(тз);	
	
КонецФункции

//&НаСервере
//Функция Получить(Сотрудник)
//	
//	
//	
//КонецФункции


