/**
 * Copyright (c) 2011-2012 Alexandr Albul
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.extas.parsers {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.extas.utils.StringUtils;

	/**
	 * 
	 * Класс отвечает за загрузку и доступ к секциям и ключям ини-файла
	 * 
	 */
	public class ParserIni extends EventDispatcher {
		
		public static const NULL:String = "null";

		private var iniLoader:URLLoader;
		private var iniFile:Array;
		
		public function ParserIni(url:String = null) {
			iniLoader = new URLLoader();
			iniLoader.addEventListener(Event.COMPLETE, onLoaderComplete);
			iniLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			if (url != null) 
				load(url);
		}


		/**
		 *	Получить значение ключа key, в секции section
		 * 
		 * @param 	section  Секция ини-файла (например bot1)
		 * @param 	key Название ключа в секции (например position)
		 * @param 	size Максимальный размер буфера, который будет возвращен
		 * @return	Возвращает значение ключа
		 * 
		 */	
		public function getValue(section:String, key:String, size:int = 1024):String {
			
			var result:String;
			section = "[" + section + "]";	// Формируем название секции
			for (var i:int = 0; i < iniFile.length; i++) {	// Обходим весь массив в поиске секции
				if (iniFile[i] == section) {	// Секцию найдено
					for (var j:int = i + 1; j < iniFile.length; j++) {	// Обходим массив дальше в поиске ключа
						if (iniFile[j].slice(0, iniFile[j].indexOf("=")) == key) {	// Ключ найден
							result = iniFile[j].slice(iniFile[j].indexOf("=") + 1, iniFile[j].length);	// Возвращаем значение ключа
							return result.substr(0, size);
						}
					}
				}
			}
			return NULL;
		}
		
		
		/**
		 * Получить имя секции в которой находится значение value
		 * @param	value Значение которое ищем
		 * @return
		 */
		public function getSection(value:String):String {
			var currentSection:String;
			var signEqual:int;
			for (var i:int = 0; i < iniFile.length; i++) {	// Обходим весь массив в поиске значения
				if (iniFile[i].charAt(0) == "[") {	// Заходим в новую секцию
					currentSection = iniFile[i];	// Запоминаем текущую секцию
					continue;
				}
				signEqual = iniFile[i].indexOf("=");	// Ищем знак равенства в строке
				if (signEqual != -1) {									
					if (iniFile[i].slice(signEqual + 1, iniFile[i].length) == value) {	
						return currentSection;							
					}
				}
			}
			
			return NULL;	// Если обойдя весь массив не найшли значения тогда возвращаем null
		}	
		
		
		/**
		 * Получить имя ключа которому присвоено значение value
		 * @param	value Значение которое ищем
		 * @return
		 */
		public function	getKey(value:String):String {
			var currentKey:String;
			var signEqual:int;
			for (var i:int = 0; i < iniFile.length; i++) {	// Обходим весь массив в поиске значения
				signEqual = iniFile[i].indexOf("=");					
				if (signEqual != -1) {									
					if (iniFile[i].slice(signEqual + 1, iniFile[i].length) == value) {	
						return iniFile[i].slice(0, signEqual);							
					}
				}
			}
			
			return NULL;	// Если обойдя весь массив не найшли значения тогда возвращаем null
		}
				
		
		/**
		 *	Загрузить ини-файл
		 * 
		 * @param url - путь к ини-файлу
		 */
		public function load(url:String):void {
			var request:URLRequest = new URLRequest(url);
			iniLoader.load(request);
		}

		
		public function parse(data:String):void {
			parseIni(data);
		}
		
		
		/**
		 * @private
		 */
		private function parseIni(data:String):void {
			var strUtils:StringUtils = new StringUtils();
			iniFile = strUtils.stringToMultiString(data);	// Разбиваем многострочный текст на массив строк
			
			var str:String;
			
			for (var i:int = 0; i < iniFile.length ; i++) {
				str = iniFile[i];
				str = strUtils.trim(str, " ");	// Обрезаем в каждой строке пробелы в начале и в конце
				str = str.substr(0, str.length - 1);	// Удаляем последний символ (перевод каретки)
				iniFile[i] = str;
			}
			
			dispatchEvent(new Event(Event.COMPLETE));	// Создаем событие (ини-файл загружен и разобран)
		}
		
		
		/**
		 * Обработчик на завершение загрузки файла
		 */
		private function onLoaderComplete(e:Event):void {
			parseIni(String(e.target.data));
		}

		
		private function onIOError(event:IOErrorEvent):void {
			dispatchEvent(event);
		}
		
				
	}
}
