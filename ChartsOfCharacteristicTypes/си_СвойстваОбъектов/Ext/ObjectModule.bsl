﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция проверяет, используется ли свойство для задания значений. 
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
	|	си_ЗначенияСвойствОбъектов.Свойство КАК Свойство
	|ИЗ
	|	РегистрСведений.си_ЗначенияСвойствОбъектов КАК си_ЗначенияСвойствОбъектов
	|ГДЕ
	|	си_ЗначенияСвойствОбъектов.Свойство = &Свойство";

	Запрос.УстановитьПараметр("Свойство", Ссылка);

	Возврат Не Запрос.Выполнить().Пустой();

КонецФункции // СуществуютСсылки()


#Область ОбработчикиСобытий

// Обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	Если Не ЭтоНовый() И СуществуютСсылки() Тогда

		Сообщить("Существуют объекты, которым назначено свойство """ + Наименование + """.
		         |Назначение свойства не может быть изменено, элемент не записан.", 
		         СтатусСообщения.Важное);
		Отказ = Истина;
		
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()

// Обработчик события ПередУдалением объекта.
//
Процедура ПередУдалением(Отказ)

	Если Предопределенный Тогда
		Сообщить("Не допускается удаление предопределенных элементов!", СтатусСообщения.Внимание);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры // ПередУдалением()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли