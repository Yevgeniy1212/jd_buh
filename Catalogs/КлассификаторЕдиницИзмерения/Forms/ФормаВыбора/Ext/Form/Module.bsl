﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Текст = НСтр("ru = 'Есть возможность подобрать единицу измерения из классификатора.
	|Подобрать?'");
	Оповещение = Новый ОписаниеОповещения("СписокПередНачаломДобавленияЗавершение", ЭтотОбъект);
	КнопкиВыбора = Новый СписокЗначений();
	КнопкиВыбора.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Подобрать'"));
	КнопкиВыбора.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Создать'"));
	КнопкиВыбора.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
	ПоказатьВопрос(Оповещение, Текст,КнопкиВыбора,, КодВозвратаДиалога.Да);
	Отказ = Истина;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодборИзКлассификатора(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.ФормаПодбораИзКлассификатора", , ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура СписокПередНачаломДобавленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	 
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.ФормаПодбораИзКлассификатора",, ЭтотОбъект);
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.ФормаОбъекта");
	КонецЕсли;

КонецПроцедуры
