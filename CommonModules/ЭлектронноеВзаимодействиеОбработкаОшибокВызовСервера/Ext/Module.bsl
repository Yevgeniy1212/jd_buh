﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеОбработкаОшибокВызовСервера: механизм диагностики обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция НачатьПолучениеФайлаДляТехПоддержки(КонтекстОперации, ТехническаяИнформация) Экспорт
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("КонтекстОперации", КонтекстОперации);
	ПараметрыПроцедуры.Вставить("ТехническаяИнформация", ТехническаяИнформация);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение файла для тех.поддержки'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("ЭлектронноеВзаимодействиеОбработкаОшибок.ПолучитьАрхивСИнформациейДляТехПоддержкиВФоне", ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

