﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)

	Если НЕ ОбменДанными.Загрузка
	   И НЕ ЭтоНовый() 
	   И НазначениеСвойства <> Ссылка.НазначениеСвойства 
	   И ЭтотОбъект.СуществуютСсылки() Тогда

		Сообщить("Существуют объекты, которым назначено свойство """ + Наименование + """.
		         |Назначение свойства не может быть изменено, элемент не записан.", 
		         СтатусСообщения.Важное);

		Отказ = Истина;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ТипЗначения") Тогда
		
		ТипЗначения = ДанныеЗаполнения.ТипЗначения;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция проверяет, используется ли свойство для задания значений 
// или назначения каким-либо объектам.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина, если используется, Ложь, если нет.
//
Функция СуществуютСсылки() Экспорт

	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрСведений.УдалитьЗначенияСвойствОбъектов.Свойство КАК Свойство
	|ИЗ
	|	РегистрСведений.УдалитьЗначенияСвойствОбъектов
	|
	|ГДЕ
	|	РегистрСведений.УдалитьЗначенияСвойствОбъектов.Свойство = &Свойство
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов.Свойство КАК Свойство
	|ИЗ
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов
	|
	|ГДЕ
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов.Свойство = &Свойство
	|";

	Запрос.УстановитьПараметр("Свойство", Ссылка);

	Возврат НЕ Запрос.Выполнить().Пустой();

КонецФункции

#КонецЕсли