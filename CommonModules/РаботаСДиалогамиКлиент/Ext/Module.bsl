﻿////////////////////////////////////////////////////////////////////////////////
// РаботаСДиалогамиКлиент: модуль предоставляет функционал по организации 
// интерактивного диалога с пользователем.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы со структурными подразделениями

// Процедура должна использоваться при начале выбора значения в поле "СтруктурноеПодразделениеОрганизация" форм
// 
// Параметры
//  Форма - ФормаКлиентскогоПриложения - Форма из которой происходит вызов процедуры
//  СтандартнаяОбработка - Булево - признак стандартной обработки события начала выбора
//  Организация - СправочникСсылка.Организации - значение реквизита "Организация"  объекта или аналогичного по свойствам и смыловой нагрузке реквизита объекта
//  СтруктурноеПодразделение - СправочникСсылка.ПодразделенияОрганизаций - значение реквизита "СтруктурноеПодразделение" объекта
//  ДоступностьИзмененияОрганизации - Булево - флаг, влияющий на доступность поля "Организация" форме "ФормаВыбораСтруктурногоПодразделения"
//  ИмяПроцедурыОбработкиВыбора - Строка - имя процедуры в модуле формы, которая будет вызвана после выбора значения в форме "ФормаВыбораСтруктурногоПодразделения"
//  ДополнительныеПараметры - Структура - дополнительные параметры, которые необходимо передать в обработчик события после выбора
//
Процедура СтруктурноеПодразделениеНачалоВыбора(Форма, СтандартнаяОбработка, Организация, СтруктурноеПодразделение, ДоступностьИзмененияОрганизации = Истина, ИмяПроцедурыОбработкиВыбора = "ПослеВыбораСтруктурногоПодразделения", ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Форма.ПоддержкаРаботыСоСтруктурнымиПодразделениями ИЛИ ЗначениеЗаполнено(СтруктурноеПодразделение) Тогда
		СтандартнаяОбработка = Ложь;
		ОписаниеОповещения = Новый ОписаниеОповещения(ИмяПроцедурыОбработкиВыбора, Форма, ДополнительныеПараметры);
		ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтруктурногоПодразделения", Новый Структура("Организация, СтруктурноеПодразделение, ДоступноИзменениеОрганизации", Организация, СтруктурноеПодразделение, ДоступностьИзмененияОрганизации), Форма, Истина,,, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается из формы объекта после выбора значения в поле "СтруктурноеПодразделениеОрганизация" и выполняет общие действия для всех объектов.
// А именно, заполняет реквизиты "Организация" и "СтруктурноеПодразделение" объекта и устанавливает значение реквизита формы "СтруктурноеПодразделениеОрганизация"
//
// Параметры
//  Результат - Структура - результат обработки выбора значения из формы "ФормаВыбораСтруктурногоПодразделения"
//  Организация - СправочникСсылка.Организации - значение реквизита "Организация" объекта
//  СтруктурноеПодразделение - СправочникСсылка.ПодразделенияОрганизаций - значение реквизита "СтруктурноеПодразделение" объекта
//  ЗначениеЭлементаФормы - СправочникСсылка.Организации, СправочникСсылка.ПодразделенияОрганизаций - значение реквизита формы, который хранит информацию о выбранной структурной единице
//
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Организация, СтруктурноеПодразделение, ЗначениеЭлементаФормы = Неопределено) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Организация 			 = Результат.Организация;
		СтруктурноеПодразделение = Результат.СтруктурноеПодразделение;
		
		Если ЗначениеЗаполнено(СтруктурноеПодразделение) Тогда 
			ЗначениеЭлементаФормы = СтруктурноеПодразделение;
		Иначе 
			ЗначениеЭлементаФормы = Организация;
		КонецЕсли;
	Иначе 
		Результат = Новый Структура("Организация, СтруктурноеПодразделение, ИзмененаОрганизация, ИзмененоСтруктурноеПодразделение", 
									Организация, 
									СтруктурноеПодразделение,
									Ложь,
									Ложь);
	КонецЕсли;
	
КонецПроцедуры

// В функции проверяется измененность реквизита формы "СтруктурноеПодразделениеОрганизация" по отношению к реквизитам объекта
// 
// Параметры
//  СтруктурноеПодразделениеОрганизация - СправочникСсылка.Организации, СправочникСсылка.ПодразделенияОрганизаций - значение реквизита формы, содержащее значение организации или структурного подразделения
//  Организация - СправочникСсылка.Организации - значение реквизита "Организация" объекта
//  СтруктурноеПодразделение - СправочникСсылка.ПодразделенияОрганизаций - значение реквизита "СтруктурноеПодразделение" объекта
//
// Возвращаемое значение
//  Структура - Структура - структура, содержащая информацию об изменениях. Ключи структуры: ИзмененаОрганизация, ИзмененоСтруктурноеПодразделение. Ключи заполняются если изменена организация или структурное подразделение соответственно.
//
Функция ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Организация, СтруктурноеПодразделение) Экспорт 
	
	ИзмененаОрганизация = Ложь;
	ИзмененоСтруктурноеПодразделение = Ложь;
	
	Если ТипЗнч(СтруктурноеПодразделениеОрганизация) = Тип("СправочникСсылка.Организации") 
		И (СтруктурноеПодразделениеОрганизация <> Организация 
			ИЛИ ЗначениеЗаполнено(СтруктурноеПодразделение)) Тогда 
		ИзмененаОрганизация = Истина;
		ИзмененоСтруктурноеПодразделение = Истина;
	ИначеЕсли ТипЗнч(СтруктурноеПодразделениеОрганизация) = Тип("СправочникСсылка.ПодразделенияОрганизаций") 
		И СтруктурноеПодразделениеОрганизация <> СтруктурноеПодразделение Тогда 
		ИзмененоСтруктурноеПодразделение = Истина;
	КонецЕсли;
	
	Возврат Новый Структура("ИзмененаОрганизация, ИзмененоСтруктурноеПодразделение, НеобходимоИзменитьЗначенияРеквизитовОбъекта", ИзмененаОрганизация, ИзмененоСтруктурноеПодразделение, ИзмененаОрганизация ИЛИ ИзмененоСтруктурноеПодразделение);
	
КонецФункции

// В процедуре задается вопрос пользователю о возможном содержании некорректных значений и вызывается процедура обработки выбора пользователя
//
// Параметры
//  Форма - ФормаКлиентскогоПриложения - форма из которой инициируется вопрос пользователю
//  Параметры - Структура - дополнительные параметры, которые необходимо передать в процедуру обработки выбора пользователя
//  ИмяВызываемойПроцедуры - Строка - процедура, которая будет вызвана после ответа пользователя на поставленный вопрос
//  ТекстВопроса - Строка - необязательный, используется, если необходимо переопределить текст вопроса, задаваемого пользователю
//
Процедура ПоказатьВопросОбОчисткеНекорректныхЗначенийПодразделения(Форма, Параметры, ИмяВызываемойПроцедуры = "ПослеЗакрытияВопросаОбОчисткеНекорректныхЗначенийПодразделения", ТекстВопроса = "") Экспорт
	
	Если ПустаяСтрока(ТекстВопроса) Тогда 
		ТекстВопроса = НСтр("ru='Возможно в значениях полей документа содержится подразделение не принадлежащее структурной единице.
								|Очистить некорректные значения?'");
	КонецЕсли;

	ОписаниеОповещения = Новый ОписаниеОповещения(ИмяВызываемойПроцедуры, Форма, Параметры);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

Процедура НачалоВыбораКонтактногоЛицаКонтрагента(Элемент, СтандартнаяОбработка, Контрагент) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("ОбъектВладелец", Контрагент));
	ПараметрыФормы.Вставить("ТекущаяСтрока", Контрагент);
	
	ОткрытьФорму("Справочник.КонтактныеЛица.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Функция преобразовывает дату в представление периода
//
// Параметры:
//   ПериодРегистрации - Дата периода
//
// Возвращаемое значение:
//  Строка
//
Функция ПолучитьПредставлениеПериодаРегистрации(ПериодРегистрации) Экспорт

	Возврат Формат(ПериодРегистрации, "ДФ='MMMM yyyy'");

КонецФункции

// Процедура обрабатывает событие регулирования в поле периода регистрации
//
Процедура РегулированиеПредставленияПериодаРегистрации(Направление, СтандартнаяОбработка, ПериодРегистрации, ПредставлениеПериодаРегистрации) Экспорт

	СтандартнаяОбработка = Ложь;
	
	Если Направление = 1 Тогда
		ПериодРегистрации = КонецМесяца(ПериодРегистрации) + 1;
	ИначеЕсли Направление = -1 Тогда
		ПериодРегистрации = НачалоМесяца(ПериодРегистрации - 1);
	КонецЕсли;

	ПредставлениеПериодаРегистрации = ПолучитьПредставлениеПериодаРегистрации(ПериодРегистрации);

КонецПроцедуры

// Процедура обрабатывает событие начала выбора из списка в поле периода регистрации
// Процедура исполняется только на клиенте
// СтандартнаяОбработка не устанавливается в значение Ложь, иначе появляется поле данных выбора со значением """" не найдено"
//
Процедура НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, ПериодРегистрации, ЭтаФорма, НачальноеЗначение = Неопределено, ОбрабатыватьВыборИзСписаНаФорме = Ложь) Экспорт

	Если НачальноеЗначение = Неопределено Тогда
		НачальноеЗначение = ПериодРегистрации;
	КонецЕсли; 
	
	СписокВыбора = Новый СписокЗначений;
	НачалоТекущегоГода = НачалоГода(НачальноеЗначение);
	НачалоПрошлогоГода = НачалоГода(НачалоТекущегоГода - 1);
	СписокВыбора.Добавить(НачалоПрошлогоГода, (Формат(НачалоПрошлогоГода, "ДФ='yyyy'") + "..."));
	НачалоМесяцаЗаполнения = НачалоТекущегоГода;
	Для а = 1 По 12 Цикл
		ДобавленныйЭлемент = СписокВыбора.Добавить(НачалоМесяцаЗаполнения, РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(НачалоМесяцаЗаполнения));
		НачалоМесяцаЗаполнения = ДобавитьМесяц(НачалоМесяцаЗаполнения, 1);
	КонецЦикла;
	НачалоСледующегоГода = КонецГода(НачалоТекущегоГода) + 1;
	СписокВыбора.Добавить(НачалоСледующегоГода, (Формат(НачалоСледующегоГода, "ДФ='yyyy'") + "..."));
	
	ДопПараметры = Новый Структура("Элемент, ПериодРегистрации, ЭтаФорма", Элемент, ПериодРегистрации, ЭтаФорма);
	
	ЭтаФорма.ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ВыполнитьПослеВыбораИзСпискаПредставленияПериодаРегистрации", ?(ОбрабатыватьВыборИзСписаНаФорме, ЭтаФорма, РаботаСДиалогамиКлиент), ДопПараметры), СписокВыбора, Элемент, СписокВыбора.НайтиПоЗначению(ПериодРегистрации));
	
КонецПроцедуры

Процедура ВыполнитьПослеВыбораИзСпискаПредставленияПериодаРегистрации(ВыбранныйЭлемент, ДопПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	ИначеЕсли Год(ВыбранныйЭлемент.Значение) <> Год(ДопПараметры.ПериодРегистрации) Тогда
		НачалоВыбораИзСпискаПредставленияПериодаРегистрации(ДопПараметры.Элемент, ВыбранныйЭлемент.Значение, ДопПараметры.ЭтаФорма, ВыбранныйЭлемент.Значение);
		Возврат;
	КонецЕсли;
	
	ДопПараметры.ЭтаФорма.Объект.ПериодРегистрации = ВыбранныйЭлемент.Значение; 
	ДопПараметры.ЭтаФорма.МесяцНачисленияСтрокой   = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(ВыбранныйЭлемент.Значение);
	ДопПараметры.ЭтаФорма.Модифицированность = Истина;

	//////////////////////////////////////////////////////////////////////////////
	// Оповещение об изменении периода необходимо
	// для выполнения дополнительных действий в форме источнике.
	
	ПараметрыОповещения = Новый Структура;	
	Если ДопПараметры.Свойство("ЭтаФорма") Тогда
		ПараметрыОповещения.Вставить("Форма", ДопПараметры.ЭтаФорма); 	
	КонецЕсли;
	Оповестить("ИзмененПериод", ПараметрыОповещения);
	
КонецПроцедуры

// Процедура обрабатывает событие начала выбора из списка в поле периода регистрации
// Процедура исполняется только на клиенте
//
Функция ПолучитьСпискаПредставленияПериодаРегистрации(ПериодРегистрации, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	НачалоТекущегоГода = НачалоГода(ПериодРегистрации);
	НачалоПрошлогоГода = НачалоГода(НачалоТекущегоГода - 1);
	ДанныеВыбора.Добавить(НачалоПрошлогоГода, (Формат(НачалоПрошлогоГода, "ДФ='yyyy'") + "..."));
	НачалоМесяцаЗаполнения = НачалоТекущегоГода;
	Для а = 1 По 12 Цикл
		ДобавленныйЭлемент = ДанныеВыбора.Добавить(НачалоМесяцаЗаполнения, РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(НачалоМесяцаЗаполнения));
		НачалоМесяцаЗаполнения = ДобавитьМесяц(НачалоМесяцаЗаполнения, 1);
	КонецЦикла;
	НачалоСледующегоГода = КонецГода(НачалоТекущегоГода) + 1;
	ДанныеВыбора.Добавить(НачалоСледующегоГода, (Формат(НачалоСледующегоГода, "ДФ='yyyy'") + "..."));
	
	Возврат ДанныеВыбора;
	
КонецФункции

Процедура ПоказатьВопросОПересчетеСуммыДокумента(Форма, Параметры, ИмяВызываемойПроцедуры = "ПослеЗакрытияВопросаОПересчетеСуммыДокумента") Экспорт
	
	ТекстВопроса = НСтр("ru='Изменилась валюта документа. Пересчитать сумму документа?'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(ИмяВызываемойПроцедуры, Форма, Параметры);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

Функция НачалоВыбораСпискаСтруктурныхЕдиниц(СписокСтруктурныхЕдиниц, Форма, СтандартнаяОбработка,
												РежимВыбораСтруктурныхЕдиниц = "ПоГоловнымОрганизациям", 
												Налогоплательщик = Неопределено,
												НалоговыйКомитет = Неопределено,
												РазделНалоговогоУчета = Неопределено,
												ЗапретитьИзменениеПараметровОтбора = Ложь,
												ГоловнаяОрганизацияДляУчетаЗарплаты = Неопределено,
												ИмяПроцедурыОбработкиВыбора = "ПослеВыбораСпискаСтруктурныхЕдиниц") Экспорт

	СтандартнаяОбработка = Ложь;
	
	Если РазделНалоговогоУчета = Неопределено Тогда
		РазделНалоговогоУчета = ПредопределенноеЗначение("Перечисление.РазделыНалоговогоУчета.НДС");
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НачальныйСписокСтруктурныхЕдиниц", СписокСтруктурныхЕдиниц);
	ПараметрыФормы.Вставить("РежимВыбораСтруктурныхЕдиниц", РежимВыбораСтруктурныхЕдиниц);
	ПараметрыФормы.Вставить("Налогоплательщик", Налогоплательщик);
	ПараметрыФормы.Вставить("НалоговыйКомитет", НалоговыйКомитет);
	ПараметрыФормы.Вставить("РазделНалоговогоУчета", РазделНалоговогоУчета);
	ПараметрыФормы.Вставить("ЗапретитьИзменениеПараметровОтбора", ЗапретитьИзменениеПараметровОтбора);
	ПараметрыФормы.Вставить("ГоловнаяОрганизацияДляУчетаЗарплаты", ГоловнаяОрганизацияДляУчетаЗарплаты);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(ИмяПроцедурыОбработкиВыбора, Форма);
		
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтруктурныхЕдиниц", ПараметрыФормы,,,,, ОписаниеОповещения);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ВВОДА ДАТЫ КАК МЕСЯЦА

// Предназначена для реализации "произвольного" ввода даты-месяца
// подбирает по переданному тексту строку-представление даты или список таких строк
// в переданный параметр ДатаПоТексту возвращает подобранную по тексту дату
Функция ДатаКакМесяцПодобратьДатуПоТексту(Текст, ДатаПоТексту = Неопределено) Экспорт
    СписокВозврата = Новый СписокЗначений;
    ТекущийГод = Год(ТекущаяДата());
    
    Если ПустаяСтрока(Текст) Тогда
        Возврат СписокВозврата;
    КонецЕсли;
    Если Найти(Текст, ".") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ".");
    ИначеЕсли Найти(Текст, ",") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ",");
    ИначеЕсли Найти(Текст, "-") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "-");
    ИначеЕсли Найти(Текст, "/") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "/");
    ИначеЕсли Найти(Текст, "\") <> 0 Тогда
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "\");
    Иначе
        Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, " ");
    КонецЕсли;
    Если Подстроки.Количество() = 1 Тогда
        // единственное слово - пытаемся получить месяц
        Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Текст) Тогда
            МесяцЧислом = Число(Текст);
            Если МесяцЧислом >= 1 и МесяцЧислом <=12 Тогда
                ДатаПоТексту = Дата(ТекущийГод, МесяцЧислом, 1);
                Если СтрДлина(Текст) = 1 Тогда
                    СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='М/гг'"));
                Иначе
                    СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММ/гг'"));
                КонецЕсли;
            Иначе
                Возврат СписокВозврата;
            КонецЕсли;                
        Иначе
            СписокМесяцев = ОбщегоНазначенияБККлиент.СписокМесяцевПоСтроке(Текст);
            Для Каждого Месяц Из СписокМесяцев Цикл
                ДатаПоТексту = Дата(ТекущийГод, Месяц, 1);
                СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гг'"));
            КонецЦикла;
        КонецЕсли;
    ИначеЕсли Подстроки.Количество() = 2 Тогда
        // два слова - первое считаем месяцем, второе - годом
        Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[1]) Тогда
            Если ПустаяСтрока(Подстроки[1]) Тогда
                ГодЧислом = 0;
                Подстроки[1] = "0";
                ТекстВозврата = Текст + "0";
            Иначе
                ГодЧислом = Число(Подстроки[1]);
                ТекстВозврата = "";
            КонецЕсли;
            Если ГодЧислом > 3000 Тогда
                Возврат СписокВозврата;
            КонецЕсли;
            Если СтрДлина(Подстроки[1]) <= 1 Тогда
                ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 3) + Подстроки[1]);
                СтрокаФорматированияГода = "г";
            ИначеЕсли СтрДлина(Подстроки[1]) = 2 Тогда
                ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 2) + Подстроки[1]);
                СтрокаФорматированияГода = "гг";
            ИначеЕсли СтрДлина(Подстроки[1]) = 3 Тогда
                ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 1) + Подстроки[1]);
                СтрокаФорматированияГода = "гггг";
            КонецЕсли;                    
        Иначе
            // второе слово может быть только годом
            Возврат СписокВозврата;
        КонецЕсли;                
        Если ЗначениеЗаполнено(Подстроки[0]) И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[0]) Тогда
            МесяцЧислом = Число(Подстроки[0]);
            Если МесяцЧислом >= 1 и МесяцЧислом <= 12 Тогда
                // если "правильный" месяц и год
                ДатаПоТексту = Дата(ГодЧислом, МесяцЧислом, 1);
                СписокВозврата.Добавить(ТекстВозврата);
            Иначе
                Возврат СписокВозврата;
            КонецЕсли;                
        Иначе
            СписокМесяцев = ОбщегоНазначенияБККлиент.СписокМесяцевПоСтроке(Подстроки[0]);
			Если СписокМесяцев.Количество() = 1 Тогда
				ДатаПоТексту = Дата(ГодЧислом, СписокМесяцев[0], 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			Иначе
				Для Каждого Месяц Из СписокМесяцев Цикл
                    ДатаПоТексту = Дата(ГодЧислом, Месяц, 1);
                    СписокВозврата.Добавить(Формат(Дата(ГодЧислом, Месяц, 1), "ДФ='ММММ гг'"));
                КонецЦикла;
            КонецЕсли;
        КонецЕсли;
    КонецЕсли;
    Возврат СписокВозврата;
КонецФункции // ДатаКакМесяцПодобратьДатуПоТексту()

// Процедура обрабатывается событие "АвтоПодборТекста" для поля ввода текста с датой
// 
Процедура ДатаКакМесяцАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
    ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
    Если ДанныеВыбора.Количество() = 1 Тогда
        ТекстАвтоПодбора = ДанныеВыбора[0].Значение;
    КонецЕсли;
    СтандартнаяОбработка = Ложь;
КонецПроцедуры // ДатаКакМесяцАвтоПодборТекста()

// Процедура обрабатывается событие "ОкончаниеВводаТекста" для поля ввода текста с датой
//
Процедура ДатаКакМесяцОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
	Если ДанныеВыбора.Количество() = 1 Тогда
		Значение = Текст;
	Иначе
		Значение = ДанныеВыбора;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры // ДатаКакМесяцОкончаниеВводаТекста()

// Обработчики событий поля ввода.

Процедура ВводМесяцаПриИзменении(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, Модифицированность = Ложь) Экспорт
	
	ЗначениеПредставления = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления);
	Значение              = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	
	ДатаКакМесяцПодобратьДатуПоТексту(ЗначениеПредставления, Значение);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, РаботаСДиалогамиКлиентСервер.ПолучитьПредставлениеМесяца(Значение));
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
	
	Модифицированность = Истина;
	
КонецПроцедуры 

Процедура ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если Не ПустаяСтрока(Текст) Тогда
		ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если Текст <> "" Тогда
		ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВводМесяцаНачалоВыбора(Форма, РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, ИзменитьМодифицированность = Истина, ОповещениеЗавершения = Неопределено, ЗначениеМесяцаПоУмолчанию = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("РедактируемыйОбъект", РедактируемыйОбъект);
	ДополнительныеПараметры.Вставить("ПутьРеквизита", ПутьРеквизита);
	ДополнительныеПараметры.Вставить("ПутьРеквизитаПредставления", ПутьРеквизитаПредставления);
	ДополнительныеПараметры.Вставить("ИзменитьМодифицированность", ИзменитьМодифицированность);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	Если Значение <= '19000101' Тогда
		
		Если ЗначениеМесяцаПоУмолчанию = Неопределено Тогда
			Значение = НачалоМесяца(ОбщегоНазначенияКлиент.ДатаСеанса());
		Иначе
			Значение = НачалоМесяца(ЗначениеМесяцаПоУмолчанию);
		КонецЕсли;
		
	КонецЕсли; 
	
	ПараметрыФормы = Новый  Структура;
	ПараметрыФормы.Вставить("Значение"								 , Значение);
	ПараметрыФормы.Вставить("НачалоПериода"							 , НачалоМесяца(Значение));
	ПараметрыФормы.Вставить("КонецПериода"							 , КонецМесяца(Значение));
	ПараметрыФормы.Вставить("РежимВыбораПериода"					 , "Месяц");
	ПараметрыФормы.Вставить("ЗапрашиватьРежимВыбораПериодаУВладельца", Ложь);
	
	Оповещение = Новый ОписаниеОповещения("ВводМесяцаНачалоВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыФормы,
		Форма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ВводМесяцаНачалоВыбораЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт

	Форма = ДополнительныеПараметры.Форма;
	РедактируемыйОбъект = ДополнительныеПараметры.РедактируемыйОбъект;
	ПутьРеквизита = ДополнительныеПараметры.ПутьРеквизита;
	ПутьРеквизитаПредставления = ДополнительныеПараметры.ПутьРеквизитаПредставления;
	ИзменитьМодифицированность = ДополнительныеПараметры.ИзменитьМодифицированность;
	ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Ложь);
		КонецЕсли;
		
	Иначе
		
		Значение = ВыбранноеЗначение.НачалоПериода;
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
		Представление = РаботаСДиалогамиКлиентСервер.ПолучитьПредставлениеМесяца(Значение);
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, Представление);
		
		Если ИзменитьМодифицированность Тогда 
			Форма.Модифицированность = Истина;
		КонецЕсли;
		
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОповещениеЗавершения = Неопределено Тогда
		Форма.ОбновитьОтображениеДанных();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВводМесяцаРегулирование(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, Направление, Модифицированность = Ложь, ЗначениеМесяцаПоУмолчанию = Неопределено) Экспорт
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	
	Если Значение <= '19000101' Тогда
		
		Если ЗначениеМесяцаПоУмолчанию = Неопределено Тогда
			Значение = НачалоМесяца(ОбщегоНазначенияКлиент.ДатаСеанса());
		Иначе
			Значение = НачалоМесяца(ЗначениеМесяцаПоУмолчанию);
		КонецЕсли;
		
		НовоеЗначение = Значение;
		
	Иначе
		НовоеЗначение = ДобавитьМесяц(Значение, Направление);
	КонецЕсли; 
	
	Если НовоеЗначение >= '00010101' Тогда
		
		Значение = НовоеЗначение;
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, РаботаСДиалогамиКлиентСервер.ПолучитьПредставлениеМесяца(Значение));
		
		Модифицированность = Истина;
	 	
	КонецЕсли;
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////

Процедура ОткрытьФормуДополнительно(Форма, ТипОбъекта, СтруктураДополнительныхПараметров = Неопределено) Экспорт
	
	Объект = Форма.Объект;
	
	Если НЕ Форма.ТолькоПросмотр Тогда
		Форма.ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;

	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ДокументОснование",               Объект.ДокументОснование);
	СтруктураПараметров.Вставить("Ответственный",                   Объект.Ответственный);
	СтруктураПараметров.Вставить("ТолькоПросмотр",                  Форма.ТолькоПросмотр);
	СтруктураПараметров.Вставить("ТипОбъекта",                      ТипОбъекта);
	СтруктураПараметров.Вставить("Проведен",                        Объект.Проведен);
	СтруктураПараметров.Вставить("Ссылка",                          Объект.Ссылка);
	
	Если НЕ СтруктураДополнительныхПараметров = Неопределено Тогда
		Для Каждого ЭлементСтруктуры Из  СтруктураДополнительныхПараметров Цикл
			СтруктураПараметров.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение)
		КонецЦикла;
		
	КонецЕсли;
				     
	ОткрытьФорму("ОбщаяФорма.ФормаДополнительно", СтруктураПараметров, Форма);
	
КонецПроцедуры


#Область ФормаДополнительно

Процедура ОбработкаВыбораРеквизитыДополнительно(Форма, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Объект = Форма.Объект;

	ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	
	Если ВыбранноеЗначение.Свойство("ПерезаполнитьДокументПоОснованию") Тогда
		
		Если ВыбранноеЗначение.ПерезаполнитьДокументПоОснованию Тогда
			Форма.ПослеЗакрытияВопросаПриИзмененииДокументОснованиеНаСервере(); 											
		КонецЕсли; 
		
	КонецЕсли;
	
	Форма.Модифицированность = Истина;

КонецПроцедуры

#КонецОбласти

Процедура ОткрытьРеквизитыПечати(Форма, ТипОбъекта) Экспорт
	
	Объект = Форма.Объект;
	
	Если НЕ Форма.ТолькоПросмотр Тогда
		Форма.ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура();

	СтруктураПараметров.Вставить("Основание",                		Объект.Основание);
	СтруктураПараметров.Вставить("Приложение",                		Объект.Приложение);
	СтруктураПараметров.Вставить("СписокВыбораОснований",           Форма.СписокОснований);
	СтруктураПараметров.Вставить("ТипОбъекта",                      ТипОбъекта);
	СтруктураПараметров.Вставить("ТолькоПросмотр",                  Форма.ТолькоПросмотр);
	
	Если ТипОбъекта = "РасходныйКассовыйОрдер" Тогда
		СтруктураПараметров.Вставить("Выдать",              		Объект.Выдать);
		СтруктураПараметров.Вставить("ПоДокументу",                	Объект.ПоДокументу);
	ИначеЕсли ТипОбъекта = "ПриходныйКассовыйОрдер" Тогда	
		СтруктураПараметров.Вставить("ПринятоОт",              		Объект.ПринятоОт);
	КонецЕсли;

	ОткрытьФорму("ОбщаяФорма.РеквизитыПечатиКассовыхДокументов", СтруктураПараметров, Форма);
	
КонецПроцедуры

Процедура ОткрытьФормуКомиссияБанка(Форма, ТипОбъекта) Экспорт
	
	Объект = Форма.Объект;
	
	СтруктураПараметров = Новый Структура();
	// Реквизиты печати
	СтруктураПараметров.Вставить("ВключатьКомиссиюБанка", 			 Объект.ВключатьКомиссиюБанка);
	СтруктураПараметров.Вставить("ПроцентКомиссии", 				 Объект.ПроцентКомиссии);
	СтруктураПараметров.Вставить("СуммаКомиссии", 		 			 Объект.СуммаКомиссии);
	СтруктураПараметров.Вставить("СтатьяДвиженияДенежныхСредств",	 Объект.СтатьяДвиженияДенежныхСредств);
	СтруктураПараметров.Вставить("СчетУчетаРасчетовСКонтрагентомБУ", Объект.СчетУчетаРасчетовСКонтрагентомБУ);
	СтруктураПараметров.Вставить("СчетУчетаРасчетовСКонтрагентомНУ", Объект.СчетУчетаРасчетовСКонтрагентомНУ);
	СтруктураПараметров.Вставить("СубконтоДтБУ1",					 Объект.СубконтоДтБУ1);
	СтруктураПараметров.Вставить("СубконтоДтБУ2",					 Объект.СубконтоДтБУ2);
	СтруктураПараметров.Вставить("СубконтоДтБУ3",					 Объект.СубконтоДтБУ3);
	СтруктураПараметров.Вставить("СубконтоДтНУ1",					 Объект.СубконтоДтНУ1);
	СтруктураПараметров.Вставить("СубконтоДтНУ2",					 Объект.СубконтоДтНУ2);
	СтруктураПараметров.Вставить("СубконтоДтНУ3",					 Объект.СубконтоДтНУ3);
	
	
	// Дополнительные реквизиты 
	СтруктураПараметров.Вставить("ТолькоПросмотр",		 	 Форма.ТолькоПросмотр);
	СтруктураПараметров.Вставить("ЕстьРасшифровкаПлатежа",	 Форма.ЕстьРасшифровкаПлатежа);
	СтруктураПараметров.Вставить("Организация",		 		 Объект.Организация);
	СтруктураПараметров.Вставить("ВидОперации",		 		 Объект.ВидОперации);
	СтруктураПараметров.Вставить("СуммаДокумента",		     Объект.СуммаДокумента);
	СтруктураПараметров.Вставить("КурсДокумента",		     Форма.КурсДокумента);
	СтруктураПараметров.Вставить("ВидимостьНалоговогоУчета", Форма.ВидимостьНалоговогоУчета);
	СтруктураПараметров.Вставить("ВалютаДокумента",		 	 Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("СчетОрганизации",			 Объект.СчетОрганизации);
	СтруктураПараметров.Вставить("СтруктурноеПодразделениеОтправитель", Объект.СтруктурноеПодразделениеОтправитель);
	СтруктураПараметров.Вставить("ПоддержкаРаботыСоСтруктурнымиПодразделениями", Форма.ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	СтруктураПараметров.Вставить("Проведен",                 Объект.Проведен);
	СтруктураПараметров.Вставить("Ссылка",                   Объект.Ссылка);
	СтруктураПараметров.Вставить("НазначениеПлатежа",        Объект.НазначениеПлатежа);

	Если ТипОбъекта = "ПлатежноеПоручениеИсходящее" Тогда  
		СтруктураПараметров.Вставить("КодНазначенияПлатежа", Объект.КодНазначенияПлатежа);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаКомиссияБанка", СтруктураПараметров, Форма); 

КонецПроцедуры


