﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция проверяет, назначена ли категория каким-либо объектам.
// Если назначена - менять назначение категории нельзя.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина - если назначена, Ложь - если нет.
//
Функция СуществуютСсылки() Экспорт

	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	КатегорииОбъектов.Категория КАК Категория
	|ИЗ
	|	РегистрСведений.УдалитьКатегорииОбъектов КАК КатегорииОбъектов
	|ГДЕ
	|	КатегорииОбъектов.Категория = &Категория";

	Запрос.УстановитьПараметр("Категория", Ссылка);

	Возврат НЕ Запрос.Выполнить().Пустой();

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И НазначениеКатегории <> Ссылка.НазначениеКатегории И СуществуютСсылки() Тогда
		
		Отказ = Истина;
		
		ТекстСообщения = НСтр(
		"ru = 'Существуют объекты, которым назначена категория ""%1"".
		|Назначение категории не может быть изменено.'");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(Наименование));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "НазначениеКатегории", "Объект");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли