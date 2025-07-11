﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;
	
	РодительПерсональныхГруппДоступа = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа(Истина);
	
	УпрощенныйИнтерфейсНастройкиПравДоступа = УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
	
	Если УпрощенныйИнтерфейсНастройкиПравДоступа и ПравоДоступа("Добавление",Метаданные.Справочники.ГруппыДоступа) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ФормаСоздать", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"СписокКонтекстноеМенюСоздать", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ФормаСкопировать", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"СписокКонтекстноеМенюСкопировать", "Видимость", Ложь);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Профиль", Параметры.Профиль);
	Если ЗначениеЗаполнено(Параметры.Профиль) Тогда
		Элементы.Профиль.Видимость = Ложь;
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		Автозаголовок = Ложь;
		
		Заголовок = НСтр("ru = 'Группы доступа'");
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ФормаСоздатьГруппу", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"СписокКонтекстноеМенюСоздатьГруппу", "Видимость", Ложь);
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Справочники.ПрофилиГруппДоступа) Тогда
		Элементы.Профиль.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		// Скрытие группы доступа Администраторы.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", УправлениеДоступом.ГруппаДоступаАдминистраторы(),
			ВидСравненияКомпоновкиДанных.НеРавно, , Истина);
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;
	
	Если Параметры.РежимВыбора Тогда
		
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		Элементы.Список.ВыборГруппИЭлементов = Параметры.ВыборГруппИЭлементов;
		
		АвтоЗаголовок = Ложь;
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
			
			Заголовок = НСтр("ru = 'Подбор групп доступа'");
		Иначе
			Заголовок = НСтр("ru = 'Выбор группы доступа'");
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	СписокПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Не СтандартныеПодсистемыКлиент.ЭтоЭлементДинамическогоСписка(Элементы.Список) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ТекущиеДанныеТаблицы(Элементы.Список);
	ПереносДопустим = НЕ ЗначениеЗаполнено(ТекущиеДанные.Пользователь)
	                  И ТекущиеДанные.Ссылка <> РодительПерсональныхГруппДоступа;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ФормаПеренестиЭлемент", "Доступность", ПереносДопустим);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"СписокКонтекстноеМенюПеренестиЭлемент", "Доступность", ПереносДопустим);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"СписокПеренестиЭлемент", "Доступность", ПереносДопустим);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Значение = РодительПерсональныхГруппДоступа Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru = 'Эта группа только для персональных групп доступа.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Родитель = РодительПерсональныхГруппДоступа Тогда
		
		Отказ = Истина;
		
		Если Группа Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'В этой группе не используются подгруппы.'"));
			
		ИначеЕсли УпрощенныйИнтерфейсНастройкиПравДоступа Тогда
			ПоказатьПредупреждение(,
				НСтр("ru = 'Персональные группы доступа
				           |создаются только в форме ""Права доступа"".'"));
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Персональные группы доступа не используются.'"));
		КонецЕсли;
		
	ИначеЕсли НЕ Группа
	        И УпрощенныйИнтерфейсНастройкиПравДоступа Тогда
		
		Отказ = Истина;
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Используются только персональные группы доступа,
			           |которые создаются только в форме ""Права доступа"".'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
	 Или ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.ГруппыДоступа.ФормаОбъекта", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для Каждого Строка Из Строки Цикл
		Если ТипЗнч(Строка.Ключ) <> Тип("СправочникСсылка.ГруппыДоступа") Тогда
			Продолжить;
		КонецЕсли;
		Данные = Строка.Значение.Данные;
		
		Если Данные.ЭтоГруппа
		 Или Не ЗначениеЗаполнено(Данные.Пользователь) Тогда
			Продолжить;
		КонецЕсли;
		
		Данные.Наименование =
			УправлениеДоступомСлужебныйКлиентСервер.ПредставлениеГруппыДоступа(Данные);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Строка = РодительПерсональныхГруппДоступа Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru = 'Эта папка только для персональных групп доступа.'"));
		
	ИначеЕсли ПараметрыПеретаскивания.Значение = РодительПерсональныхГруппДоступа Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru = 'Папка персональных групп доступа не переносится.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриИзмененииНаСервере()
	
	УправлениеДоступомСлужебный.ЗапуститьОбновлениеДоступа();
	
КонецПроцедуры

// Параметры:
//  ТаблицаФормы - ДанныеФормыКоллекция
// 
// Возвращаемое значение:
//  ДанныеФормыСтруктура:
//   * Ссылка - СправочникСсылка.ГруппыДоступа
//   * Пользователь - СправочникСсылка.Пользователи
//                  - СправочникСсылка.ВнешниеПользователи
//
&НаКлиенте
Функция ТекущиеДанныеТаблицы(ТаблицаФормы)
	Возврат ТаблицаФормы.ТекущиеДанные;
КонецФункции

#КонецОбласти
