﻿&НаКлиенте
Процедура Загрузить(ПараметрыВызова) Экспорт
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Все файлы'; en = 'All files'") + " (*.*)|*.*";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл ГСВС'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		Попытка
			ЧтениеТекста = Новый ЧтениеТекста;
			ЧтениеТекста.Открыть(ДиалогОткрытияФайла.ПолноеИмяФайла);
			СтрокаСДанными = ЧтениеТекста.Прочитать();
			ЧтениеТекста.Закрыть();
		Исключение
			Возврат
		КонецПопытки;
		
		КлючФоновогоЗадания = Новый УникальныйИдентификатор;		
			
		ПараметрыПроцедуры = Новый Структура;
		ПараметрыПроцедуры.Вставить("СтрокаСДанными", СтрокаСДанными);
		ПараметрыПроцедуры.Вставить("КлючФоновогоЗадания", КлючФоновогоЗадания);
		
		ПараметрыВыполнения = ЭСФКлиентСерверПереопределяемый.ПараметрыВыполненияВФоне();
		ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка номенклатуры ГСВС'");
				    
		Результат = ЭСФВызовСервера.ВыполнитьВФоне("ЭСФСерверПереопределяемый.ЗагрузитьСправочникГСВСИзФайлаВФоне", ПараметрыПроцедуры, ПараметрыВыполнения);						
		
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Результат.Вставить("ТекстСообщения", НСтр("ru = 'Загрузка справочника ""Номенклатура ГСВС"" из файла.'"));
		КонецЕсли;
		
		ЭСФКлиент.ОповеститьФормы("ЗагрузкаГСВС_ПроверятьОповещенияФоновогоЗадания", Результат, ПараметрыВызова.КлючФормы);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ = Истина;
	ПоказатьПредупреждение(, НСтр("ru = 'Обработка является служебной и вызывается только из формы списка справочника ""Номенклатура ГСВС"".'"));
	
КонецПроцедуры
