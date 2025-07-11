﻿// Проверяет статус создания резервной копии информационной базы при запуске программы.
//
Процедура ПроверитьСтатусСозданияРезервнойКопии() Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	#Если НЕ ВебКлиент Тогда
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.РазделениеВключено Или Не ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.СверткаИнформационнойБазы.Форма.Форма");
	Возврат;
	#КонецЕсли

КонецПроцедуры

// Вызывается при интерактивном начале работы пользователя с областью данных.
// Соответствует событию ПриНачалеРаботыСистемы модулей приложения.
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ПроверитьСтатусСозданияРезервнойКопии();
	
КонецПроцедуры

// Возвращает имя события для записи журнала регистрации.
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Свертка информационной базы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции
