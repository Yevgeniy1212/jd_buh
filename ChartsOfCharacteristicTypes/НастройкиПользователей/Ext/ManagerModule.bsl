﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

Процедура ЗаполнитьИдентификаторыНастроекПользователя() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиПользователей.Ссылка,
	|	НастройкиПользователей.ИмяПредопределенныхДанных,
	|	НастройкиПользователей.Предопределенный,
	|	НастройкиПользователей.ЭтоГруппа
	|ИЗ
	|	ПланВидовХарактеристик.НастройкиПользователей КАК НастройкиПользователей
	|ГДЕ
	|	НастройкиПользователей.Идентификатор = """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивИдентификаторов = Новый Массив;
	Пока Выборка.Следующий() Цикл 
		
		Если Выборка.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		
		НастройкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		Если Выборка.Предопределенный Тогда 
			НастройкаОбъект.Идентификатор = Выборка.ИмяПредопределенныхДанных;
		Иначе 
			НастройкаОбъект.Идентификатор = ОбщегоНазначенияБККлиентСервер.ПолучитьИдентификатор(НастройкаОбъект.Наименование);
			Если МассивИдентификаторов.Найти(НастройкаОбъект.Идентификатор) = Неопределено Тогда 
				МассивИдентификаторов.Добавить(НастройкаОбъект.Идентификатор);
			Иначе // если вдруг были добавлены 2 настройки с одинаковым наименованием, то сформируем идентификатор по набору "Наименование" + "Код"
				НастройкаОбъект.Идентификатор = НастройкаОбъект.Идентификатор + НастройкаОбъект.Код;
				МассивИдентификаторов.Добавить(НастройкаОбъект.Идентификатор);
			КонецЕсли;
		КонецЕсли;
		
		НастройкаОбъект.ДополнительныеСвойства.Вставить("ЗаполнениеИдентификаторовПриОбновлении", Истина);
		
		НастройкаОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
