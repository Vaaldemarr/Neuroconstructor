﻿&НаСервере
Функция СформироватьТекстПрограммыИмпортМодели(ФайлИсточник, Параметры) Экспорт
	ТекстПрограммы=
	"import sys
	|sys.stderr = open(u'"+СтрЗаменить(Параметры.ФайлОшибок,"\","\\")+"', 'w')
	|"+Нейро_ОбщийМодуль.ИдИмпортKeras()+"
	|sys.stdout = open(u'"+СтрЗаменить(Параметры.ФайлСообщений,"\","\\")+"', 'w')
	|import json
	|model = keras.models.load_model(u'"+СтрЗаменить(ФайлИсточник,"\","\\")+"')
	|model_json = model.to_json()
	|with open(u'"+СтрЗаменить(Параметры.ФайлМодели,"\","\\")+"', 'w') as json_file:
	|    json_file.write(model_json)";
	Возврат ТекстПрограммы;
КонецФункции

&НаСервере
Функция ПостроитьДеревоМоделиНаСервере(ТекстМоделиJSON) Экспорт
	Результат = Новый Структура("Ошибка, Сообщение", Ложь, "");
	
	ДеревоJSON=Новый ДеревоЗначений;
	ДеревоJSON.Колонки.Добавить("Свойство");
	ДеревоJSON.Колонки.Добавить("Значение");
	ДеревоJSON.Колонки.Добавить("Тип");	
	ДеревоJSON.Строки.Очистить();
	Нейро_СозданиеМоделиНаСервере.ОбработатьМодельИзСтрокиJSONНаСервере(ТекстМоделиJSON, ДеревоJSON); //Заполняет ДеревоJSON
	СтруктураДереваJSON = Нейро_СозданиеМоделиНаСервере.ПеребратьОбъектJSONНаСервере(ДеревоJSON); //Преобразует ДеревоJSON в СтруктураДереваJSON с сохранением построения
	Если СтруктураДереваJSON.Свойство("class_name") Тогда
		Если СтруктураДереваJSON.class_name<>"Model" Тогда
			Результат.Ошибка = Истина;
			Результат.Сообщение = "Неверный класс объекта: "+Символ(34)+СтруктураДереваJSON.class_name+Символ(34);
			Возврат Результат
		КонецЕсли;
	Иначе
		Результат.Ошибка = Истина;
		Результат.Сообщение = "Не удалось определить класс объекта!";
		Возврат Результат
	КонецЕсли;
	СтруктураМодели=Новый Структура("Слои, Входы, Выходы, Формы, Входящие");
	СтруктураМодели.Слои     = Новый Массив;
	СтруктураМодели.Входы    = Новый Массив;
	СтруктураМодели.Выходы   = Новый Массив;
	СтруктураМодели.Формы    = Новый Массив;
	СтруктураМодели.Входящие = Новый Массив;
	Нейро_СозданиеМоделиНаСервере.ПеребратьМодельИзСтруктурыJSONНаСервере(СтруктураМодели, СтруктураДереваJSON.config); //Из СтруктураДереваJSON создает СтруктураМодели с преобразованиями
	
	Результат=Новый Структура;
	Результат.Вставить("ДеревоJSON", ДеревоJSON);
	Результат.Вставить("СтруктураДереваJSON", СтруктураДереваJSON);
	Результат.Вставить("СтруктураМодели", СтруктураМодели);
	
	Возврат Результат
КонецФункции

&НаСервере
Функция СформироватьПредставленияПараметров(СтруктураМодели) Экспорт
	Результат = Новый Структура; 
	Для Каждого СтруктураСлоя Из СтруктураМодели.Слои Цикл
		Если ТипЗнч(СтруктураСлоя.ТипСлоя)=Тип("ПеречислениеСсылка.Нейро_ТипыСлоев") Тогда
			МассивПараметров = Нейро_ОбщийМодуль.ПолучитьПараметрыСлоя(СтруктураСлоя.ТипСлоя);
			МассивТекстов = Новый Массив;
			Для Каждого Параметр Из СтруктураСлоя.Параметры Цикл
				ИмяПараметраАнг = Параметр.Ключ; ИмяПараметраРус = Параметр.Ключ;
				Если Параметр.Ключ="batch_input_shape" Тогда
					ИмяПараметраРус = "Входная форма пакета";
				КонецЕсли;
				Индекс = НайтиПараметрПоИдентификатору(Параметр.Ключ, МассивПараметров);
				Если Индекс<>Неопределено Тогда
					ИмяПараметраАнг = МассивПараметров[Индекс].Анг;
					ИмяПараметраРус = МассивПараметров[Индекс].Рус;
				КонецЕсли;
				//ЗначениеПараметраАнг = Неопределено; ЗначениеПараметраРус = Неопределено;
				Если ТипЗнч(Параметр.Значение)=Тип("Массив") Тогда
					ЗначениеПараметра = ПредставлениеМассива(Параметр.Значение);
					ЗначениеПараметраАнг = ЗначениеПараметра;
					ЗначениеПараметраРус = ЗначениеПараметра;
				ИначеЕсли ТипЗнч(Параметр.Значение)=Тип("Структура") Тогда
					Оболочки = Нейро_ОбщийМодуль.ПолучитьТипыСлояПоВидуСлоя(Перечисления.Нейро_ВидыСлоев.LayerWrappers);
					ЭтоВложенныйСлой = Ложь;
					Если Параметр.Ключ="layer" Тогда
						Элемент = Оболочки.НайтиПоЗначению(СтруктураСлоя.ТипСлоя);
						Если Элемент<>Неопределено Тогда ЭтоВложенныйСлой=Истина КонецЕсли;
					КонецЕсли;
					Если ЭтоВложенныйСлой Тогда
						ЗначениеПараметраАнг = Параметр.Значение.Имя;
						ЗначениеПараметраРус = Параметр.Значение.Имя;
					Иначе
						ЗначениеПараметра = ПредставлениеОбъекта(?(Индекс=Неопределено,Неопределено,МассивПараметров[Индекс]), Параметр.Значение);
						ЗначениеПараметраАнг = ЗначениеПараметра.Анг;
						ЗначениеПараметраРус = ЗначениеПараметра.Рус;
					КонецЕсли;
				Иначе
					//ЗначениеПараметра = Параметр.Значение;
					ЗначениеПараметраАнг = Параметр.Значение;
					ЗначениеПараметраРус = Параметр.Значение;
					Если Индекс<>Неопределено Тогда
						ЗначениеПараметраАнг = Нейро_ОбщийМодуль.СформироватьПрограммныйТекстИзЗначения("", МассивПараметров[Индекс].Тип, Параметр.Значение)
					ИначеЕсли ИмяПараметраАнг="dtype" Тогда
						ИмяПараметраРус="Тип";
						ЗначениеПараметраРус = Нейро_ОбщийМодуль.ПолучитьЗначениеПеречисленияПоТексту("Нейро_ТипыNumPy", Параметр.Значение);
						//ЗначениеПараметра = ПредставлениеОбъекта(Перечисления.Нейро_Типы.ТипNumPy, Параметр.Значение);
					КонецЕсли;
				КонецЕсли;
				МассивТекстов.Добавить(Новый Структура("Анг, Рус",ИмяПараметраАнг+"="+ЗначениеПараметраАнг,ИмяПараметраРус+"="+ЗначениеПараметраРус));
			КонецЦикла;
			СтруктураСлоя.Вставить("ПараметрыТекст", МассивТекстов);
		Иначе
			МассивТекстов = Новый Массив;
			Для Каждого СтруктураСлояМодели Из СтруктураСлоя.Параметры.Слои Цикл
				МассивТекстов.Добавить(Новый Структура("Анг, Рус",СтруктураСлояМодели.Имя+": "+СтруктураСлояМодели.ИдСлоя,СтруктураСлояМодели.Имя+": "+СтруктураСлояМодели.ТипСлоя));
			КонецЦикла;
			СтруктураСлоя.Вставить("ПараметрыТекст", МассивТекстов);
			//ДобавитьМодельВТЧ(Объект, НовыйСлой.Слой, НовыйСлой.ИмяУникальное);
			СформироватьПредставленияПараметров(СтруктураСлоя.Параметры);
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция НайтиПараметрПоИдентификатору(Идентификатор, МассивПараметров)
	Для Сч = 0 По МассивПараметров.Количество()-1 Цикл
		Если МассивПараметров[Сч].Анг = Идентификатор Тогда Возврат Сч КонецЕсли;
	КонецЦикла;
КонецФункции

&НаСервере
Функция ПредставлениеМассива(МассивЗначений)
	Если МассивЗначений.Количество()=0 Тогда Возврат "" КонецЕсли;
	Результат = "";
	Для Сч = 0 По МассивЗначений.Количество()-1 Цикл
		Если Результат<>"" Тогда Результат=Результат+", " КонецЕсли;
		Если МассивЗначений[Сч]=Null Тогда
			Результат=Результат+"None";
		Иначе
			Результат=Результат+СокрЛП(МассивЗначений[Сч]);
		КонецЕсли;
	КонецЦикла;
	Возврат "("+Результат+")"
КонецФункции

&НаСервере
Функция ПредставлениеОбъекта(ОписаниеПараметра, СтруктураЗначения)
	//Если МассивЗначений.Количество()=0 Тогда Возврат "" КонецЕсли;
	ТипОпределен = Ложь;
	Если СтруктураЗначения.Свойство("Объект") Тогда
		ТипОпределен=Истина;
		ОбъектТекстАнг = СокрЛП(СтруктураЗначения.Объект);
		ОбъектТекстРус = СокрЛП(СтруктураЗначения.Объект);
	ИначеЕсли СтруктураЗначения.Свойство("class_name") Тогда
		ОбъектТекстАнг = СокрЛП(СтруктураЗначения.class_name);
		ОбъектТекстРус = СокрЛП(СтруктураЗначения.class_name);
	Иначе
		Возврат "???";
	КонецЕсли;
	Результат = Новый Структура("Рус, Анг", "",""); 
	ОписаниеОбъекта = Неопределено;
	Если ОписаниеПараметра<>Неопределено Тогда
		МассивПараметров = Нейро_ОбщийМодуль.ПолучитьПараметрыИзПеречисленияТипа(ОписаниеПараметра.Тип);
		Для Каждого Параметр Из МассивПараметров Цикл
			Если Параметр.Значение = СтруктураЗначения.Объект Тогда
				ОписаниеОбъекта = Параметр; 
				ОбъектТекстАнг = ОписаниеОбъекта.Анг;
				ОбъектТекстРус = ОписаниеОбъекта.Рус;
				Прервать
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	//ТекстРус = ""; ТекстАнг = "";
	Если ТипОпределен Тогда
		Параметры="Параметры"
	Иначе
		Параметры="config"
	КонецЕсли;
	МассивТекстов = Новый Массив;
	Для Каждого Параметр Из СтруктураЗначения[Параметры] Цикл
		ТекстАнг = Параметр.Ключ; ТекстРус = Параметр.Ключ; Индекс = Неопределено;
		Если ОписаниеОбъекта<>Неопределено Тогда
			Индекс = НайтиПараметрПоИдентификатору(Параметр.Ключ, ОписаниеОбъекта.Доп);
			Если Индекс<>Неопределено Тогда
				ТекстРус = ОписаниеОбъекта.Доп[Индекс].Рус
			ИначеЕсли Параметр.Ключ="dtype" Тогда
				ТекстРус = "Тип"
			КонецЕсли;
		КонецЕсли;
		Если ТипЗнч(Параметр.Значение)=Тип("Массив") Тогда
			ЗначениеАнг = ПредставлениеМассива(Параметр.Значение);
			ЗначениеРус = ПредставлениеМассива(Параметр.Значение);
		ИначеЕсли ТипЗнч(Параметр.Значение)=Тип("Структура") Тогда
			ЗначениеПараметра = ПредставлениеОбъекта(?(Индекс=Неопределено,Неопределено,ОписаниеОбъекта.Доп[Индекс]), Параметр.Значение);
			ЗначениеАнг = ЗначениеПараметра.Анг;
			ЗначениеРус = ЗначениеПараметра.Рус;
		Иначе
			Если Индекс=Неопределено Тогда
				ЗначениеАнг = Параметр.Значение;
				Если Параметр.Ключ="dtype" Тогда
					ЗначениеРус = Нейро_ОбщийМодуль.ПолучитьЗначениеПеречисленияПоТексту("Нейро_ТипыNumPy", Параметр.Значение);
				Иначе
					ЗначениеРус = ?(Параметр.Значение=Null,"Неопределено",Параметр.Значение);
				КонецЕсли;
			Иначе
				Если Параметр.Значение=Null Тогда
					ЗначениеАнг = "None"
				Иначе
					ЗначениеАнг = Нейро_ОбщийМодуль.СформироватьПрограммныйТекстИзЗначения("", ОписаниеОбъекта.Доп[Индекс].Тип, Параметр.Значение)
				КонецЕсли;
				ЗначениеРус = ?(Параметр.Значение=Null,"Неопределено",Параметр.Значение);
			КонецЕсли;
		КонецЕсли;
		МассивТекстов.Добавить(Новый Структура("Анг, Рус, ЗнАнг, ЗнРус", ТекстАнг, ТекстРус, ЗначениеАнг, ЗначениеРус));
	КонецЦикла;
	//Для Сч = 0 По МассивЗначений.Количество()-1 Цикл
	//	Если Результат<>"" Тогда Результат=Результат+", " КонецЕсли;
	//	Результат=Результат+СокрЛП(МассивЗначений[Сч]);
	//КонецЦикла;
	ТекстАнг = ""; ТекстРус = "";
	Для Каждого Тексты Из МассивТекстов Цикл
		Если ТекстАнг<>"" Тогда ТекстАнг=ТекстАнг+", " КонецЕсли;
		ТекстАнг=ТекстАнг+Тексты.Анг+"="+Тексты.ЗнАнг;
		Если ТекстРус<>"" Тогда ТекстРус=ТекстРус+", " КонецЕсли;
		ТекстРус=ТекстРус+Тексты.Рус+"="+Тексты.ЗнРус;
	КонецЦикла;
	Результат.Анг = ОбъектТекстАнг;
	Если ТекстАнг<>"" Тогда
		Результат.Анг=Результат.Анг+"("+ТекстАнг+")";
	КонецЕсли;
	Результат.Рус = ОбъектТекстРус;
	Если ТекстРус<>"" Тогда
		Результат.Рус=Результат.Рус+"("+ТекстРус+")";
	КонецЕсли;
	Возврат Результат
КонецФункции

&НаСервере
Функция СформироватьТекстПрограммыДиаграммыМодели(Параметры) Экспорт
	//СтруктураПараметров.Вставить("ФайлОшибок", ПрефиксИмени+"_err.txt");
	//СтруктураПараметров.Вставить("ФайлСообщений", ПрефиксИмени+"_msg.txt");
	//СтруктураПараметров.Вставить("ФайлРезультатов", ИмяФайлаДиаграммы);
	//СтруктураПараметров.Вставить("ФайлМодели", ИмяФайлаМодели);
	
	ТекстПрограммы=
	"import sys
	|sys.stderr = open(u'"+СтрЗаменить(Параметры.ФайлОшибок,"\","\\")+"', 'w')
	|"+Нейро_ОбщийМодуль.ИдИмпортKeras()+"
	|sys.stdout = open(u'"+СтрЗаменить(Параметры.ФайлСообщений,"\","\\")+"', 'w')
	|file = open(u'"+СтрЗаменить(Параметры.ФайлМодели,"\","\\")+"', 'r')
	|loaded_json = file.read()
	|file.close()
	|model = keras.models.model_from_json(loaded_json)
	|"+Нейро_ОбщийМодуль.ИдFromKeras("from keras.utils import plot_model")+"
	|plot_model(model, show_shapes=True, to_file=u'"+СтрЗаменить(Параметры.ФайлРезультатов,"\","\\")+"')
	|";
	
	//Если ПоказыватьГрафически Тогда
	//	ПутьПитон=СтрЗаменить(Параметры.ПутьККаталогуОбучения,"\","\\");
	//	Объект.ТекстПрограммы=Объект.ТекстПрограммы+
	//	"from keras.utils import plot_model
	//	|user1c_folder = u'"+ПутьПитон+"'
	//	|plot_model(model, show_shapes=True, to_file=user1c_folder+'"+Объект.ИдентификаторМодели+".png')
	//	|";
	//КонецЕсли;
	
	Возврат ТекстПрограммы;
КонецФункции

&НаСервере
Процедура ОбработатьМодельИзСтрокиJSON(Форма, ТекстМоделиJSON) Экспорт
	Структуры = ПостроитьДеревоМоделиНаСервере(ТекстМоделиJSON);
	Если Структуры.Свойство("Ошибка") Тогда
		ВызватьИсключение(Структуры.Сообщение);
	КонецЕсли;
	Форма.СтруктураМоделиПреобразованная = Структуры.СтруктураМодели;
	СформироватьПредставленияПараметров(Форма.СтруктураМоделиПреобразованная);
КонецПроцедуры

&НаСервере
Функция ИмпортироватьМодель(Объект, Форма, Дерево) Экспорт
	//Объект.Слои.Очистить();
	//Объект.Входы.Очистить();
	//Объект.Выходы.Очистить();
	//Объект.Входящие.Очистить();
	//Объект.Формы.Очистить();
	//ДЗ.ПолучитьЭлементы().Очистить();
	//ОбработатьМодельИзСтрокиJSON();
	//ЗаполнитьРеквизитыПодключеннойМодели();
	//СтруктураМодели = ПеребратьОбъектJSON();
	
	Нейро_СозданиеМоделиНаСервере.ОбработатьМодельИзСтрокиJSON(Объект.ТекстМоделиJSON, Дерево);
	
	Структуры = ПостроитьДеревоМоделиНаСервере(Объект.ТекстМоделиJSON);
	Если Структуры.Свойство("Ошибка") Тогда
		ВызватьИсключение(Структуры.Сообщение);
	КонецЕсли;
	
	//ВсегоСлоев = ПосчитатьКоличествоСлоевМодели(Структуры.СтруктураДереваJSON.config.layers);
	//Если ВсегоСлоев>7 Тогда
	//	Возврат ВсегоСлоев;
	//КонецЕсли;
	
	Форма.СтруктураМоделиПреобразованная = Структуры.СтруктураМодели;
	СформироватьПредставленияПараметров(Форма.СтруктураМоделиПреобразованная);
	
	Нейро_СозданиеМоделиНаСервере.ЗаполнитьРеквизитыПодключеннойМодели(Объект, Дерево);
	Форма.СтруктураМодели = Нейро_СозданиеМоделиНаСервере.ПеребратьОбъектJSON(Дерево);
	
	Возврат 0;
КонецФункции

&НаСервере
Функция ПосчитатьКоличествоСлоевМодели(МассивСлоев)
	Результат = 0;
	Для Каждого СтруктураСлоя Из МассивСлоев Цикл
		Если СтруктураСлоя.class_name = "Model" Тогда
			Результат = Результат + ПосчитатьКоличествоСлоевМодели(СтруктураСлоя.config.layers)
		Иначе
			Результат = Результат + 1;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

