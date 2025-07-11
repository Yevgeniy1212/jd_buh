﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Проверка возможности загрузки новых обработок в информационную базу
	ЭтоНовый = Объект.Ссылка.Пустая();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ЭтаФорма, "Описание");
	Оповещение = Новый ОписаниеОповещения("ПрочиеСведенияЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Объект.Описание, НСтр("ru='Описание'"));

КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайл(Команда)
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ЭтоОтчет", Истина);
	ПараметрыВыгрузки.Вставить("ИмяФайла", Объект.ИсточникОтчета);
	ПараметрыВыгрузки.Вставить("АдресДанныхОбработки", АдресФайлаВоВременномХранилище);
	ДополнительныеОтчетыИОбработкиКлиент.ВыгрузитьВФайл(ПараметрыВыгрузки);
	

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ТекущийОбъект.ВнешнийОтчетХранилище <> Неопределено Тогда
		АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ТекущийОбъект.ВнешнийОтчетХранилище.Получить(),УникальныйИдентификатор);
		ИсточникОтчетаФайл = "Отчет загружен в ИБ";
	КонецЕсли;
	
	Если Объект.ВнешнийОтчетИспользовать Тогда
		ТипИспользованияВнешнегоОтчета = 1;
	КонецЕсли;	
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(АдресФайлаВоВременномХранилище) Тогда
		ТекущийОбъект.ВнешнийОтчетХранилище = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище), Новый СжатиеДанных(9));
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ИсточникОтчетаФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ПредупреждениеБезопасностиРОПослеПодтверждения", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("Ключ", "ПередВыборомВРО");
	ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасностиРО", ПараметрыФормы, , , , , Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ПредупреждениеБезопасностиРОПослеПодтверждения(Ответ, ПараметрыРегистрации) Экспорт
	
	Если Ответ <> "Продолжить" Тогда
		Возврат;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	ВыбратьВнешнийОтчетПродолжение();
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьВнешнийОтчетПродолжение()
	
	#Если ВебКлиент Тогда
		
		АдресФайлаВоВременномХранилище = "";
		ВыбранноеИмяФайла              = "";
		
		ДополнительныеПараметры = Новый Структура("ВыбранноеИмяФайла", ВыбранноеИмяФайла);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВнешнийОтчетЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайла(ОписаниеОповещения, АдресФайлаВоВременномХранилище,,, УникальныйИдентификатор);
		
	#Иначе
		
		// инициализируем свойства диалога
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.Заголовок = НСтр("ru = 'Выберите файл внешнего отчета'");
		Диалог.МножественныйВыбор = Ложь;
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Диалог.Фильтр = НСтр("ru = 'Внешний отчет (*.erf)|*.erf'");
		
		// показываем диалог
		Если НЕ Диалог.Выбрать() Тогда
			Возврат;
		КонецЕсли;
		
		АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Диалог.ПолноеИмяФайла), Новый УникальныйИдентификатор);
		ПолноеИмяЗагруженногоВнешнегоОтчета = Диалог.ПолноеИмяФайла;
		
			
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВнешнийОтчетЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	АдресФайлаВоВременномХранилище = Адрес;
	ПолноеИмяЗагруженногоВнешнегоОтчета = ВыбранноеИмяФайла;
		
КонецПроцедуры

&НаКлиенте
Процедура ТипИспользованияВнешнегоОтчетаПриИзменении(Элемент)
	Объект.ВнешнийОтчетИспользовать = ТипИспользованияВнешнегоОтчета>0;	
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	мОбъект   = Форма.Объект;
	мЭлементы = Форма.Элементы;
	
	мЭлементы.ГруппаВнешнийФайл.Доступность 	 			= мОбъект.ВнешнийОтчетИспользовать;	
	
КонецПроцедуры // УстановитьДоступность()

&НаКлиенте
Процедура ОбновлениеИзФайлаМеханикаНаКлиенте(ПараметрыРегистрации)
	// Подготовка к вызову сервера.
	ОбработчикРезультата = ПараметрыРегистрации.ОбработчикРезультата;
	ПараметрыРегистрации.Удалить("ОбработчикРезультата");
	// Вызов сервера.
	ОбновлениеИзФайлаМеханикаНаСервере(ПараметрыРегистрации);
	// Отмена изменений.
	ПараметрыРегистрации.Вставить("ОбработчикРезультата", ОбработчикРезультата);	
		
	// Обработка результата работы сервера
	Если ПараметрыРегистрации.Успех Тогда
		ОповещениеЗаголовок = НСтр("ru = 'Файл внешнего отчета загружен'");
		ОповещениеСсылка    = ?(ЭтоНовый, "", ПолучитьНавигационнуюСсылку(Объект.Ссылка));
		ОповещениеТекст     = ПараметрыРегистрации.ИмяФайла;
		ПоказатьОповещениеПользователя(ОповещениеЗаголовок, ОповещениеСсылка, ОповещениеТекст);
		ВыполнитьОбработкуОповещения(ПараметрыРегистрации.ОбработчикРезультата, ПараметрыРегистрации);
	Иначе
		ТекстПредупреждения = ПараметрыРегистрации.КраткоеПредставлениеОшибки;
		ПоказатьПредупреждение(,ТекстПредупреждения);  		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера, Сервер

&НаСервере
Процедура ОбновлениеИзФайлаМеханикаНаСервере(ПараметрыРегистрации)
	ОбъектСправочника = РеквизитФормыВЗначение("Объект");
	
	ДвоичныеДанныеОбработки = ПолучитьИзВременногоХранилища(ПараметрыРегистрации.АдресДанныхОбработки);
	ОбъектСправочника.ВнешнийОтчетХранилище = Новый ХранилищеЗначения(ДвоичныеДанныеОбработки, Новый СжатиеДанных(9));

	ЗначениеВРеквизитФормы(ОбъектСправочника, "Объект");
	
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры
