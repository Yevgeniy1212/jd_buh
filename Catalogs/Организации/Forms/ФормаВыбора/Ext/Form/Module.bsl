﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


&НаКлиенте
Процедура УстановитьОсновной(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если УстановитьОсновнойНаСервере(ТекущиеДанные.Ссылка) Тогда 
		ОсновнаяОрганизация = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаУстановитьОсновной.Доступность = НЕ ОсновнаяОрганизация = ТекущиеДанные.Ссылка;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Функция УстановитьОсновнойНаСервере(ВыбраннаяОрганизация)
	
	Попытка
		
		ТекущийПользователь = Пользователи.ТекущийПользователь();
		
		Набор = РегистрыСведений.НастройкиПользователей.СоздатьНаборЗаписей();
		
		Набор.Отбор.Пользователь.Установить(ТекущийПользователь);
		Набор.Отбор.Настройка.Установить(ПланыВидовХарактеристик.НастройкиПользователей.ОсновнаяОрганизация);
		
		Запись = Набор.Добавить();
		
		Запись.Пользователь = ТекущийПользователь;
		Запись.Настройка    = ПланыВидовХарактеристик.НастройкиПользователей.ОсновнаяОрганизация;
		Запись.Значение     = ВыбраннаяОрганизация;
		
		Набор.Записать();
		ОбновитьПовторноИспользуемыеЗначения();
		
	Исключение
		
		ТекстОшибки = НСтр("ru = 'Не удалось установить выбранную организацию в качестве основной по причине: %1'");
		ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, КраткоеПредставлениеОшибки(ИнформацияОбОшибке())));
			
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

