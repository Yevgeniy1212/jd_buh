﻿

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если Не Отказ Тогда
		
		ДвиженияПоРегистрам();
							
	КонецЕсли;	
	
КонецПроцедуры

Процедура ДвиженияПоРегистрам()

	//Движения по регистру ПроизводственнаяСправка 
	Для Каждого ТекСтрокаИнформацияПоПродукции Из ИнформацияПоПродукции Цикл
		Движение 		                    = Движения.ПроизводственнаяСправка.Добавить();
		Движение.Период                     = Дата;
		Движение.Организация 				= Организация;
		Движение.Участок 					= ТекСтрокаИнформацияПоПродукции.Участок;
		Движение.Подразделение 				= ТекСтрокаИнформацияПоПродукции.Подразделение;
		Движение.Продукция 					= ТекСтрокаИнформацияПоПродукции.Продукция;
		Движение.ВидСкважины 				= ТекСтрокаИнформацияПоПродукции.ВидСкважины;
		Движение.Заказчик 					= ТекСтрокаИнформацияПоПродукции.Заказчик;
		Движение.КоличествоЧасовРаботы 		= ТекСтрокаИнформацияПоПродукции.КоличествоЧасовРаботы;
		Движение.КоличествоЧасовОсвоения 	= ТекСтрокаИнформацияПоПродукции.КоличествоЧасовОсвоения;
		Движение.ЧасыРаботыЭлСтанций 		= ТекСтрокаИнформацияПоПродукции.ЧасыРаботыЭлСтанций;
		Движение.ЧасыРаботыБуровыхРабочих   = ТекСтрокаИнформацияПоПродукции.ЧасыРаботыБуровыхРабочих;
		Движение.ПризнакЗавершонности       = ТекСтрокаИнформацияПоПродукции.ПризнакЗавершонности;
		Движение.ГлубинаЗавершоннойСкважены = ТекСтрокаИнформацияПоПродукции.ГлубинаЗавершоннойСкважены;
		Движение.Сумма   					= ТекСтрокаИнформацияПоПродукции.Сумма;
		Движение.Принята                    = ТекСтрокаИнформацияПоПродукции.Принята;
	КонецЦикла;
	// записываем движения регистров
	Движения.ПроизводственнаяСправка.Записать();

КонецПроцедуры
