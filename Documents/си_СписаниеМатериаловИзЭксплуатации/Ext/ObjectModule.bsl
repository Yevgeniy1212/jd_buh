﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.си_СписаниеМатериаловИзЭксплуатации.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	
	//ТаблицаМатериалыКСписанию = си_УчетСпецодеждыСервер.ПодготовитьТаблицуПередачиВЭксплуатацию(ПараметрыПроведения.ТаблицаМатериалы,ПараметрыПроведения,Движения,Отказ);
	//Если Отказ Тогда
	//	Возврат;
	//КонецЕсли;
	
	ЭтоБСО = си_УчетСпецодеждыСерверПовтИсп.ПроверкаНаБСО();
	//Если ЭтоБСО Тогда
	//	ТаблицаВыработкаСотрудников = ПараметрыПроведения.ТаблицаВыработкаСотрудников;
	//Иначе
		ТаблицаВыработкаСотрудников = Новый ТаблицаЗначений;
	//КонецЕсли;
	
	Если СостояниеМатериалов = Перечисления.си_СостоянияМатериалов.НаходящиесяВЭксплуатации Тогда 
		Если СпособСписанияРасходов=Перечисления.си_СпособыСписанияРасходов.ПоПараметрамДокумента  Тогда
			ТаблицаМатериалыКСписанию = си_УчетСпецодеждыСервер.ПодготовитьТаблицуПередачиВЭксплуатацию(ПараметрыПроведения.ТаблицаСпецодежда,ПараметрыПроведения,Движения,Отказ);
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			//си_УчетСпецодеждыСервер.СформироватьДвиженияАмортизацияСпецодеждыВЭксплуатации(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаСпецодежда,ТаблицаВыработкаСотрудников,ПараметрыПроведения.ТаблицаВыработкаМатериалов, Движения, Отказ);
			си_УчетСпецодеждыСервер.СформироватьДвиженияАмортизацияСпецодеждыВЭксплуатации(ПараметрыПроведения.Реквизиты, ТаблицаМатериалыКСписанию,ТаблицаВыработкаСотрудников,ПараметрыПроведения.ТаблицаВыработкаМатериалов, Движения, Отказ);
		Иначе
			ТаблицаМатериалыКСписанию = си_УчетСпецодеждыСервер.ПодготовитьТаблицуПередачиВЭксплуатацию(ПараметрыПроведения.ТаблицаМатериалы,ПараметрыПроведения,Движения,Отказ);
			Если Отказ Тогда
				Возврат;
			КонецЕсли;			
		КонецЕсли;
		
		// в эксплуатации
		си_УчетСпецодеждыУправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ТаблицаМатериалыКСписанию, Движения, Отказ,"Материалы","си_УчетСпецодеждыСервер","ЗарегистрироватьДвиженияМатериалыВЭксплуатации",,"Реквизиты.СостояниеМатериалов = Перечисления.си_СостоянияМатериалов.НаходящиесяВЭксплуатации");
	ИначеЕсли СостояниеМатериалов = Перечисления.си_СостоянияМатериалов.НаходящиесяНаСкладе Тогда 
		Если СпособСписанияРасходов=Перечисления.си_СпособыСписанияРасходов.ПоПараметрамДокумента  Тогда
			ТаблицаМатериалыКСписанию = си_УчетСпецодеждыСервер.ПодготовитьТаблицуПередачиВЭксплуатацию(ПараметрыПроведения.ТаблицаСпецодежда,ПараметрыПроведения,Движения,Отказ);
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			си_УчетСпецодеждыСервер.СформироватьДвиженияАмортизацияСпецодеждыБУ(ПараметрыПроведения.Реквизиты,  ТаблицаМатериалыКСписанию, ТаблицаВыработкаСотрудников,ПараметрыПроведения.ТаблицаВыработкаМатериалов,Движения, Отказ);
		Иначе
			ТаблицаМатериалыКСписанию = си_УчетСпецодеждыСервер.ПодготовитьТаблицуПередачиВЭксплуатацию(ПараметрыПроведения.ТаблицаМатериалы,ПараметрыПроведения,Движения,Отказ);
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		// на складе б/у
		си_УчетСпецодеждыУправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ТаблицаМатериалыКСписанию, Движения, Отказ,"Материалы","си_УчетСпецодеждыСервер","ЗарегистрироватьДвиженияМатериалыБывшиеВЭксплуатации",,"Реквизиты.СостояниеМатериалов = Перечисления.си_СостоянияМатериалов.НаходящиесяНаСкладе");
	ИначеЕсли СостояниеМатериалов = Перечисления.си_СостоянияМатериалов.НаходящиесяНаСкладеНовая Тогда 
		ТаблицаМатериалыКСписанию = си_УчетСпецодеждыСервер.ПодготовитьТаблицуПередачиВЭксплуатацию(ПараметрыПроведения.ТаблицаМатериалы,ПараметрыПроведения,Движения,Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		// на складе новая
		си_УчетСпецодеждыУправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ТаблицаМатериалыКСписанию, Движения, Отказ,"Материалы","си_УчетСпецодеждыСервер","ЗарегистрироватьДвиженияМатериалыНаСкладеНовая",,"Реквизиты.СостояниеМатериалов = Перечисления.си_СостоянияМатериалов.НаходящиесяНаСкладеНовая");
	КонецЕсли;
	
	// по регистрам бухгалтерии
	си_УчетСпецодеждыСервер.СформироватьДвиженияСписаниеМатериаловПоБухУчету(ПараметрыПроведения.Реквизиты, ТаблицаМатериалыКСписанию,ПараметрыПроведения.СпособыОтраженияРасходов, Движения, Отказ);
	
	// возврат на ордерный склад
	си_УчетСпецодеждыУправлениеПроведениемДокументовСервер.СформироватьДвиженияПоРегистрам(ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаМатериалы, Движения, Отказ,"Материалы","си_УчетСпецодеждыСервер","ЗарегистрироватьДвиженияПриходРасходПоОрдерномуСкладу",,"Реквизиты.СостояниеМатериалов <> Перечисления.си_СостоянияМатериалов.НаходящиесяВЭксплуатации");
	
	// Отражение ПР в НУ 
	общ_ПереопределяемыеПроцедурыБКСервер.ОтразитьПостоянныеРазницыВНУ(ЭтотОбъект,ПараметрыПроведения.СписаниеТоваровРеквизиты, Движения, Отказ);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	НеобходимаПострочнаяПроверка = Истина;
	ПараметрыПострочнойПроверки = Новый Структура;
	МассивНепроверяемыхРеквизитов = Новый Массив();
	Если НЕ УчитыватьКПН Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
	КонецЕсли;
	Если СостояниеМатериалов = Перечисления.си_СостоянияМатериалов.НаходящиесяВЭксплуатации Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	Если СостояниеМатериалов = Перечисления.си_СостоянияМатериалов.НаходящиесяНаСкладе 
		ИЛИ СостояниеМатериалов = Перечисления.си_СостоянияМатериалов.НаходящиесяНаСкладеНовая Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПодразделениеОрганизации");
	КонецЕсли;
	си_ОбщегоНазначения.ИсключитьПроверку(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	Если НеобходимаПострочнаяПроверка Тогда 
		Если Материалы.Количество() > 0 Тогда
			ПроверитьЗаполнениеТабличнойЧастиМатериалыПострочно(Материалы, "Материалы", Отказ, ПараметрыПострочнойПроверки);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
		
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
		
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		Документы.си_СписаниеМатериаловИзЭксплуатации.ЗаполнитьПоДокументуОснованию(ЭтотОбъект, ДанныеЗаполнения);
		Возврат;
	КонецЕсли;
	
	общ_ПереопределяемыеПроцедурыБКСервер.ЗаполнитьШапкуДокумента(ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьЗаполнениеТабличнойЧастиМатериалыПострочно(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПараметрыПроверки = Неопределено)
	
	ВыборкаПоСтрокамДокумента = Документы.си_СписаниеМатериаловИзЭксплуатации.СформироватьЗапросПоМатериалыПроверка(ПроверяемаяТабличнаячасть.Выгрузить()).Выбрать();
	
	Пока ВыборкаПоСтрокамДокумента.Следующий() Цикл
		Если ВыборкаПоСтрокамДокумента.ЯвляетсяСпецодеждойИнвентарем = Ложь Тогда
				ТекстСообщения = си_УчетСпецодеждыСервер.ПолучитьТекстСообщения("Колонка", "Корректность", НСтр("ru = 'Номенклатура'"),
						ВыборкаПоСтрокамДокумента.НомерСтроки, ИмяТабличнойЧасти,"выбранная номенклатурная позиция не является спецодеждой/инвентарем");
				Поле = ИмяТабличнойЧасти + "[" + Формат(ВыборкаПоСтрокамДокумента.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Номенклатура";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли