﻿
#Область ПрограммныйИнтерфейс

// Подготавливает структуру дополнительных параметров для печати этикеток.
// 
// Параметры:
// 	СтруктураНастроек - Структура - дополнительные параметры.
//
Процедура СтруктураНастроекЭтикеткаИСМП(СтруктураНастроекИтог) Экспорт
	
	СтруктураНастроек = Обработки.ПечатьКодовМаркировкиИСМПТК.СтруктураНастроек();
	СтруктураНастроек.ОбязательныеПоля.Добавить("Номенклатура");
	СтруктураНастроек.ОбязательныеПоля.Добавить("ШаблонЭтикетки");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Количество");
	СтруктураНастроек.ОбязательныеПоля.Добавить("НомерВГруппе");
	СтруктураНастроек.ОбязательныеПоля.Добавить("СодержимоеКоличество");
	СтруктураНастроек.ОбязательныеПоля.Добавить("КодИдентификации");
	
	Для Каждого КлючИЗначение Из СтруктураНастроек Цикл
		СтруктураНастроекИтог.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Возврат;
	
КонецПроцедуры

// В данной процедуре определяется метод печати этикеток ИС МП
// 
// Параметры:
// 	ТаблицаДляПечати - Массив - Массив строк таблицы (см. РегистрыСведений.ПулКодовМаркировкиСУЗИСМПТК.НоваяТаблицаДанныхДляПечатиЭтикеток)
// 	ТабличныйДокумент - ТабличныйДокумент - результат печати
// 	СтруктураНастроек - Структура - Дополнительне параметры для печати
// 	СтандартнаяОбработка - Булево - Признак использования бублиотечной печати
Процедура ПечатьЭтикетокИСМП(ТаблицаДляПечати, ТабличныйДокумент, СтруктураНастроек, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПечатьЭтикетокОбувь(ТаблицаДляПечати, ТабличныйДокумент, СтруктураНастроек);
	
	Возврат;
	
КонецПроцедуры

// Процедура печати этикеток обуви
// 
// Параметры:
// 	ТаблицаДанных - ТаблицаЗначений - Таблица с исходными данными для печати (см. РегистрыСведений.ПулКодовМаркировкиСУЗИСМПТК.НоваяТаблицаДанныхДляПечатиЭтикеток)
// 	ТабличныйДокумент - ТабличныйДокумент - результат печати
// 	СтруктураНастроек - Структура - Параметры печати
Процедура ПечатьЭтикетокОбувь(ТаблицаДанных, ТабличныйДокумент, СтруктураНастроек) Экспорт

	СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = "ПоляШаблонаИСМП";
	
	// Собираем используемые поля из шаблонов.
	СоответствиеШаблонов = Новый Соответствие;
	Для Каждого СтрокаТЧ Из ТаблицаДанных Цикл
		Если ЗначениеЗаполнено(СтрокаТЧ.ШаблонЭтикетки) И СтрокаТЧ.Количество > 0 Тогда
			СоответствиеШаблонов.Вставить(СтрокаТЧ.ШаблонЭтикетки);
		КонецЕсли;
	КонецЦикла;
	
	Если СтруктураНастроек.Свойство("СтруктураМакетаШаблона")
		И ЗначениеЗаполнено(СтруктураНастроек.СтруктураМакетаШаблона) Тогда
		СоответствиеШаблонов.Вставить(Справочники.ХранилищеШаблоновИСМПТК.ПустаяСсылка());
	КонецЕсли;
	
	// Заполняем коллекцию обязательных полей и формируем соответствие шаблонов
	Для Каждого КлючИЗначение Из СоответствиеШаблонов Цикл
		
		ШаблонЭтикетокИЦенников = КлючИЗначение.Ключ;
		
		Если ЗначениеЗаполнено(ШаблонЭтикетокИЦенников) Тогда
			СтруктураШаблона = КлючИЗначение.Ключ.Шаблон.Получить();
		Иначе
			СтруктураШаблона = СтруктураНастроек.СтруктураМакетаШаблона;
		КонецЕсли;
		
		Если СтруктураШаблона = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Выбранный шаблон этикетки не подходит для печати кодов маркировки!'");
			ОбщегоНазначенияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		// Структура шаблонов
		СтруктураНастроек.СоответствиеШаблоновИСтруктурыШаблонов.Вставить(ШаблонЭтикетокИЦенников, СтруктураШаблона);
		
		// Добавляем в массив обязательных полей поля, присутствующие в печатной форме ценника
		Для Каждого Элемент Из СтруктураШаблона.ПараметрыШаблона Цикл
			СтруктураНастроек.ОбязательныеПоля.Добавить(Элемент.Ключ);
		КонецЦикла;
		
	КонецЦикла;
	
	#Область ПодготовкаСтруктурыДанныхШаблона
	СтруктураНастроек.ИсходныеДанные = ТаблицаДанных;
	
	СтруктураРезультата = Обработки.ПечатьКодовМаркировкиИСМПТК.ПодготовитьСтруктуруДанных(СтруктураНастроек, "ЭтикеткаКодМаркировкиИСМП");
	#КонецОбласти
	
	#Область ФормированиеТабличногоДокумента
	
	Эталон = Обработки.ПечатьКодовМаркировкиИСМПТК.ПолучитьМакет("Эталон");
	КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;

	ПараметрыТабличногоДокументЗаполнены = Ложь;
	
	ПредыдущейНомерВГруппе = Неопределено;
	
	Для Каждого СтрокаТовары Из СтруктураРезультата.Таблица Цикл
		
		КоличествоЭтикеток = СтрокаТовары.Количество;
		Если КоличествоЭтикеток > 0 Тогда
			
			ТекущийНомерВГруппе = СтрокаТовары.НомерВГруппе;
			
			Если Не ПараметрыТабличногоДокументЗаполнены Тогда
				// Применение настроек табличного документа.
				ЗаполнитьЗначенияСвойств(ТабличныйДокумент, СтруктураШаблона.МакетЭтикетки,, "ОбластьПечати, АвтоМасштаб");
				ПараметрыТабличногоДокументЗаполнены = Истина;
			КонецЕсли;
				
			СтруктураШаблона = СтруктураНастроек.СоответствиеШаблоновИСтруктурыШаблонов.Получить(СтрокаТовары.ШаблонЭтикетки);
	
			Область = СтруктураШаблона.МакетЭтикетки.ПолучитьОбласть(СтруктураШаблона.ИмяОбластиПечати);
	                   
			Для Каждого ПараметрШаблона Из СтруктураШаблона.ПараметрыШаблона Цикл
				Если ОбщегоНазначенияИСМПТККлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Область.Параметры, ПараметрШаблона.Значение) Тогда
					НаименованиеКолонки = СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицы.Получить(ИмяПоляВШаблоне(ПараметрШаблона.Ключ));
					Если НаименованиеКолонки <> Неопределено Тогда
						Область.Параметры[ПараметрШаблона.Значение] = СтрокаТовары[НаименованиеКолонки];
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			#Область ПечатьИзображенияШтрихкода
			Для каждого Рисунок Из Область.Рисунки Цикл
				
				//Рисунки в макете могут быть двух видов: код 24 - код маркировки, и код 1 - код ЕАН				
				Если СтрНайти(Рисунок.Имя, ИмяПараметраШтрихкод()) = 1 Тогда //проверяем код маркировки
					
					ЗначениеШтрихкода = СтрокаТовары[СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицы.Получить(ИмяПараметраШтрихкод())];
					Если ЗначениеЗаполнено(ЗначениеШтрихкода) Тогда
						ЗначениеШтрихкодаДляКомпоненты = РазборИОбработкаКодовМаркировкиИСМПТКСлужебный.КодGS1ДляКомпонентыПечати(ЗначениеШтрихкода, СтруктураШаблона.ТипКода);
						
						Если СтруктураШаблона.Свойство("УровеньЧеткости") Тогда
							УровеньЧеткости = СтруктураШаблона.УровеньЧеткости;
						Иначе
							УровеньЧеткости = 1;
						КонецЕсли;
						
						ПараметрыШтрихкода = Новый Структура;
						ПараметрыШтрихкода.Вставить("Ширина",          Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселе) * УровеньЧеткости);
						ПараметрыШтрихкода.Вставить("Высота",          Окр(Рисунок.Высота / КоличествоМиллиметровВПикселе) * УровеньЧеткости);
						ПараметрыШтрихкода.Вставить("Штрихкод",        ЗначениеШтрихкодаДляКомпоненты);
						ПараметрыШтрихкода.Вставить("ТипКода",         СтруктураШаблона.ТипКода);
						ПараметрыШтрихкода.Вставить("ОтображатьТекст", СтруктураШаблона.ОтображатьТекст);
						ПараметрыШтрихкода.Вставить("РазмерШрифта",    СтруктураШаблона.РазмерШрифта * УровеньЧеткости);
						ПараметрыШтрихкода.Вставить("НеGS1", 		   СтрокаТовары.ШаблонЭтикетки.НеGS1);
						ПараметрыШтрихкода.Вставить("ДатаПечати", 	   ТекущаяДатаСеанса());
						
						Если СтруктураШаблона.Свойство("УголПоворота") Тогда
							ПараметрыШтрихкода.Вставить("УголПоворота", СтруктураШаблона.УголПоворота);
						КонецЕсли;
						
						Рисунок.Картинка = ПечатьКодовМаркировкиИСМПТКВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
						
					КонецЕсли;
					
					ИначеЕсли СтрНайти(Рисунок.Имя, ИмяПараметраШтрихкодEAN()) = 1 Тогда //Проверяем код ЕАН 
					
					ЗначениеШтрихкода = СтрокаТовары[СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицы.Получить(ИмяПараметраШтрихкодEAN())];
					Если ЗначениеЗаполнено(ЗначениеШтрихкода) Тогда
						//Нужно проверить какой ЕАН печатаем - ЕАН8 (тип кода компоненты 0) или ЕАН13 (тип кода компоненты 1)
						Если РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ПроверитьКорректностьEAN8(ЗначениеШтрихкода) Тогда
							ТипКодаШтрихкода = 0;
						ИначеЕсли РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ПроверитьКорректностьEAN13(ЗначениеШтрихкода) Тогда
							ТипКодаШтрихкода = 1;
						Иначе
							ТипКодаШтрихкода = 4; //Код128
						КонецЕсли;
							
						ЗначениеШтрихкодаДляКомпоненты = РазборИОбработкаКодовМаркировкиИСМПТКСлужебный.КодGS1ДляКомпонентыПечати(ЗначениеШтрихкода, ТипКодаШтрихкода);
						
						Если СтруктураШаблона.Свойство("УровеньЧеткости") Тогда
							УровеньЧеткости = СтруктураШаблона.УровеньЧеткости;
						Иначе
							УровеньЧеткости = 1;
						КонецЕсли;
						
						ПараметрыШтрихкода = Новый Структура;
						ПараметрыШтрихкода.Вставить("Ширина",          Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселе) * УровеньЧеткости);
						ПараметрыШтрихкода.Вставить("Высота",          Окр(Рисунок.Высота / КоличествоМиллиметровВПикселе) * УровеньЧеткости);
						ПараметрыШтрихкода.Вставить("Штрихкод",        ЗначениеШтрихкодаДляКомпоненты);
						ПараметрыШтрихкода.Вставить("ТипКода",         ТипКодаШтрихкода);
						ПараметрыШтрихкода.Вставить("ОтображатьТекст", СтруктураШаблона.ОтображатьТекст);
						ПараметрыШтрихкода.Вставить("РазмерШрифта",    СтруктураШаблона.РазмерШрифта * УровеньЧеткости);
						ПараметрыШтрихкода.Вставить("НеGS1", 		   СтрокаТовары.ШаблонЭтикетки.НеGS1);
						ПараметрыШтрихкода.Вставить("ДатаПечати", 	   ТекущаяДатаСеанса());
						
						Если СтруктураШаблона.Свойство("УголПоворота") Тогда
							ПараметрыШтрихкода.Вставить("УголПоворота", СтруктураШаблона.УголПоворота);
						КонецЕсли;
						
						Рисунок.Картинка = ПечатьКодовМаркировкиИСМПТКВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			#КонецОбласти
			
			#Область КоличествоЭкземпляров
			Для Инд = 1 По КоличествоЭтикеток Цикл // Цикл по количеству экземпляров
				
				Если СтруктураНастроек.КаждаяЭтикеткаНаНовомЛисте Тогда
					
					ТабличныйДокумент.Вывести(Область);
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					
				Иначе
					
					Если ПредыдущейНомерВГруппе = Неопределено Тогда
						ПредыдущейНомерВГруппе = ТекущийНомерВГруппе;
					КонецЕсли;
					Присоединять = Истина;
					Если ПредыдущейНомерВГруппе <> ТекущийНомерВГруппе Тогда
						ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						ПредыдущейНомерВГруппе = ТекущийНомерВГруппе;
						Присоединять = Ложь;
					КонецЕсли;
					
					Если Присоединять И ТабличныйДокумент.ПроверитьПрисоединение(Область) Тогда
						
						ТабличныйДокумент.Присоединить(Область);
						
					Иначе
						
						Если Не ТабличныйДокумент.ПроверитьВывод(Область) И Присоединять Тогда
							ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						КонецЕсли;
						
						ТабличныйДокумент.Вывести(Область);
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла; // Цикл по количеству экземпляров
			#КонецОбласти
	
		КонецЕсли;
	
	КонецЦикла; // Цикл по строкам таблицы товаров
	
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыУпаковок

Функция ИмяПараметраШтрихкод() 
	
	Возврат "Штрихкод";
	
КонецФункции

Функция ИмяПараметраШтрихкодEAN() 
	
	Возврат "КодEAN";
	
КонецФункции

Функция ИмяПоляВШаблоне(Знач ИмяПоля) Экспорт
	
	ИмяПоля = СтрЗаменить(ИмяПоля, ".DeletionMark", ".ПометкаУдаления");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Owner", ".Владелец");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Code", ".Код");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Parent", ".Родитель");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Predefined", ".Предопределенный");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".IsFolder", ".ЭтоГруппа");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Description", ".Наименование");
	
	Возврат ИмяПоля;
	
КонецФункции

#КонецОбласти

#Область ПечатьСтандартная

Функция НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета) Экспорт
	
	Возврат УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета);
	
КонецФункции

Процедура ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, СинонимМакета, ТабличныйДокумент,	Картинка = Неопределено, ПолныйПутьКМакету = "", ИмяФайлаПечатнойФормы = Неопределено) Экспорт
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, СинонимМакета, ТабличныйДокумент, Картинка, ПолныйПутьКМакету, ИмяФайлаПечатнойФормы);
														

КонецПроцедуры

Функция МакетПечатнойФормы(ИмяМакета, КодЯзыка = Неопределено) Экспорт 
	
	Возврат УправлениеПечатью.МакетПечатнойФормы(ИмяМакета, КодЯзыка);
	
КонецФункции

Функция ТекстЗапросаПечатьАгрегацияКодовМаркировки() Экспорт
	
	Возврат "ВЫБРАТЬ
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка.Организация КАК Организация,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка.Номер КАК Номер,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка.Дата КАК Дата,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка КАК Ссылка,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка.ОрганизацияИдентификационныйНомер КАК ОрганизацияИдентификационныйНомер,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка.ВидПродукции КАК ВидПродукции,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка.ВидУпаковки КАК ВидУпаковки,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка.Ответственный КАК Ответственный,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.ИдентификационныйКодЕдиницыАгрегации КАК ИдентификационныйКодЕдиницыАгрегации,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.КодИдентификацииУпаковки КАК КодИдентификацииУпаковки,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.ЕмкостьУпаковки КАК ЕмкостьУпаковки,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.ФактическоеКоличествоШтук КАК ФактическоеКоличествоШтук
	|ИЗ
	|	Документ.АгрегацияКодовМаркировкиСУЗИСМПТК.Упаковки КАК АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки
	|ГДЕ
	|	АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.Ссылка КАК Ссылка,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.Номенклатура.НаименованиеПолное КАК ПредставлениеНоменклатуры,
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	//|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.Характеристика.НаименованиеПолное КАК ПредставлениеХарактеристики,
	
	//Розница
	//|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.Характеристика.НаименованиеПолное КАК ПредставлениеХарактеристики,
	
	//БК
	|	"""" КАК ПредставлениеХарактеристики,
	///////////////////
	
	|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.Номенклатура КАК Номенклатура,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.Характеристика КАК Характеристика,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.НомерСтроки КАК НомерСтроки,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.GTIN КАК GTIN,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.КодМаркировки КАК КодМаркировки,
	|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.КодИдентификации КАК КодИдентификации
	|ИЗ
	|	Документ.АгрегацияКодовМаркировкиСУЗИСМПТК.АгрегированныеКМ КАК АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АгрегацияКодовМаркировкиСУЗИСМПТК.Упаковки КАК АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки
	|		ПО АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.Ссылка = АгрегацияКодовМаркировкиСУЗИСМПТКУпаковки.Ссылка
	|ГДЕ
	|	АгрегацияКодовМаркировкиСУЗИСМПТКАгрегированныеКМ.Ссылка В(&МассивОбъектов)";
	
КонецФункции

Функция ТекстЗапросаПечатьАгрегацияВнеПроизводстваЦЭДМ() Экспорт
	
	Возврат "ВЫБРАТЬ
	|	АгрегацияВнеПроизводстваИСЦЭДМ.Организация КАК Организация,
	|	АгрегацияВнеПроизводстваИСЦЭДМ.Номер КАК Номер,
	|	АгрегацияВнеПроизводстваИСЦЭДМ.Дата КАК Дата,
	|	АгрегацияВнеПроизводстваИСЦЭДМ.Ссылка КАК Ссылка,
	|	АгрегацияВнеПроизводстваИСЦЭДМ.Поставщик КАК Поставщик,
	|	АгрегацияВнеПроизводстваИСЦЭДМ.ПоставщикИдентификационныйНомер КАК ПоставщикИдентификационныйНомер,
	|	АгрегацияВнеПроизводстваИСЦЭДМ.ВидПродукции КАК ВидПродукции,
	|	АгрегацияВнеПроизводстваИСЦЭДМ.ВидУпаковки КАК ВидУпаковки,
	|	АгрегацияВнеПроизводстваИСЦЭДМ.Автор КАК Автор,
	|	АгрегацияВнеПроизводстваИСЦЭДМ.КодАгрегата КАК КодАгрегата
	|ИЗ
	|	Документ.АгрегацияВнеПроизводстваИСЦЭДМ КАК АгрегацияВнеПроизводстваИСЦЭДМ
	|ГДЕ
	|	АгрегацияВнеПроизводстваИСЦЭДМ.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.Ссылка КАК Ссылка,
	|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.Номенклатура КАК Номенклатура,
	|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.Характеристика КАК Характеристика,
	|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.Номенклатура.НаименованиеПолное КАК ПредставлениеНоменклатуры,
	//БК
	//|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.Характеристика.НаименованиеПолное КАК ПредставлениеХарактеристики,
	|	"""" КАК ПредставлениеХарактеристики,
	|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.НомерСтроки КАК НомерСтроки,
	|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.GTIN КАК GTIN,
	|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.КодМаркировки КАК КодМаркировки,
	|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.КодИдентификации КАК КодИдентификации
	|ИЗ
	|	Документ.АгрегацияВнеПроизводстваИСЦЭДМ.АгрегированныеКМ КАК АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АгрегацияВнеПроизводстваИСЦЭДМ КАК АгрегацияВнеПроизводстваИСЦЭДМ
	|		ПО АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.Ссылка = АгрегацияВнеПроизводстваИСЦЭДМ.Ссылка
	|ГДЕ
	|	АгрегацияВнеПроизводстваИСЦЭДМАгрегированныеКМ.Ссылка В(&МассивОбъектов)";
	
КонецФункции

#КонецОбласти