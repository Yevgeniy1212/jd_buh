﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВерсияКонфигурацииПоставщика = си_УчетСпецодеждыСервер.НомерВерсииКонфигурации();
	ВерсияИнформационнойБазыКлиента = ОбновлениеИнформационнойБазыСлужебный.ВерсияИБ(си_УчетСпецодеждыСерверПовтИсп.НаименованиеПодсистемы());
	ВерсияБиблиотекЗащиты = си_ПроцедурыМеханизмаЗащиты.ВерсияБиблиотекЗащиты();
	общ_ПостфиксИспользуемогоФайлаБиблиотек = Константы.си_ПостфиксИспользуемогоФайлаБиблиотек.Получить();
КонецПроцедуры

&НаСервере
Процедура СохранитьЗначениеПостфиксаНаСервере()
	Попытка
		Константы.си_ПостфиксИспользуемогоФайлаБиблиотек.Установить(СокрЛП(общ_ПостфиксИспользуемогоФайлаБиблиотек));
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗначениеПостфикса(Команда)
	СохранитьЗначениеПостфиксаНаСервере();
КонецПроцедуры
