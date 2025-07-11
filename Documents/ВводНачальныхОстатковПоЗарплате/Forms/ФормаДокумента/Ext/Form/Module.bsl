﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	КонецЕсли;
		
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ЗаблокироватьРеквизиты(ЭтотОбъект, Объект.Проведен);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// РедактированиеДокументовПользователей
	ПраваДоступаКОбъектам.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец РедактированиеДокументовПользователей
	
	ПодготовитьФормуНаСервере();
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ЗаблокироватьРеквизиты(ЭтотОбъект, Объект.Проведен);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатковПоЗарплате");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБККлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБККлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);

	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		
		ДатаПриИзмененииНаСервере();
				
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьКПНПриИзменении(Элемент)
	
	УчитыватьКПНПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБухгалтерскомУчетеПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидУчетаНУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияБККлиент.НачалоВыбораЗначенияВидУчетаНУ(Элемент, Объект.ВидУчетаНУ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	Иначе 
		Результат = РаботаСДиалогамиКлиент.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение);
		Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
			СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(СтруктураПараметров = Неопределено)
	
	Если СтруктураПараметров = Неопределено 
		ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
				И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктураПараметров);
	КонецЕсли;
	
	ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		ПриИзмененииЗначенияОрганизацииСервер(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ЗарплатаИНалоги

&НаКлиенте
Процедура ЗарплатаИНалогиФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковСписокЗавершениеВыбора", ЭтотОбъект);

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаИНалогиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаВыбораНаКлиенте(ВыбранноеЗначение, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаИНалогиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные = Элементы.ЗарплатаИНалоги.ТекущиеДанные;
		ТекущиеДанные.ПериодРегистрации = НачалоМесяца(Объект.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаИНалогиПериодРегистрацииПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЗарплатаИНалоги.ТекущиеДанные;
	ТекущиеДанные.ПериодРегистрации = НачалоМесяца(ТекущиеДанные.ПериодРегистрации);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ВзносыИОтчисления

&НаКлиенте
Процедура ВзносыИОтчисленияФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковВзносыИОтчисленияСписокЗавершениеВыбора", ЭтотОбъект);

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура ВзносыИОтчисленияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаВыбораНаКлиенте(ВыбранноеЗначение, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВзносыИОтчисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные = Элементы.ВзносыИОтчисления.ТекущиеДанные;
		ТекущиеДанные.ПериодРегистрации = НачалоМесяца(Объект.Дата);
		ТекущиеДанные.ВидПлатежа 		= ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.Налог");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВзносыИОтчисленияПериодРегистрацииПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВзносыИОтчисления.ТекущиеДанные;
	ТекущиеДанные.ПериодРегистрации = НачалоМесяца(ТекущиеДанные.ПериодРегистрации);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ОПВПодлежитПеречислению

&НаКлиенте
Процедура ОПВПодлежитПеречислениюФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковОПВПодлежитПеречислениюСписокЗавершениеВыбора", ЭтотОбъект);

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура ОПВПодлежитПеречислениюОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаВыбораНаКлиенте(ВыбранноеЗначение, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОПВПодлежитПеречислениюПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные = Элементы.ОПВПодлежитПеречислению.ТекущиеДанные;
		ТекущиеДанные.ПериодРегистрации		= НачалоМесяца(Объект.Дата);
		ТекущиеДанные.МесяцВыплатыДоходов 	= НачалоМесяца(Объект.Дата);
		ТекущиеДанные.ВидПлатежа 			= ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.Налог");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОПВПодлежитПеречислениюПериодРегистрацииПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОПВПодлежитПеречислению.ТекущиеДанные;
	ТекущиеДанные.ПериодРегистрации = НачалоМесяца(ТекущиеДанные.ПериодРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОПВПодлежитПеречислениюМесяцВыплатыДоходовПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОПВПодлежитПеречислению.ТекущиеДанные;
	ТекущиеДанные.МесяцВыплатыДоходов = НачалоМесяца(ТекущиеДанные.МесяцВыплатыДоходов);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВзносыЗаполнитьПоДаннымБУ(Команда)
	
	СтруктураПоказателей = Новый Структура("ОПВРасчетыСБюджетом, СОРасчетыСФондами", "СуммаОПВ", "СуммаОС");	
	СтруктураСубконто    = Новый Структура("ВидПлатежа, ФизЛицо", "Субконто1", "Субконто2");
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПредопределенноеЗначение("ПланСчетов.Типовой.ОбязательстваПоПенсионнымОтчислениям"));
	МассивСчетов.Добавить(ПредопределенноеЗначение("ПланСчетов.Типовой.ОбязательстваПоСоциальномуСтрахованию"));
	
	Если Объект.ВзносыИОтчисления.Количество() > 0 Тогда
		
		ДопПараметры = Новый Структура("ИмяТабличнойЧасти, СтруктураПоказателей, СтруктураСубконто, МассивСчетов", "ВзносыИОтчисления", СтруктураПоказателей, СтруктураСубконто, МассивСчетов);
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоДаннымБУ", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);

	Иначе
		ЗаполнитьТабличнуюЧастьПоОстаткамБУНаСервере("ВзносыИОтчисления", СтруктураПоказателей, СтруктураСубконто, МассивСчетов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВзносыЗаполнитьПоРаботникам(Команда)
	
	ПередЗаполнениемТабличныйЧастей("ПоРаботникам", "ВзносыИОтчисления");
	
КонецПроцедуры

&НаКлиенте
Процедура ВзносыЗаполнитьПоФизЛицам(Команда)
	
	ПередЗаполнениемТабличныйЧастей("ПоФизЛицам", "ВзносыИОтчисления");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаЗаполнитьПоДаннымБУ(Команда)
	
	СтруктураПоказателей = Новый Структура("ВзаиморасчетыСРаботниками, ВзаиморасчетыСДепонентами", "СуммаЗП", "СуммаДепонентов");	
	СтруктураСубконто    = Новый Структура("ФизЛицо", "Субконто1");
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПредопределенноеЗначение("ПланСчетов.Типовой.КраткосрочнаяЗадолженностьПоОплатеТруда"));
	МассивСчетов.Добавить(ПредопределенноеЗначение("ПланСчетов.Типовой.КраткосрочнаяЗадолженностьПоДепонированнойЗаработнойПлате"));
	
	Если Объект.ЗарплатаИНалоги.Количество() > 0 Тогда
		
		ДопПараметры = Новый Структура("ИмяТабличнойЧасти, СтруктураПоказателей, СтруктураСубконто, МассивСчетов", "ЗарплатаИНалоги", СтруктураПоказателей, СтруктураСубконто, МассивСчетов);
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоДаннымБУ", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);

	Иначе
		ЗаполнитьТабличнуюЧастьПоОстаткамБУНаСервере("ЗарплатаИНалоги", СтруктураПоказателей, СтруктураСубконто, МассивСчетов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаЗаполнитьПоРаботникам(Команда)
	
	ПередЗаполнениемТабличныйЧастей("ПоРаботникам", "ЗарплатаИНалоги");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаЗаполнитьПоФизЛицам(Команда)

	ПередЗаполнениемТабличныйЧастей("ПоФизЛицам", "ЗарплатаИНалоги");
	
КонецПроцедуры

&НаКлиенте
Процедура ОПВЗаполнитьПоДаннымБУ(Команда)
	
	Если Объект.ОПВПодлежитПеречислению.Количество() > 0 Тогда

		ДопПараметры = Новый Структура("ОчиститьТабличнуюЧасть", Истина);
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоДаннымБУОПВ", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим);
		
	Иначе
		
		ПослеЗакрытияВопросаЗаполнитьПоДаннымБУОПВ(КодВозвратаДиалога.Да, Новый Структура);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОПВЗаполнитьПоРаботникам(Команда)
	
	ПередЗаполнениемТабличныйЧастей("ПоРаботникам", "ОПВПодлежитПеречислению");
	
КонецПроцедуры

&НаКлиенте
Процедура ОПВЗаполнитьПоФизЛицам(Команда)
	
	ПередЗаполнениемТабличныйЧастей("ПоФизЛицам", "ОПВПодлежитПеречислению");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборВзносы(Команда)

	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элементы.ВзносыИОтчисления, , , ,,Режим)

КонецПроцедуры

&НаКлиенте
Процедура ПодборЗарплата(Команда)

	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элементы.ЗарплатаИНалоги, , , ,,Режим)

КонецПроцедуры

&НаКлиенте
Процедура ПодборОПВ(Команда)

	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;

	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элементы.ОПВПодлежитПеречислению, , , ,,Режим)

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура РазблокироватьРеквизиты() Экспорт
	
	Элементы.ЗарплатаИНалоги.ТолькоПросмотр       = Ложь;
	Элементы.ЗарплатаИНалоги.ИзменятьСоставСтрок  = Ложь;
	Элементы.ЗарплатаИНалоги.ИзменятьПорядокСтрок = Ложь;
	
	Элементы.ВзносыИОтчисления.ТолькоПросмотр           = Ложь;
	Элементы.ВзносыИОтчисления.ИзменятьСоставСтрок      = Ложь;
	Элементы.ВзносыИОтчисления.ИзменятьПорядокСтрок     = Ложь;

	Элементы.ОПВПодлежитПеречислению.ТолькоПросмотр          = Ложь;
	Элементы.ОПВПодлежитПеречислению.ИзменятьСоставСтрок     = Ложь;
	Элементы.ОПВПодлежитПеречислению.ИзменятьПорядокСтрок    = Ложь;
	
КонецПроцедуры

&НаСервере
Функция РеквизитыЗаблокированы()
	
	Возврат ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭтотОбъект, "ПараметрыЗапретаРедактированияРеквизитов");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.УчитыватьКПН.Видимость	= Форма.ОрганизацияПлательщикНалогаНаПрибыль;
	Элементы.ВидУчетаНУ.Видимость   = Объект.УчитыватьКПН;
	
	// Доступность взаимосвязанных полей
	Элементы.ГруппаОПВПодлежитПеречислению.Видимость = Объект.ОтражатьВБухгалтерскомУчете;
	Элементы.ЗарплатаИНалогиЗарплатаЗаполнитьПоДаннымБУ.Доступность = Объект.УчитыватьКПН И НЕ Объект.ОтражатьВБухгалтерскомУчете;
	Элементы.ВзносыИОтчисленияВзносыЗаполнитьПоДаннымБУ.Доступность = Объект.УчитыватьКПН И НЕ Объект.ОтражатьВБухгалтерскомУчете;
	
	Элементы.Дата.ТолькоПросмотр = Форма.ОткрытиеИзОбработкиВводаНачальныхОстатков;
	Элементы.СтруктурноеПодразделениеОрганизация.ТолькоПросмотр = Форма.ОткрытиеИзОбработкиВводаНачальныхОстатков;

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();

	ТекущаяДатаДокумента = Объект.Дата;

	ОрганизацияПлательщикНалогаНаПрибыль = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ОрганизацияЯвляетсяВкладчикомОППВ = ПроцедурыНалоговогоУчета.ПолучитьПризнакВкладчикаПрофПенсионныхВзносов(Объект.Организация, Объект.Дата);
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	РаботаСДиалогами.УстановитьЗаголовокЭлементуУправленияУчитыватьКПН(Объект.Организация, Элементы.УчитыватьКПН);
	
	Если ТипЗнч(Параметры) = Тип("ДанныеФормыСтруктура") Тогда
		Параметры.Свойство("ОткрытиеИзОбработкиВводаНачальныхОстатков", ОткрытиеИзОбработкиВводаНачальныхОстатков);
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);
	
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры 

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	ОрганизацияПлательщикНалогаНаПрибыль = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ОрганизацияЯвляетсяВкладчикомОППВ 	 = ПроцедурыНалоговогоУчета.ПолучитьПризнакВкладчикаПрофПенсионныхВзносов(Объект.Организация, Объект.Дата);

	ПроцедурыНалоговогоУчета.ПриИзмененииПризнакаОтраженияВНалоговомУчете(Объект.Организация, Объект.Дата, Объект.УчитыватьКПН, Истина);
	ПроцедурыНалоговогоУчета.ЗаполнитьВидУчетаНУ(Объект.УчитыватьКПН, Объект.ВидУчетаНУ);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров)
	
	Если НЕ СтруктураПараметров.ИзмененаОрганизация И НЕ СтруктураПараметров.ИзмененоСтруктурноеПодразделение Тогда
		Возврат;
	КонецЕсли;

	ОрганизацияПлательщикНалогаНаПрибыль = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ОрганизацияЯвляетсяВкладчикомОППВ    = ПроцедурыНалоговогоУчета.ПолучитьПризнакВкладчикаПрофПенсионныхВзносов(Объект.Организация, Объект.Дата);

	РаботаСДиалогами.ПроверитьСоответствиеПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, Объект.ПодразделениеОрганизации);
	
	УстановитьФункциональныеОпцииФормы();
	РаботаСДиалогами.ПриИзмененииЗначенияОрганизации(Объект);
	ПроцедурыНалоговогоУчета.ПриИзмененииПризнакаОтраженияВНалоговомУчете(Объект.Организация, Объект.Дата, Объект.УчитыватьКПН, Истина);		
	ПроцедурыНалоговогоУчета.ЗаполнитьВидУчетаНУ(Объект.УчитыватьКПН, Объект.ВидУчетаНУ);

	РаботаСДиалогами.УстановитьЗаголовокЭлементуУправленияУчитыватьКПН(Объект.Организация, Элементы.УчитыватьКПН);

КонецПроцедуры

&НаСервере
Процедура УчитыватьКПНПриИзмененииНаСервере()
	
	ПроцедурыНалоговогоУчета.ЗаполнитьВидУчетаНУ(Объект.УчитыватьКПН, Объект.ВидУчетаНУ);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаполнениемТабличныйЧастей(СпособЗаполнения, ИмяТабличнойЧасти)

	ДопПараметры = Новый Структура("СпособЗаполнения, ИмяТабличнойЧасти", СпособЗаполнения, ИмяТабличнойЧасти);

	Если Объект.Проведен Тогда
		
		ТекстВопроса = НСтр("ru='Автоматически заполнить документ можно только после отмены его проведения. Выполнить отмену проведения документа?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаИзменениеВидаОперацииОчиститьТабЧасти", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	ИначеЕсли Модифицированность ИЛИ Объект.Ссылка.Пустая() Тогда
		
		ТекстВопроса = НСтр("ru='Автоматически заполнить документ можно только после его записи. Записать?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаИзменениеВидаОперацииОчиститьТабЧасти", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаИзменениеВидаОперацииОчиститьТабЧасти(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

	Если Объект.Проведен Тогда
		
		ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
		
	ИначеЕсли Модифицированность ИЛИ Объект.Ссылка.Пустая() Тогда
		
		ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));
		
	КонецЕсли;

	Если Объект[Параметры.ИмяТабличнойЧасти].Количество() > 0 Тогда
	
		ТекстВопроса = НСтр("ru = 'Очистить перед заполнением существующие данные?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчиститьПередЗаполнением", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим);
		
	Иначе
		
		АвтозаполнениеНаСервере(Параметры.СпособЗаполнения, Параметры.ИмяТабличнойЧасти);
		
		Если Объект[Параметры.ИмяТабличнойЧасти].Количество() = 0 Тогда
			
			ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличные части документа'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
			
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОчиститьПередЗаполнением(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

	Объект[Параметры.ИмяТабличнойЧасти].Очистить();
	ЭтотОбъект.Записать();
	
	АвтозаполнениеНаСервере(Параметры.СпособЗаполнения, Параметры.ИмяТабличнойЧасти);
	
	Если Объект[Параметры.ИмяТабличнойЧасти].Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличные части документа'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаполнитьПоДаннымБУ(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект[Параметры.ИмяТабличнойЧасти].Очистить();
	ЗаполнитьТабличнуюЧастьПоОстаткамБУНаСервере(Параметры.ИмяТабличнойЧасти, Параметры.СтруктураПоказателей, Параметры.СтруктураСубконто, Параметры.МассивСчетов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаполнитьПоДаннымБУОПВ(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

	Если Параметры.Свойство("ОчиститьТабличнуюЧасть") И Параметры.ОчиститьТабличнуюЧасть Тогда
		Объект.ОПВПодлежитПеречислению.Очистить();	
	КонецЕсли;
	
	// копируем все строки из табл. части ВзносыИОтчисления в табл. часть ОПВПодлежитПеречислению
	Для Каждого СтрокаВзносов Из Объект.ВзносыИОтчисления Цикл
		Если (СтрокаВзносов.ОПВРасчетыСБюджетом <> 0)
				И (СтрокаВзносов.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.Налог")
				ИЛИ СтрокаВзносов.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.НалогАкт")
				ИЛИ СтрокаВзносов.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.НалогСам")) Тогда
						
			НоваяСтрока 								= Объект.ОПВПодлежитПеречислению.Добавить();
			НоваяСтрока.ФизЛицо 						= СтрокаВзносов.ФизЛицо;
			НоваяСтрока.ПериодРегистрации   			= СтрокаВзносов.ПериодРегистрации;
			НоваяСтрока.МесяцВыплатыДоходов				= СтрокаВзносов.ПериодРегистрации;
			НоваяСтрока.ВидПлатежа						= СтрокаВзносов.ВидПлатежа;
			НоваяСтрока.ОПВПодлежитПеречислениюВФонды	= СтрокаВзносов.ОПВРасчетыСБюджетом;
			
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьПоОстаткамБУНаСервере(ИмяТабличнойЧасти, СтруктураПоказателей, СтруктураСубконто, МассивСчетов) 
	
	Документы.ВводНачальныхОстатковПоЗарплате.ЗаполнитьТабличнуюЧастьПоОстаткамБУ(Объект, ИмяТабличнойЧасти, СтруктураПоказателей, СтруктураСубконто, МассивСчетов);

КонецПроцедуры

&НаСервере
Процедура АвтозаполнениеНаСервере(СпособЗаполнения, ИмяТабличнойЧасти) 
	
	Документы.ВводНачальныхОстатковПоЗарплате.Автозаполнение(Объект, СпособЗаполнения, ИмяТабличнойЧасти);

КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.ЗарплатаИНалоги.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.ФизЛицо =ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковВзносыИОтчисленияСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.ВзносыИОтчисления.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.ФизЛицо =ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковОПВПодлежитПеречислениюСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.ОПВПодлежитПеречислению.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.ФизЛицо =ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура  ОбработкаВыбораНаКлиенте(ВыбранноеЗначение, ИмяЭлементФормы)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ФизическиеЛица")Тогда
		
		Если ИмяЭлементФормы = Неопределено ИЛИ ИмяЭлементФормы = "ЗарплатаИНалоги" Тогда
			Если Объект.ЗарплатаИНалоги.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение)).Количество() = 0 Тогда
				НоваяСтрока 						= Объект.ЗарплатаИНалоги.Добавить();	
				НоваяСтрока.ФизЛицо 				= ВыбранноеЗначение;
				НоваяСтрока.ПериодРегистрации 	= НачалоМесяца(Объект.Дата);		
			КонецЕсли;	
		КонецЕсли;
		
		Если ИмяЭлементФормы = Неопределено ИЛИ ИмяЭлементФормы = "ВзносыИОтчисления" Тогда
			Если Объект.ВзносыИОтчисления.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение)).Количество() = 0 Тогда
				НоваяСтрока 					= Объект.ВзносыИОтчисления.Добавить();	
				НоваяСтрока.ФизЛицо 			= ВыбранноеЗначение;
				НоваяСтрока.ПериодРегистрации 	= НачалоМесяца(Объект.Дата);
				НоваяСтрока.ВидПлатежа 			= ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.Налог");
			КонецЕсли;	
		КонецЕсли;
		
		Если ИмяЭлементФормы = Неопределено ИЛИ ИмяЭлементФормы = "ОПВПодлежитПеречислению" Тогда
			Если Объект.ОПВПодлежитПеречислению.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение)).Количество() = 0 Тогда
				НоваяСтрока 					= Объект.ОПВПодлежитПеречислению.Добавить();	
				НоваяСтрока.ФизЛицо 			= ВыбранноеЗначение;
				НоваяСтрока.ПериодРегистрации 	= НачалоМесяца(Объект.Дата);
				НоваяСтрока.МесяцВыплатыДоходов = НачалоМесяца(Объект.Дата);
				НоваяСтрока.ВидПлатежа 			= ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.Налог");
			КонецЕсли;	
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
			
			Если ИмяЭлементФормы = Неопределено ИЛИ ИмяЭлементФормы = "ЗарплатаИНалоги" Тогда
				Если Объект.ЗарплатаИНалоги.НайтиСтроки(Новый Структура("ФизЛицо", СтрокаМассива)).Количество() = 0 Тогда
					НоваяСтрока 						= Объект.ЗарплатаИНалоги.Добавить();	
					НоваяСтрока.ФизЛицо 				= СтрокаМассива;
					НоваяСтрока.ПериодРегистрации 	= НачалоМесяца(Объект.Дата);		
				КонецЕсли;	
			КонецЕсли;
			
			Если ИмяЭлементФормы = Неопределено ИЛИ ИмяЭлементФормы = "ВзносыИОтчисления" Тогда
				Если Объект.ВзносыИОтчисления.НайтиСтроки(Новый Структура("ФизЛицо", СтрокаМассива)).Количество() = 0 Тогда
					НоваяСтрока 					= Объект.ВзносыИОтчисления.Добавить();	
					НоваяСтрока.ФизЛицо 			= СтрокаМассива;
					НоваяСтрока.ПериодРегистрации 	= НачалоМесяца(Объект.Дата);
					НоваяСтрока.ВидПлатежа 			= ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.Налог");
				КонецЕсли;	
			КонецЕсли;
			
			Если ИмяЭлементФормы = Неопределено ИЛИ ИмяЭлементФормы = "ОПВПодлежитПеречислению" Тогда
				Если Объект.ОПВПодлежитПеречислению.НайтиСтроки(Новый Структура("ФизЛицо", СтрокаМассива)).Количество() = 0 Тогда
					НоваяСтрока 					= Объект.ОПВПодлежитПеречислению.Добавить();	
					НоваяСтрока.ФизЛицо 			= СтрокаМассива;
					НоваяСтрока.ПериодРегистрации 	= НачалоМесяца(Объект.Дата);
					НоваяСтрока.МесяцВыплатыДоходов = НачалоМесяца(Объект.Дата);
					НоваяСтрока.ВидПлатежа 			= ПредопределенноеЗначение("Перечисление.ВидыПлатежейВБюджетИФонды.Налог");
				КонецЕсли;	
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	


