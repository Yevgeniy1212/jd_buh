﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Заголовок = Параметры.Заголовок;
	Элементы.ФорматированнаяСтрока.Заголовок = Параметры.ФорматированнаяСтрока;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФорматированнаяСтрокаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	Если СтрНачинаетсяС(НавигационнаяСсылка, "file://") Тогда
		СтандартнаяОбработка = Ложь;
		ПутьКФайлу = СтрЗаменить(НавигационнаяСсылка, "file://", "");
		ФайловаяСистемаКлиент.ОткрытьФайл(ПутьКФайлу);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
