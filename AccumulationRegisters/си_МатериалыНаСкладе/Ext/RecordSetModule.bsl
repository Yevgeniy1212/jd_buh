﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	#Область ОбработчикиСобытийФормы
	
	Процедура ПередЗаписью(Отказ, Замещение)
		
		Для Каждого Движение Из ЭтотОбъект Цикл 
			Если Не ЗначениеЗаполнено(Движение.СостояниеСпецодежды) Тогда 
				Движение.СостояниеСпецодежды = Перечисления.си_СостояниеСпецодеждыИИнвентаряНаСкладе.НаСкладеБывшаяВУпотреблении;
			КонецЕсли;
		КонецЦикла;
		
	КонецПроцедуры
	#КонецОбласти
	
#Иначе
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли