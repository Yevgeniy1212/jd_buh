﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Для Каждого ТекСтрокаВедомость Из РаботникиОрганизации Цикл
		
		// регистр Спецпитание 
		Движение = Движения.Спецпитание.Добавить();
		Движение.Регистратор = Ссылка;
		Движение.МесяцУчета = Дата;
		
		Движение.ЦенаЗавтрак = ЦенаЗавтрак;
		Движение.ЦенаОбед = ЦенаОбед;
		Движение.ЦенаУжин = ЦенаУжин;
		Движение.ЦенаНочное = ЦенаНочное;
		
		Движение.ВидПоступления = ВидПоступления;
		Движение.ФизЛицо = ТекСтрокаВедомость.Физлицо;
		Движение.Подразделение = ТекСтрокаВедомость.Подразделение;
		Движение.Должность = ТекСтрокаВедомость.Должность;
		Движение.Номенклатура = Номенклатура;
		
		Движение.КоличествоЗавтрак = ТекСтрокаВедомость.КоличествоЗавтрак;
		Движение.КоличествоОбед = ТекСтрокаВедомость.КоличествоОбед;
		Движение.КоличествоУжин = ТекСтрокаВедомость.КоличествоУжин;
		Движение.КоличествоНочное = ТекСтрокаВедомость.КоличествоНочное;
		Движение.КоличествоИтого = ТекСтрокаВедомость.КоличествоЗавтрак + ТекСтрокаВедомость.КоличествоОбед+ТекСтрокаВедомость.КоличествоУжин+ТекСтрокаВедомость.КоличествоНочное;
		
		Движение.Командировка = ТекСтрокаВедомость.Командировка;
		Движение.Договорник = ТекСтрокаВедомость.Договорник;
		Движение.Идентификатор = Ссылка;
		
	КонецЦикла;
	
КонецПроцедуры


