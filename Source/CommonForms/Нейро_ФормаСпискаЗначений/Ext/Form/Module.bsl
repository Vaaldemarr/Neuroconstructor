﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Список") Тогда
		Список = Параметры.Список;
	ИначеЕсли Параметры.Свойство("Значение") Тогда
		МассивТипов=Новый Массив;
		МассивТипов.Добавить(ТипЗнч(Параметры.Значение));
		ЭтаФорма.Список.ТипЗначения = Новый ОписаниеТипов(МассивТипов);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(Список);
КонецПроцедуры
