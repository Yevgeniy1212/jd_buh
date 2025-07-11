﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПодготовитьФормуНаСервере();		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если  ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.НоменклатураГСВС.Форма.ФормаВыбора") Тогда
		
		УстановитьКодТНВЭД(ВыбранноеЗначение);
		ДобавитьИнформациюОНоменклатуреГСВС();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НачальныйКодПриИзменении(Элемент)
	УстановитьКонечныйКод(НачальныйКод, КонечныйКод, Количество);
КонецПроцедуры

&НаКлиенте
Процедура НачальныйКодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Направление = 1 И НЕ ЗначениеЗаполнено(НачальныйКод) Тогда
		НачальныйКод = 1;		
	Иначе
		НачальныйКод = УвеличитьКодНаСервере(НачальныйКод, Направление);		
	КонецЕсли;
	
	УстановитьКонечныйКод(НачальныйКод, КонечныйКод, Количество);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	УстановитьКонечныйКод(НачальныйКод, КонечныйКод, Количество);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	НовоеЗначение = Количество + Направление;
	ЧисловаяЧасть = ПолучитьЧисловуюЧастьНаСервере(НачальныйКод);
	
	Если ЗначениеЗаполнено(ЧисловаяЧасть) И Направление = 1 Тогда
		СтандартнаяОбработка = (НовоеЗначение <= МаксимумСоздаваемыхОбъектов(ЧисловаяЧасть));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ПустаяСтрока(НаименованиеПолное) Тогда
		НаименованиеПолное = Наименование;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДПриИзменении(Элемент)
	
	ОбновитьПредставлениеЭлемента("КодСтрокиТНВЭД");
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ТипКодаГСВС", ПредопределенноеЗначение("Перечисление.ТипыКодовГСВС.ТНВЭД"));
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыФормы.Вставить("ТекущийКодТНВЭД", ?(НЕ ЗначениеЗаполнено(КодТНВЭД), Неопределено, СокрЛП(КодТНВЭД)));
	
	ОткрытьФорму("Справочник.НоменклатураГСВС.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, Истина);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Добавить(Команда)
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(НачальныйКод) Тогда
		ТекстСообщения = НСтр("ru='Не заполнено поле ""Присваивать коды, начиная с"".'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "НачальныйКод"); 
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Количество) Тогда
		ТекстСообщения = НСтр("ru='Не заполнено поле ""Количество создаваемых объектов"".'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Количество");
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		ТекстСообщения = НСтр("ru='Не заполнено поле ""Наименование"".'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Наименование");
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЧисловаяЧасть = ПолучитьЧисловуюЧастьНаСервере(НачальныйКод);
	
	Если НЕ ЗначениеЗаполнено(ЧисловаяЧасть) Тогда
		ТекстСообщения = НСтр("ru='Начальный код, указанный в поле ""Присваивать коды с:"", не содержит числовой части.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "НачальныйКод"); 
		Возврат;
	КонецЕсли;
	
	Если Количество > МаксимумСоздаваемыхОбъектов(ЧисловаяЧасть) Тогда
		ТекстСообщения = НСтр("ru='Введенное количество объектов превышает допустимое исходя из заданной разрядности начального номера.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Количество");
		Возврат;
	КонецЕсли;
	
	Элементы.ОжиданиеОбработки.Видимость = Истина;
	Элементы.ГруппаПараметры.Видимость   = Ложь;
	
	ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаДобавить.Видимость = Ложь;
	ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаЗакрыть.Видимость  = Ложь;
	
	ПодключитьОбработчикОжидания("ПерейтиНаСтраницуИзмененияОбъектов", 0.1, Истина);
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	НовыйЭлемент = Справочники.ОсновныеСредства.СоздатьЭлемент();
	НовыйЭлемент.УстановитьНовыйКод();
	
	НачальныйКод = НовыйЭлемент.Код;
    УстановитьКонечныйКод(НачальныйКод, КонечныйКод, Количество);
	
	Если НЕ (Параметры.ОсновноеСредство = Неопределено) И (ТипЗнч(Параметры.ОсновноеСредство) = Тип("СправочникСсылка.ОсновныеСредства")) Тогда
		Группа = Параметры.ОсновноеСредство.Родитель;
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаПараметры;
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьКонечныйКод(НачальныйКод, КонечныйКод, КоличествоОбъектов)
	
	ЧисловаяЧасть = Справочники.ОсновныеСредства.ПолучитьЧисловуюЧасть(НачальныйКод);
	
	Если НЕ ЗначениеЗаполнено(НачальныйКод) 
	 ИЛИ НЕ ЗначениеЗаполнено(ЧисловаяЧасть)
	 ИЛИ КоличествоОбъектов <= 0 
	 ИЛИ КоличествоОбъектов > МаксимумСоздаваемыхОбъектов(ЧисловаяЧасть) Тогда
		
		КонечныйКод = "";
		Возврат;
		
	КонецЕсли;
	
	КонечныйКод = Справочники.ОсновныеСредства.УвеличитьКод(НачальныйКод, КоличествоОбъектов - 1);
			
КонецПроцедуры

&НаСервереБезКонтекста
Функция МаксимумСоздаваемыхОбъектов(ЧисловаяЧасть)
	
	Если ЗначениеЗаполнено(ЧисловаяЧасть) Тогда
		Возврат Pow(10, СтрДлина(ЧисловаяЧасть)) - Число(ЧисловаяЧасть);
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиНаСтраницуИзмененияОбъектов()
	
	ДобавитьНаСервере();
	
	Если РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
		ПоказатьСообщениеОЗавершении();
	Иначе
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеИзменения", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ДобавитьНаСервере()
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Количество",         Количество);
	СтруктураПараметров.Вставить("НачальныйКод",       НачальныйКод);
	СтруктураПараметров.Вставить("Родитель",           Группа);
	СтруктураПараметров.Вставить("Наименование",       Наименование);
	СтруктураПараметров.Вставить("НаименованиеПолное", НаименованиеПолное);
	СтруктураПараметров.Вставить("Изготовитель",       Изготовитель);
	СтруктураПараметров.Вставить("ЗаводскойНомер",     ЗаводскойНомер);
	СтруктураПараметров.Вставить("НомерПаспорта",      НомерПаспорта);
	СтруктураПараметров.Вставить("ДатаВыпуска",        ДатаВыпуска);
	СтруктураПараметров.Вставить("ГруппаОС",           ГруппаОС);
	СтруктураПараметров.Вставить("Автотранспорт",      Автотранспорт);
	СтруктураПараметров.Вставить("КодКОФ",             КодКОФ);
	СтруктураПараметров.Вставить("КодТНВЭД",           КодТНВЭД);
	
	НаименованиеЗадания = НСтр("ru = 'Групповое создание элементов'");
		
	ВыполняемыйМетод = "Справочники.ОсновныеСредства.ВыполнитьСозданиеОбъектов";
	СтруктураПараметров = Новый Структура("ИмяОбработки, ИмяМетода, ПараметрыВыполнения, ЭтоВнешняяОбработка, ДополнительнаяОбработкаСсылка",
		"ОсновныеСредства", "ВыполнитьСозданиеОбъектов", СтруктураПараметров, Ложь, "");
		
	РезультатФоновогоЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			ВыполняемыйМетод,
			СтруктураПараметров, 
			НаименованиеЗадания);
		
КонецПроцедуры 

&НаКлиенте
Процедура ПроверитьВыполнениеИзменения()
	
	Попытка
		РезультатФоновогоЗадания.ЗаданиеВыполнено = ЗаданиеВыполнено(РезультатФоновогоЗадания.ИдентификаторЗадания);
	Исключение
		ПерейтиНаСтраницуИзмененияОбъектов();
		ВызватьИсключение;
	КонецПопытки;
	
	Если РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
		ПоказатьСообщениеОЗавершении();
	Иначе
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеИзменения", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура ПоказатьСообщениеОЗавершении()
	
	Элементы.ОжиданиеОбработки.Видимость = Ложь;
	Элементы.ГруппаПараметры.Видимость   = Истина;
	
	ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаДобавить.Видимость = Истина;
	ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаЗакрыть.Видимость  = Истина;
	
	ТекстСообщения = НСтр("ru='Создание основных средств завершено'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
	Этаформа.ВладелецФормы.Элементы.Список.Обновить();
	
КонецПроцедуры

 &НаСервереБезКонтекста
Функция УвеличитьКодНаСервере(НачальныйКод, Направление)
 	Возврат Справочники.ОсновныеСредства.УвеличитьКод(НачальныйКод, Направление);
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЧисловуюЧастьНаСервере(НачальныйКод)
	Возврат Справочники.ОсновныеСредства.ПолучитьЧисловуюЧасть(НачальныйКод);
КонецФункции

&НаСервере
Процедура ОбновитьПредставлениеЭлемента(ИмяОбновляемогоЭлемента)
	
	Если ИмяОбновляемогоЭлемента = "КодСтрокиТНВЭД" Тогда
		
		Если ПустаяСтрока(СтрЗаменить(КодТНВЭД, ".", "")) Тогда
			Элементы.ДекорацияРасшифровкаКодСтрокиТНВЭД.Заголовок = НСтр("ru ='<не указано>'");
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = "";
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Видимость = Ложь;
			Элементы.ДекорацияПереченьИзъятия.Заголовок = "";
			Элементы.ДекорацияПереченьИзъятия.Видимость = Ложь;
			Элементы.ДекорацияУникальныйТовар.Заголовок = "";
			Элементы.ДекорацияУникальныйТовар.Видимость = Ложь;
			Элементы.ДекорацияТоварДвойногоНазначения.Заголовок = "";
			Элементы.ДекорацияТоварДвойногоНазначения.Видимость = Ложь;
		Иначе
			ДобавитьИнформациюОНоменклатуреГСВС();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьИнформациюОНоменклатуреГСВС() 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.УстановитьПараметр("КодТНВЭД", КодТНВЭД);
	
	Запрос.Текст = "ВЫБРАТЬ
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакУчетаНаВиртуальномСкладе КАК ПризнакУчетаНаВиртуальномСкладе,
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакТовараДвойногоНазначения КАК ПризнакТовараДвойногоНазначения,
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакУникальногоТовара КАК ПризнакУникальногоТовара,
		|	СведенияОНоменклатуреГСВССрезПоследних.ПризнакПеречняИзьятий КАК ПризнакПеречняИзьятий,
		|	СпрНоменклатураГСВС.КодГСВС КАК КодТНВЭД,
		|	СпрНоменклатураГСВС.ПолноеНаименованиеRu КАК ПолноеНаименование
		|ИЗ
		|	РегистрСведений.СведенияОНоменклатуреГСВС.СрезПоследних(&Дата, ) КАК СведенияОНоменклатуреГСВССрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураГСВС КАК СпрНоменклатураГСВС
		|		ПО СведенияОНоменклатуреГСВССрезПоследних.НоменклатураГСВС = СпрНоменклатураГСВС.Ссылка
		|ГДЕ
		|	СпрНоменклатураГСВС.КодГСВС = &КодТНВЭД
		|	И СпрНоменклатураГСВС.ТипКодаГСВС = ЗНАЧЕНИЕ(Перечисление.ТипыКодовГСВС.ТНВЭД)";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.ПризнакУчетаНаВиртуальномСкладе Тогда
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = НСтр("ru ='Товар ВС;'");
		Иначе
			Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = "";
		КонецЕсли;
		Элементы.ДекорацияВедетсяУчетПоТоварамВС.Видимость = НЕ (Элементы.ДекорацияВедетсяУчетПоТоварамВС.Заголовок = "");
		Если Выборка.ПризнакПеречняИзьятий Тогда
			Элементы.ДекорацияПереченьИзъятия.Заголовок = НСтр("ru ='Товар входит в перечень изъятий;'");
		Иначе
			Элементы.ДекорацияПереченьИзъятия.Заголовок = "";
		КонецЕсли;
		Элементы.ДекорацияПереченьИзъятия.Видимость = НЕ (Элементы.ДекорацияПереченьИзъятия.Заголовок = "");
		Если Выборка.ПризнакУникальногоТовара Тогда
			Элементы.ДекорацияУникальныйТовар.Заголовок = НСтр("ru ='Уникальный товар'");
		Иначе
			Элементы.ДекорацияУникальныйТовар.Заголовок = "";
		КонецЕсли;
		Элементы.ДекорацияУникальныйТовар.Видимость = НЕ (Элементы.ДекорацияУникальныйТовар.Заголовок = "");
		Если Выборка.ПризнакТовараДвойногоНазначения Тогда
			Элементы.ДекорацияТоварДвойногоНазначения.Заголовок = НСтр("ru ='Экспортный контроль'");
		Иначе
			Элементы.ДекорацияТоварДвойногоНазначения.Заголовок = "";
		КонецЕсли;
		Элементы.ДекорацияТоварДвойногоНазначения.Видимость = НЕ (Элементы.ДекорацияТоварДвойногоНазначения.Заголовок = "");
		Если ПустаяСтрока(Выборка.ПолноеНаименование) Тогда
			Элементы.ДекорацияРасшифровкаКодСтрокиТНВЭД.Заголовок = СтрШаблон(НСтр("ru ='строка с кодом %1 не найдена.'"),СокрЛП(КодТНВЭД));
		Иначе
			Элементы.ДекорацияРасшифровкаКодСтрокиТНВЭД.Заголовок = Выборка.ПолноеНаименование;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКодТНВЭД(НомеклатураГСВС)
	
	КодТНВЭД = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НомеклатураГСВС, "КодГСВС");
	
КонецПроцедуры
