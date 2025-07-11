﻿////////////////////////////////////////////////////////////////////////////////
// РегламентированнаяОтчетностьКлиентСервер: 
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Функция получает обрезанный код строки (обрезуются лишние пробелы и точки)
//
Функция ОбрезатьКодСтроки(КодСтроки) Экспорт;
	
	ТекКодСтроки = СокрЛП(КодСтроки);
	
	Пока Найти(Прав(ТекКодСтроки,1)," ") ИЛИ Найти(Прав(ТекКодСтроки,1),".") Цикл 
		ТекКодСтроки = СокрЛП(ТекКодСтроки);
		Если Прав(ТекКодСтроки,1) ="." Тогда 
			КоличествоСимволовВСтроке = СтрДлина(ТекКодСтроки);
			ТекКодСтроки = Лев(ТекКодСтроки,КоличествоСимволовВСтроке-1);
		КонецЕсли;
	КонецЦикла;
		
	Возврат ТекКодСтроки;
	
КонецФункции
                           
//Функция получает имя области из кода декларации
//
Функция ПреобразоватьКодДекларации(КодСтроки) Экспорт;
	
	ИмяСтроки = "s_" + СтрЗаменить(КодСтроки, ".", "_");
	ИмяСтроки = Нрег(СтрЗаменить(ИмяСтроки, " ", ""));
	Пока (Прав(ИмяСтроки,1)="_") Цикл 
		КоличествоСимволовВСтроке = СтрДлина(ИмяСтроки);
		ИмяСтроки = Нрег(Лев(ИмяСтроки,КоличествоСимволовВСтроке-1));
	КонецЦикла;
	Возврат ИмяСтроки;
	
КонецФункции

Функция ПустоеЗначениеТипа(ЗаданныйТип) Экспорт

	Если ЗаданныйТип = Тип("Число") Тогда
		Возврат 0;

	ИначеЕсли ЗаданныйТип = Тип("Строка") Тогда
		Возврат "";

	ИначеЕсли ЗаданныйТип = Тип("Дата") Тогда
		Возврат '00010101000000';

	ИначеЕсли ЗаданныйТип = Тип("Булево") Тогда
		Возврат Ложь;

	Иначе
		Возврат Новый (ЗаданныйТип);

	КонецЕсли;

КонецФункции

Функция КоличествоФормСоответствующихВыбранномуПериоду(Форма) Экспорт

	ИтоговоеКоличество = 0;

	Для Каждого ЭлФорма Из Форма.мТаблицаФормОтчета Цикл

		ДатаНачалаДействияФормы = ЭлФорма.ДатаНачалоДействия;
		ДатаКонцаДействияФормы  = КонецДня(?(ЭлФорма.ДатаКонецДействия = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата")), '20291231', ЭлФорма.ДатаКонецДействия));

		Если Форма.мДатаКонцаПериодаОтчета <= ДатаКонцаДействияФормы
		   И Форма.мДатаКонцаПериодаОтчета >= ДатаНачалаДействияФормы Тогда

			ИтоговоеКоличество = ИтоговоеКоличество + 1; 

		КонецЕсли;

	КонецЦикла;

	Возврат ИтоговоеКоличество;

КонецФункции

Процедура ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма) Экспорт

	ТаблицаФормОтчета = РегламентированнаяОтчетностьКлиентСервер.ПолучитьТаблицуОтчетовДействующихВВыбранныйПериод(Форма);
	Для Каждого Стр Из ТаблицаФормОтчета Цикл
		Если Стр.ДатаКонецДействия = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата")) Тогда
			Стр.ДатаКонецДействия = '20291231';
		КонецЕсли;
	КонецЦикла;

	ТаблицаФормОтчета.Сортировать("ДатаКонецДействия Убыв");

	Для Каждого Строка Из ТаблицаФормОтчета Цикл
		Если (Строка.ДатаНачалоДействия > КонецДня(Форма.мДатаКонцаПериодаОтчета)) ИЛИ
			((Строка.ДатаКонецДействия > '00010101000000') И (Строка.ДатаКонецДействия < НачалоДня(Форма.мДатаКонцаПериодаОтчета))) Тогда

			Продолжить;
		КонецЕсли;

		Форма.мВыбраннаяФорма = Строка.ФормаОтчета;
		Форма.ОписаниеНормативДок = Строка.ОписаниеОтчета;

		Возврат;
	КонецЦикла;

	// Если не удалось найти форму, соответствующую выбранному периоду,
	// то по умолчанию выдаем текущую (действующую) форму.
	Если Форма.мВыбраннаяФорма = Неопределено Тогда
		Если ТаблицаФормОтчета.Количество() >= 1 Тогда
			мВыбраннаяФорма = Форма.мТаблицаФормОтчета[0].ФормаОтчета;
			Форма.ОписаниеНормативДок = Форма.мТаблицаФормОтчета[0].ОписаниеОтчета;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьТаблицуОтчетовДействующихВВыбранныйПериод(Форма) Экспорт

	#Если НаКлиенте Тогда
		Форма.РезультирующаяТаблица.Очистить();
	#Иначе
		// Объявим таблицу результата.
		РезультирующаяТаблица = Форма.мТаблицаФормОтчета.Выгрузить();
		РезультирующаяТаблица.Очистить();
	#КонецЕсли
	
	// Осуществим перебор по таблице содеражащей формы отчетов и периоды действий.
	Для Каждого ЭлФорма Из Форма.мТаблицаФормОтчета Цикл

		ДатаНачалаДействияФормы = ЭлФорма.ДатаНачалоДействия;
		ДатаКонцаДействияФормы  = КонецДня(?(ЭлФорма.ДатаКонецДействия = ПустоеЗначениеТипа(Тип("Дата")), '20291231', ЭлФорма.ДатаКонецДействия));

		Если Форма.мДатаКонцаПериодаОтчета <= ДатаКонцаДействияФормы
		   И Форма.мДатаКонцаПериодаОтчета >= ДатаНачалаДействияФормы Тогда

			// Перебираемая запись из таблицы форм удовлетворяет текущим параметрам
			// учитывая конец периода отчета.
			#Если НаКлиенте Тогда
				НоваяФорма = Форма.РезультирующаяТаблица.Добавить();
			#Иначе
				НоваяФорма = РезультирующаяТаблица.Добавить();
			#КонецЕсли
			НоваяФорма.ФормаОтчета        = ЭлФорма.ФормаОтчета;
			НоваяФорма.ОписаниеОтчета     = ЭлФорма.ОписаниеОтчета;
			НоваяФорма.ДатаНачалоДействия = ЭлФорма.ДатаНачалоДействия;
			НоваяФорма.ДатаКонецДействия  = ЭлФорма.ДатаКонецДействия;

		КонецЕсли;

	КонецЦикла;

	#Если НаКлиенте Тогда
		Возврат Форма.РезультирующаяТаблица;
	#Иначе
		Возврат РезультирующаяТаблица;
	#КонецЕсли
	
КонецФункции

// Фильтр для диалогов выбора или сохранения дополнительных отчетов и обработок.
Функция ФильтрДиалоговВыбораИСохраненияРегламентированногоОтчета() Экспорт
	
	Фильтр = НСтр("ru = 'xml-файл|*.xml'");	
	Возврат Фильтр;
	
КонецФункции

//Процедура сообщает пользователю о том, что выгрузка  данных в формате XML удачно завершена
//и рекомендации для дальнейшего использования файла
//
Процедура ВыдатьОтветПриВыгрузке()  Экспорт
	ТекстСообщения = НСтр("ru = 'Выгрузка данных закончена! Если Вы планируете сдавать отчет в электронной форме, Вам необходимо открыть данный файл в соответствующем программном обеспечении по вводу и передаче форм налоговой отчетности, предоставляемой налоговым комитетом, заполнить недостающие данные и ОБЯЗАТЕЛЬНО сохранить его в этой программе!'");			
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);						
КонецПроцедуры

// Выполянет преобразование цифры в римскую нотацию 
//
// Параметры
//		Цифра - число, целое, от 0 до 9
//      ВВерхнемРегистре - булево, признак регистра.
//
// Возвращаемое значение
//		строка
//
// Описание
//		записывает "обычную" цифру римскими цифрами,
//		например:
//				ПреобразоватьЦифруВРимскуюНотацию(7) = "VII"
//
Функция ПреобразоватьЦифруВРимскуюНотацию(Цифра, ВВерхнемРегистре = Истина) Экспорт
	РимскаяЕдиница = "I";
	РимскаяПятерка = "V";
	РимскаяДесятка = "X";
	
	РимскаяЦифра="";
	Если Цифра = 1 Тогда
		РимскаяЦифра = РимскаяЕдиница
	ИначеЕсли Цифра = 2 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 3 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 4 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяПятерка;
	ИначеЕсли Цифра = 5 Тогда
		РимскаяЦифра = РимскаяПятерка;
	ИначеЕсли Цифра = 6 Тогда
		РимскаяЦифра = РимскаяПятерка + РимскаяЕдиница;
	ИначеЕсли Цифра = 7 Тогда
		РимскаяЦифра = РимскаяПятерка + РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 8 Тогда
		РимскаяЦифра = РимскаяПятерка + РимскаяЕдиница + РимскаяЕдиница + РимскаяЕдиница;
	ИначеЕсли Цифра = 9 Тогда
		РимскаяЦифра = РимскаяЕдиница + РимскаяДесятка;
	КонецЕсли;
	
	Возврат ?(ВВерхнемРегистре, ВРЕГ(РимскаяЦифра), НРЕГ(РимскаяЦифра));
	
КонецФункции //ПреобразоватьЦифруВРимскуюНотацию

// Очищает данные в структурах: мСписокСохранения, 
// мСписокВычисляемыхЯчеек, мСтруктураОтчета
// Параметры:
//     ИмяОчищаемойФормы - имя формы, подлежащей очистке
//     ТекПризнакМногострочности - признак многострочности формы
//     Вложенность - признак очистки доп.форм данной формы
//
Процедура ОчиститьДанныеРегОтчета(Форма, ИмяОчищаемойФормы, Вложенность = Ложь) Экспорт
	
	//СтрокаФормы = РегламентированнаяОтчетностьКлиентСервер.НайтиСтрокуДерева(Форма.мСписокФормБезИерархии, Новый Структура("КодФормы", Форма.КодФормы));
	//
	//ТекПризнакМногострочности = СтрокаФормы.Многострочность;
	//
	//Если СтрокаФормы.ПризнакОсновной Тогда 
	//	
	//	Если Вложенность Тогда 
	//		Форма.Очистить(ИмяОчищаемойФормы,Истина);
	//		Форма.мСписокСохранения.Очистить();
	//		//очищаем данные для выгрузки
	//		РегламентированнаяОтчетность.ЗаполнитьСтруктуруФормРегОтчета(Форма.ЭтотОбъект);
	//		ПоказатьОповещениеПользователя(НСТР("ru = 'Данные в приложениях очищены!'"));			
	//	Иначе
	//		Форма.Очистить(ИмяОчищаемойФормы);
	//		Если Форма.мСписокСохранения.Свойство("ПоказателиОтчета") Тогда
	//			Форма.мСписокСохранения.Удалить("ПоказателиОтчета");
	//		КонецЕсли;
	//	КонецЕсли;                                          		
	//	
	//ИначеЕсли ТекПризнакМногострочности = Истина Тогда 
	//	
	//	Форма.Очистить(ИмяОчищаемойФормы);
	//	СтрокаФормы.Выгружать = 0;		
	//	ВложенныеЭлементы = СтрокаФормы.ПолучитьЭлементы();
	//	Если Вложенность И ВложенныеЭлементы.Количество() > 0 Тогда
	//		Для Каждого ПодчиненнаяСтрока Из ВложенныеЭлементы Цикл
	//			ОчиститьДанныеРегОтчета(Форма, ПодчиненнаяСтрока.КодФормы, Истина);
	//		КонецЦикла;
	//	КонецЕсли;				
	//					
	//Иначе //для обычных форм
	//	
	//	Форма.Очистить(ИмяОчищаемойФормы);
	//	СтрокаФормы.Выгружать = 0;
	//			
	//	ВложенныеЭлементы = СтрокаФормы.ПолучитьЭлементы();
	//	Если Вложенность И ВложенныеЭлементы.Количество() > 0 Тогда
	//		Для Каждого ПодчиненнаяСтрока Из ВложенныеЭлементы Цикл
	//			ОчиститьДанныеРегОтчета(Форма, ПодчиненнаяСтрока.КодФормы, Истина);
	//		КонецЦикла;
	//	КонецЕсли;				
	//					
	//КонецЕсли;	
	
КонецПроцедуры // ОчиститьДанныеРегОтчета()
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПредставлениеДокументаРеглОтч(Док) Экспорт
	
	ШаблонПредставления = НСтр("ru = '%1 за %2'");
	
	Если ТипЗнч(Док) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		Представление = Док.НаименованиеОтчета;
	ИначеЕсли ТипЗнч(Док) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		Представление = Док.Отчет;
	Иначе
		Представление = "";
	КонецЕсли;
	
	Возврат СтрШаблон(ШаблонПредставления, Представление, ПредставлениеПериода(НачалоДня(Док.ДатаНачала), КонецДня(Док.ДатаОкончания), "ФП=Истина"))
	
КонецФункции

Функция СвойствоОпределено(Объект, ИмяСвойства) Экспорт
	
	ГУИД = Новый УникальныйИдентификатор;
	ВремСтрукт = Новый Структура(ИмяСвойства, ГУИД);
	ЗаполнитьЗначенияСвойств(ВремСтрукт, Объект);
	Возврат (ВремСтрукт[ИмяСвойства] <> ГУИД);
	
КонецФункции

Функция НайтиСтрокуДерева(КоллекцияЭлементовДерева, СтруктураПоиска) Экспорт

	Для Каждого СтрокаДерева Из КоллекцияЭлементовДерева.ПолучитьЭлементы() Цикл 
				
		Для Каждого ЗначениеОтбора из СтруктураПоиска Цикл
			ПолеОтбора = ЗначениеОтбора.Ключ;
			ЗначениеОтбора = ЗначениеОтбора.Значение;
			
			Если СтрокаДерева[ПолеОтбора]= ЗначениеОтбора Тогда 
				ИдентификаторСтроки = СтрокаДерева.ПолучитьИдентификатор(); 
				ПрекратитьПоиск = Истина;  				
				Возврат СтрокаДерева; 				
			КонецЕсли; 
		КонецЦикла;
		
		КоллекцияЭлементов = СтрокаДерева.ПолучитьЭлементы(); 
		
		Если КоллекцияЭлементов.Количество() > 0  Тогда 
			
			Возврат	НайтиСтрокуДерева(СтрокаДерева, СтруктураПоиска); 
			
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат Неопределено
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ПРОЦЕДУР ЗАПОЛНЕНИЯ ОТЧЕТОВ

Функция ПолучитьИИНиКППКонтрагента(НомерНалоговойРегистрацииВСтранеРезидентства) Экспорт
	ИННКПП = СокрЛП(НомерНалоговойРегистрацииВСтранеРезидентства);
	Результат = Новый Структура("ИНН, КПП");
	ПозицияРазделителя = Найти(ИННКПП, "/");
	Если ПозицияРазделителя > 0 Тогда
		// Есть КПП, разбиваем на составляющие
		Результат.ИНН = Лев(ИННКПП, ПозицияРазделителя - 1);
		Результат.КПП = Прав(ИННКПП, СтрДлина(ИННКПП) - ПозицияРазделителя);
	Иначе
		Результат.ИНН = ИННКПП;	
		Результат.КПП = "";
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции