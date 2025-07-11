﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.ПометкаУдаления Тогда
		Возврат; //При удалении не проверяем
	КонецЕсли;
	
	//Нужно выполнять проверку на использование Идентификатор (OMS ID) в других элементах
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	"""" КАК Поле1
	|ИЗ
	|	Справочник.СтанцииУправленияЗаказамиИСМПТК КАК СтанцииУправленияЗаказамиИСМПТК
	|ГДЕ
	|	СтанцииУправленияЗаказамиИСМПТК.Идентификатор = &Идентификатор
	|" 
	+ ?(Не ЭтотОбъект.Ссылка.Пустая(), "И СтанцииУправленияЗаказамиИСМПТК.Ссылка <> &Ссылка", "");
	
	Запрос.УстановитьПараметр("Идентификатор", ЭтотОбъект.Идентификатор);
	Если Не ЭтотОбъект.Ссылка.Пустая() Тогда
		Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	КонецЕсли;
	Если Не Запрос.Выполнить().Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'Станция управления заказами с идентификатором %1 уже зарегистрирована!'"); 
		ТекстСообщения = ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, ЭтотОбъект.Идентификатор); 
		ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

