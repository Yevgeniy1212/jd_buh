﻿#Область ОписаниеПеременных

&НаКлиенте
Перем СтрокаРодителя, РазрешитьДобавлениеНовойСтроки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Объект.ТаблицаТребований.Количество() = 0 Тогда
			ИнициализироватьДерево();
		Иначе 
			ЭлектронноеВзаимодействиеСлужебный.ЗаполнитьДеревоМаршрутаНаФорме(ЭтотОбъект, Объект.ТаблицаТребований); 
		КонецЕсли;
	КонецЕсли;
	
	ЭлектронноеВзаимодействиеСлужебный.УстановитьУсловноеОформлениеДереваМаршрута(ЭтотОбъект,, 
		ЗначениеЗаполнено(Объект.КлючАвтоматическойНастройки));
	УстановитьТекстПояснения();
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЭлектронноеВзаимодействиеСлужебный.ЗаполнитьДеревоМаршрутаНаФорме(ЭтотОбъект, ТекущийОбъект.ТаблицаТребований); 
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	КэшироватьОрганизацию();
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПараметрыЗаписи.Свойство("ПропуститьПроверки") Тогда
		// Выполняем серверный вызов, так как нужно проверить валидность маршрута и в случае ошибок спросить у пользователя,
		// записывать ли его.
		ЕстьОшибкиЗаполнения = Ложь;
		Если Не МаршрутВалидирован(ЕстьОшибкиЗаполнения) Тогда
			Отказ = Истина;
			
			Если Не ЕстьОшибкиЗаполнения Тогда
				ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОЗаписиПолученОтвет", ЭтотОбъект, ПараметрыЗаписи);
				ТекстВопроса = НСтр("ru = 'Обнаружены возможные ошибки в настройке маршрута. Продолжить запись?'");
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет, 
					НСтр("ru = 'Настройка некорректна'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.СхемаПодписания <> Перечисления.СхемыПодписанияЭД.ПоПравилам Тогда
		НепроверяемыеРеквизиты = Новый Массив;
		НепроверяемыеРеквизиты.Добавить("Организация");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	КонецЕсли;
	
	ПроверитьДерево(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ЗакрытьПослеЗаписи") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)	

	Если Объект.Организация <> ТекущаяОрганизация Тогда
		Оповещение = Новый ОписаниеОповещения("ОрганизацияПриИзмененииЗавершение", ЭтотОбъект);
		
		// Если в дереве есть элементы второго уровня, его надо очистить
		ТребуетсяОчистка = Ложь;
		КорневыеЭлементы = ДеревоТребований.ПолучитьЭлементы();
		Если КорневыеЭлементы.Количество() Тогда
			ЭлементыВторогоУровня = КорневыеЭлементы[0].ПолучитьЭлементы();
			ТребуетсяОчистка = ЭлементыВторогоУровня.Количество() > 0;
		КонецЕсли;
		
		Если ТребуетсяОчистка Тогда
			ПоказатьВопрос(Оповещение, НСтр("ru = 'При изменении организации таблица требований будет очищена. Продолжить?'"), 
				РежимДиалогаВопрос.ДаНет);
		Иначе
		    ВыполнитьОбработкуОповещения(Оповещение, КодВозвратаДиалога.Да);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзмененииЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		КэшироватьОрганизацию();
		
		// Оставим только корневой элемент дерева
		КорневыеЭлементы = ДеревоТребований.ПолучитьЭлементы();
		Если КорневыеЭлементы.Количество() Тогда
			ЭлементыВторогоУровня = КорневыеЭлементы[0].ПолучитьЭлементы();
			Если ЭлементыВторогоУровня.Количество() Тогда
				ЭлементыВторогоУровня.Очистить();
			КонецЕсли;
		КонецЕсли;
		
		УстановитьДоступностьЭлементов();
	Иначе 
		Объект.Организация = ТекущаяОрганизация;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВключитьВозможностьИзмененияНажатие(Элемент)
	
	Объект.КлючАвтоматическойНастройки = "";
	Объект.Наименование = "";
	Модифицированность = Истина;
	
	ТекущийЭлемент = Элементы.Наименование;
	
	ПриВключенииВозможностиИзмененияНаСервере();
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоТребований

&НаКлиенте
Процедура ДеревоТребованийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование И Не РазрешитьДобавлениеНовойСтроки Тогда
		Отказ = Истина;
	Иначе
		РазрешитьДобавлениеНовойСтроки = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не НоваяСтрока ИЛИ Копирование Тогда
		УстановитьТипОсновногоЗначения();
		
		Если Копирование Тогда
			Элемент.ТекущиеДанные.Идентификатор = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийПередУдалением(Элемент, Отказ)
	
	// Корневой узел удалять нельзя: дерево всегда должно начинаться с требования
	Если Элементы.ДеревоТребований.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Отказ = Истина;
	Иначе
		СтрокаРодителя = Элементы.ДеревоТребований.ТекущиеДанные.ПолучитьРодителя();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийПослеУдаления(Элемент)
	
	Если СтрокаРодителя <> Неопределено Тогда
		ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаРодителя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И Не ОтменаРедактирования Тогда
		СтрокаРодителя = Элементы.ДеревоТребований.ТекущиеДанные.ПолучитьРодителя();
		Если СтрокаРодителя <> Неопределено Тогда
			ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаРодителя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийОсновноеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элементы.ДеревоТребований.ТекущиеДанные;
	Если ТекДанные.ЭтоСтрокаУсловия Тогда
		СтандартнаяОбработка = Ложь;
		ОписаниеОповещения = Новый ОписаниеОповещения("ДеревоТребованийОсновноеЗначениеНачалоВыбораЗавершение", ЭтотОбъект);
		СоответствиеПредставленийТребованиям = ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.СоответствиеПредставленийТребованиям(ТекДанные);
		
		СписокВыбора = Новый СписокЗначений;
		Для Каждого КлючИЗначение Из СоответствиеПредставленийТребованиям Цикл
			СписокВыбора.Добавить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
		ПоказатьВыборИзСписка(ОписаниеОповещения, СписокВыбора, Элемент, СписокВыбора.НайтиПоЗначению(ТекДанные.Требование));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийОсновноеЗначениеНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт 
	
	Если РезультатВыбора <> Неопределено Тогда
		СтрокаДерева = ДеревоТребований.НайтиПоИдентификатору(Элементы.ДеревоТребований.ТекущаяСтрока);
		
		Если ТипЗнч(РезультатВыбора) = Тип("ЭлементСпискаЗначений") Тогда // это был выбор требования
			СтрокаДерева.Требование = РезультатВыбора.Значение;
		Иначе //это был выбор подписанта
			СтрокаДерева.Подписант = РезультатВыбора;
			
			СписокПодписантовДляОтбора = Новый СписокЗначений;
			СписокПодписантовДляОтбора.Добавить(ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
			Если ЗначениеЗаполнено(РезультатВыбора) Тогда
				СписокПодписантовДляОтбора.Добавить(РезультатВыбора);
			КонецЕсли;
			СтрокаДерева.ОтборСертификатов = СписокПодписантовДляОтбора;
			
			Если Не ОтборСертификатовКорректный(СтрокаДерева.Сертификат, СписокПодписантовДляОтбора, Объект.Организация) Тогда
				СтрокаДерева.Сертификат = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаДерева);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийОсновноеЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ДеревоТребованийОсновноеЗначениеНачалоВыбораЗавершение(ВыбранноеЗначение, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийОсновноеЗначениеПриИзменении(Элемент)
	
	ТекДанные = Элементы.ДеревоТребований.ТекущиеДанные;
	Если ТекДанные <> Неопределено И НЕ ТекДанные.ЭтоСтрокаУсловия Тогда
		ДеревоТребованийОсновноеЗначениеНачалоВыбораЗавершение(ТекДанные.ОсновноеЗначение, Новый Структура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийСертификатПриИзменении(Элемент)
	
	СтрокаДерева = ДеревоТребований.НайтиПоИдентификатору(Элементы.ДеревоТребований.ТекущаяСтрока);
	ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаДерева);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийУдалить(Команда)
	
	ТекущиеДанныеДерева = Элементы.ДеревоТребований.ТекущиеДанные;
	
	Если ТекущиеДанныеДерева <> Неопределено Тогда
		СтрокаРодителя = ТекущиеДанныеДерева.ПолучитьРодителя();
		
		// Корневой узел удалять нельзя: дерево всегда должно начинаться с требования
		Если СтрокаРодителя <> Неопределено Тогда
			ЭлементыТекущегоУровня = СтрокаРодителя.ПолучитьЭлементы();
			ИндексТекущейСтроки = ЭлементыТекущегоУровня.Индекс(ТекущиеДанныеДерева);
			ЭлементыТекущегоУровня.Удалить(ИндексТекущейСтроки);
			
			ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаРодителя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("ЗакрытьПослеЗаписи", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьТребование(Команда)
	
	ТипТребования = СтрЗаменить(Команда.Имя, "ДобавитьГруппу", "");
	ДобавитьНовуюСтрокуВДерево(Истина, ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД." + ТипТребования));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПодписанта(Команда)
	
	ДобавитьНовуюСтрокуВДерево();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ДекорацияПоясняющийТекст.Видимость = Объект.СхемаПодписания <> Перечисления.СхемыПодписанияЭД.ПоПравилам;
	
	МаршрутСозданАвтоматически = ЗначениеЗаполнено(Объект.КлючАвтоматическойНастройки);
	Элементы.ГруппаПодсказкаБлокировки.Видимость = МаршрутСозданАвтоматически;
	Элементы.ДеревоТребованийОсновноеЗначение.АвтоОтметкаНезаполненного = Не МаршрутСозданАвтоматически;
		
	Элементы.Правила.Видимость = Объект.СхемаПодписания = Перечисления.СхемыПодписанияЭД.ПоПравилам;
	Элементы.Организация.Видимость = Объект.СхемаПодписания = Перечисления.СхемыПодписанияЭД.ПоПравилам;
	Элементы.Родитель.Видимость = Объект.СхемаПодписания = Перечисления.СхемыПодписанияЭД.ПоПравилам;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()

	Элементы.Правила.Доступность = ЗначениеЗаполнено(Объект.Организация);
	ТолькоПросмотр = Объект.Предопределенный ИЛИ ЗначениеЗаполнено(Объект.КлючАвтоматическойНастройки);

КонецПроцедуры

&НаКлиенте
Процедура КэшироватьОрганизацию()
	
	ТекущаяОрганизация = Объект.Организация;

КонецПроцедуры

&НаСервере
Процедура УстановитьТекстПояснения()
	
	ТекстПояснения = "";
	Если Объект.СхемаПодписания = Перечисления.СхемыПодписанияЭД.ОднойДоступнойПодписью Тогда
		ТекстПояснения = НСтр("ru = 'По данному правилу устанавливается одна подпись из числа доступных по организации и используемому сервису.'");
	ИначеЕсли Объект.СхемаПодписания = Перечисления.СхемыПодписанияЭД.УказыватьПриСоздании Тогда
		ТекстПояснения = НСтр("ru = 'Правила подписания будут задаваться при отправке документа на подпись.'");
	КонецЕсли;

	Элементы.ДекорацияПоясняющийТекст.Заголовок = ТекстПояснения;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтборСертификатовКорректный(Сертификат, СписокПодписантовДляОтбора, Организация)

	Возврат СписокПодписантовДляОтбора.НайтиПоЗначению(Сертификат.Пользователь) <> Неопределено
		И Сертификат.Организация = Организация;

КонецФункции 

#Область ПроверкиПередЗаписью

&НаКлиенте
Процедура ВопросОЗаписиПолученОтвет(Ответ, ПараметрыЗаписи) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		НовыеПараметрыЗаписи = Новый Структура;
		НовыеПараметрыЗаписи.Вставить("ПропуститьПроверки");
		Для Каждого КлючИЗначение Из ПараметрыЗаписи Цикл
			НовыеПараметрыЗаписи.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;

		Записать(НовыеПараметрыЗаписи);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция МаршрутВалидирован(ЕстьОшибкиЗаполнения = Ложь)
	ЕстьОшибкиЗаполнения = НЕ ПроверитьЗаполнение();
	ЕстьОшибкиВЗависимыхНастройках = Ложь;
	
	Если Не ЕстьОшибкиЗаполнения Тогда
		ЗаписатьДеревоТребований();
		
		Если Не Объект.Предопределенный И Не Объект.Ссылка.Пустая() Тогда
			ПроверитьВалидностьМаршрутаПоВсемЗависимымНастройкам(ЕстьОшибкиВЗависимыхНастройках);
		КонецЕсли;
	КонецЕсли;
	
	Возврат НЕ ЕстьОшибкиЗаполнения И Не ЕстьОшибкиВЗависимыхНастройках;

КонецФункции

&НаСервере
Процедура ПроверитьВалидностьМаршрутаПоВсемЗависимымНастройкам(Отказ)
	
	// Найдем все настройки обмена с банками / с контрагентами, в которых указан маршрут
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	ЕстьОбменСБанками = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками");
	
	Если ЕстьОбменСКонтрагентами ИЛИ ЕстьОбменСБанками Тогда
		ТекстыЗапросов = Новый Массив;
		ТекстОбъединения = 
		"
		|	
		|ОБЪЕДИНИТЬ ВСЕ
		|	
		|";
		
		Если ЕстьОбменСКонтрагентами Тогда
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ИсходящиеДокументы.ВидДокумента КАК ВидДокумента,
			|	НЕОПРЕДЕЛЕНО КАК НастройкаОбмена,
			|	ИсходящиеДокументы.Отправитель,
			|	ИсходящиеДокументы.Получатель,
			|	ИсходящиеДокументы.Договор,
			|	СертификатыПодписейОрганизации.Сертификат КАК Сертификат
			|ПОМЕСТИТЬ ВидыДокументовПоНастройкам
			|ИЗ
			|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК ИсходящиеДокументы
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыПодписейОрганизации
			|		ПО ИсходящиеДокументы.ИдентификаторОтправителя = СертификатыПодписейОрганизации.ИдентификаторЭДО
			|ГДЕ
			|	ИсходящиеДокументы.МаршрутПодписания = &МаршрутПодписания";
			ТекстыЗапросов.Добавить(ТекстЗапроса);
		КонецЕсли;
		
		Если ЕстьОбменСБанками Тогда
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	НастройкиОбменСБанкамиИсходящиеДокументы.ИсходящийДокумент КАК ВидДокумента,
			|	НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка КАК НастройкаОбмена,
			|	НЕОПРЕДЕЛЕНО КАК Отправитель,
			|	НЕОПРЕДЕЛЕНО КАК Получатель,
			|	НЕОПРЕДЕЛЕНО КАК Договор,
			|	НастройкиОбменСБанкамиСертификатыПодписейОрганизации.СертификатЭП КАК Сертификат
			|%ПомещениеВоВременнуюТаблицу%
			|ИЗ
			|	Справочник.НастройкиОбменСБанками.ИсходящиеДокументы КАК НастройкиОбменСБанкамиИсходящиеДокументы
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиОбменСБанками.СертификатыПодписейОрганизации КАК НастройкиОбменСБанкамиСертификатыПодписейОрганизации
			|		ПО НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка = НастройкиОбменСБанкамиСертификатыПодписейОрганизации.Ссылка
			|ГДЕ
			|	НастройкиОбменСБанкамиИсходящиеДокументы.МаршрутПодписания = &МаршрутПодписания";
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПомещениеВоВременнуюТаблицу%", 
				?(ТекстыЗапросов.Количество(), "", "ПОМЕСТИТЬ ВидыДокументовПоНастройкам"));
				
			Если ТекстыЗапросов.Количество() Тогда
				ТекстыЗапросов.Добавить(ТекстОбъединения);
			КонецЕсли;
			ТекстыЗапросов.Добавить(ТекстЗапроса);
		КонецЕсли;
		
		ТекстЗапроса =
		" 
		|;
		|
		|ВЫБРАТЬ
		|	ВидыДокументовПоНастройкам.ВидДокумента КАК ВидДокумента,
		|	ВидыДокументовПоНастройкам.НастройкаОбмена КАК НастройкаОбмена,
		|	ВидыДокументовПоНастройкам.Отправитель КАК Отправитель,
		|	ВидыДокументовПоНастройкам.Получатель КАК Получатель,
		|	ВидыДокументовПоНастройкам.Договор КАК Договор,
		|	ВидыДокументовПоНастройкам.Сертификат
		|ИЗ
		|	ВидыДокументовПоНастройкам КАК ВидыДокументовПоНастройкам
		|ИТОГИ ПО
		|	НастройкаОбмена,
		|	Отправитель,
		|	Получатель,
		|	Договор,
		|	ВидДокумента";
		ТекстыЗапросов.Добавить(ТекстЗапроса);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("МаршрутПодписания", Объект.Ссылка);
		Запрос.Текст = СтрСоединить(ТекстыЗапросов);
		
		// Обойдем настройки и проверим каждую на валидность
		УстановитьПривилегированныйРежим(Истина);
		ВыборкаНастроек = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		УстановитьПривилегированныйРежим(Ложь);
		Пока ВыборкаНастроек.Следующий() Цикл
			НаборСертификатов = Новый Массив;
			НаборВидовЭД = Новый Массив;
			СертификатыСчитаны = Ложь;
			ВыборкаОтправителей = ВыборкаНастроек.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаОтправителей.Следующий() Цикл
				ВыборкаПолучателей = ВыборкаОтправителей.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаПолучателей.Следующий() Цикл
					ВыборкаДоговоров = ВыборкаПолучателей.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаДоговоров.Следующий() Цикл
						ВыборкаВидов = ВыборкаДоговоров.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						Пока ВыборкаВидов.Следующий() Цикл
							НаборВидовЭД.Добавить(ВыборкаВидов.ВидДокумента);
							
							Если Не СертификатыСчитаны Тогда
								ВыборкаСертификатов = ВыборкаВидов.Выбрать();
								Пока ВыборкаСертификатов.Следующий() Цикл
									Если ЗначениеЗаполнено(ВыборкаСертификатов.Сертификат) Тогда
										НаборСертификатов.Добавить(ВыборкаСертификатов.Сертификат);
									КонецЕсли;
								КонецЦикла;
								СертификатыСчитаны = Истина;
							КонецЕсли;
						КонецЦикла;
						
						РезультатыПроверки = ЭлектронноеВзаимодействиеСлужебный.РезультатыПроверкиМаршрутаПоПараметрамНастройки(
							Объект.ТаблицаТребований.Выгрузить(), НаборСертификатов, НаборВидовЭД);
							
						// Ошибки недоступности сертификатов для подписания вида ЭД в целом пропускаем - это не ошибка настройки маршрута.
						ПредставлениеНастройки = "";
						Если ЗначениеЗаполнено(ВыборкаДоговоров.НастройкаОбмена) Тогда
							НастройкаОбмена = ВыборкаДоговоров.НастройкаОбмена;
						Иначе 
							ОписаниеНастройки = Новый Структура("Отправитель, Получатель, Договор");
							ЗаполнитьЗначенияСвойств(ОписаниеНастройки, ВыборкаДоговоров);
							МенеджерНастроек = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("РегистрСведений.НастройкиОтправкиЭлектронныхДокументов");
							
							НастройкаОбмена        = МенеджерНастроек.СоздатьКлючЗаписи(ОписаниеНастройки);
							ПредставлениеНастройки = ОбщегоНазначения.ОбщийМодуль("ОбменСКонтрагентамиСлужебный").ПредставлениеНастройкиОтправкиЭлектронныхДокументов(ОписаниеНастройки);
						КонецЕсли;
						ЭлектронноеВзаимодействиеСлужебный.ВывестиРезультатыПроверкиМаршрута(РезультатыПроверки, 
							НастройкаОбмена, Объект.Наименование, Отказ, "НетДоступныхСертификатов", ПредставлениеНастройки);
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область РаботаСДеревом

&НаСервере
Процедура ИнициализироватьДерево()

	КорневыеЭлементы = ДеревоТребований.ПолучитьЭлементы();
	КорневыеЭлементы.Очистить();
	
	КорневаяСтрокаДерева = КорневыеЭлементы.Добавить();
	КорневаяСтрокаДерева.Требование		= Перечисления.ТребованияКПодписаниюЭД.ИЛИ;
	ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(КорневаяСтрокаДерева);
	Элементы.ДеревоТребований.ТекущаяСтрока = КорневаяСтрокаДерева.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДерево(Отказ)

	ЕстьПустыеЗначения = Ложь;
	ЕстьТребованияБезПодписантов = Ложь;
	ДублиСертификатов = Новый Массив;
	ДублиПодписантов = Новый Массив;
	Для Каждого СтрокаДерева Из ДеревоТребований.ПолучитьЭлементы() Цикл
		ПроверитьСтрокуДерева(СтрокаДерева, ЕстьПустыеЗначения, ЕстьТребованияБезПодписантов, ДублиПодписантов, 
			ДублиСертификатов);
	КонецЦикла;
	
	Ошибки = Неопределено;
	
	Если ЕстьПустыеЗначения Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ДеревоТребований", 
			НСтр("ru = 'В составе маршрута есть неуказанные пользователи'"), Неопределено);
	КонецЕсли;
		
	Если ЕстьТребованияБезПодписантов Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ДеревоТребований", 
			НСтр("ru = 'В составе маршрута есть группы, не содержащие подписантов'"), Неопределено);
	КонецЕсли;
		
	Для Каждого Подписант Из ДублиПодписантов Цикл
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подписант ""%1"" задублирован в некоторых ветках маршрута'"), Подписант);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ДеревоТребований", ТекстОшибки, Неопределено);
	КонецЦикла;
	
	Для Каждого Сертификат Из ДублиСертификатов Цикл
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сертификат ""%1"" задублирован в некоторых ветках маршрута'"), Сертификат);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ДеревоТребований", ТекстОшибки, Неопределено);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);

КонецПроцедуры

&НаСервере
Процедура ПроверитьСтрокуДерева(СтрокаДерева, ЕстьПустыеЗначения, ЕстьТребованияБезПодписантов, ДублиПодписантов, 
	ДублиСертификатов)

	Если Не ЗначениеЗаполнено(СтрокаДерева.Требование) И Не ЗначениеЗаполнено(СтрокаДерева.Подписант) Тогда
		ЕстьПустыеЗначения = Истина;
	КонецЕсли;
		
	СписокПодписантов = Новый Массив;
	СписокСертификатов = Новый Массив;
	
	ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
	Если ПодчиненныеСтроки.Количество() = 0 И СтрокаДерева.ЭтоСтрокаУсловия Тогда
		ЕстьТребованияБезПодписантов = Истина;
	Иначе
		Для Каждого ПодчиненнаяСтрокаДерева Из ПодчиненныеСтроки Цикл
			ПроверитьСтрокуДерева(ПодчиненнаяСтрокаДерева, ЕстьПустыеЗначения, ЕстьТребованияБезПодписантов, ДублиПодписантов,
				ДублиСертификатов);
			
			Если ЗначениеЗаполнено(ПодчиненнаяСтрокаДерева.Подписант) Тогда
				Если СписокПодписантов.Найти(ПодчиненнаяСтрокаДерева.Подписант) <> Неопределено Тогда
					Если ДублиПодписантов.Найти(ПодчиненнаяСтрокаДерева.Подписант) = Неопределено Тогда
						ДублиПодписантов.Добавить(ПодчиненнаяСтрокаДерева.Подписант);
					КонецЕсли;
				Иначе
					СписокПодписантов.Добавить(ПодчиненнаяСтрокаДерева.Подписант);	
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ПодчиненнаяСтрокаДерева.Сертификат) Тогда
				Если СписокСертификатов.Найти(ПодчиненнаяСтрокаДерева.Сертификат) <> Неопределено Тогда
					Если ДублиСертификатов.Найти(ПодчиненнаяСтрокаДерева.Сертификат) = Неопределено Тогда
						ДублиСертификатов.Добавить(ПодчиненнаяСтрокаДерева.Сертификат);
					КонецЕсли;
				Иначе
					СписокСертификатов.Добавить(ПодчиненнаяСтрокаДерева.Сертификат);	
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьДеревоТребований(ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда
		ТаблицаТребований = Неопределено;
	Иначе
		ТаблицаТребований = ТекущийОбъект.ТаблицаТребований;
		ТаблицаТребований.Очистить();
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение("ДеревоТребований");
	ЭлектронноеВзаимодействиеСлужебный.ЗаполнитьТаблицуТребованийКПодписаниюПоДереву(ТаблицаТребований, Дерево);
	
	Если ТекущийОбъект = Неопределено Тогда
		Объект.ТаблицаТребований.Загрузить(ТаблицаТребований);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНовуюСтрокуВДерево(ЭтоУсловие = Ложь, Требование = Неопределено)
	
	ТекущаяСтрока = Элементы.ДеревоТребований.ТекущаяСтрока;
	
	ЕстьУсловия 	= Ложь;
	ЕстьПодписанты 	= Ложь;
	ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.ОпределитьПараметрыПодчиненныхСтрокДерева(
		Элементы.ДеревоТребований.ТекущиеДанные, ЕстьУсловия, ЕстьПодписанты);
	
	// Внутри одной группы для простоты понимания дерева не будем смешивать элементы разных типов.
	Если ЕстьУсловия И Не ЭтоУсловие ИЛИ ЕстьПодписанты И ЭтоУсловие Тогда
		ЗначениеПодстановки = ?(ЕстьУсловия И Не ЭтоУсловие, НСтр("ru = 'требования'"), НСтр("ru = 'подписи'"));
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Каждая группа может содержать элементы одного типа. В эту группу можно добавить только %1.'"),
			ЗначениеПодстановки);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения, Объект.Ссылка, "ДеревоТребований"); 
	// Дочерние строки добавляются только у требований.
	ИначеЕсли ТекущаяСтрока = Неопределено ИЛИ Элементы.ДеревоТребований.ТекущиеДанные.ЭтоСтрокаУсловия Тогда
		ОчиститьСообщения();
		
		УстановитьТипОсновногоЗначения(ЭтоУсловие);
		
		Если ЭтоУсловие И ЗначениеЗаполнено(Требование) Тогда
			НоваяСтрока = ДеревоТребований.НайтиПоИдентификатору(ТекущаяСтрока).ПолучитьЭлементы().Добавить();
			НоваяСтрока.Требование = Требование;
			НоваяСтрока.ЭтоСтрокаУсловия = Истина;
			
			ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(НоваяСтрока.ПолучитьРодителя());
			Элементы.ДеревоТребований.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		Иначе	
			РазрешитьДобавлениеНовойСтроки = Истина;
			Элементы.ДеревоТребований.ДобавитьСтроку();
		КонецЕсли;
			
		ТекущаяСтрока = Элементы.ДеревоТребований.ТекущаяСтрока;
		СтрокаДерева = ДеревоТребований.НайтиПоИдентификатору(ТекущаяСтрока);
		СтрокаДерева.ЭтоСтрокаУсловия = ЭтоУсловие;
		
		ЭлектронноеВзаимодействиеСлужебныйКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаДерева);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТипОсновногоЗначения(ЭтоУсловие = Неопределено)
	
	Если ЭтоУсловие = Неопределено Тогда
		ЭтоУсловие = Элементы.ДеревоТребований.ТекущиеДанные.ЭтоСтрокаУсловия;
	КонецЕсли;
	
	ТипСтрока = Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(0));
	ТипПользователи = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
	Элементы.ДеревоТребованийОсновноеЗначение.ОграничениеТипа = ?(ЭтоУсловие, ТипСтрока, ТипПользователи);

КонецПроцедуры

&НаСервере
Процедура ПриВключенииВозможностиИзмененияНаСервере()
	
	УстановитьВидимостьЭлементов();
	УсловноеОформление.Элементы.Очистить();
	ЭлектронноеВзаимодействиеСлужебный.УстановитьУсловноеОформлениеДереваМаршрута(ЭтотОбъект,, 
		ЗначениеЗаполнено(Объект.КлючАвтоматическойНастройки));

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Инициализация

РазрешитьДобавлениеНовойСтроки = Ложь;

#КонецОбласти










