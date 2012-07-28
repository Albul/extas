/*
 * 
 * Copyright (c) 2012, Albul Alexandr
 
	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
package org.extas.utils {
	import flash.utils.ByteArray;
	
	
	/**
	* 
	* Класс содержит расширенные функции для работы со строками
	* 
	*/
	public class StringUtils {
				
		
		/**
		 * Конвертация строки из cp-1251 в UTF-8
		 * 
		 * @param	data Входящая строка в кодировке cp-1251
		 * @return
		 */
		static public function toUTF(data:String):String {
			var str:String = '', tl:int = data.length;
			
			for (var i:int = 0; i < tl; i++) {
				str += data.charCodeAt(i) < 128? data.charAt(i) : String.fromCharCode(data.charCodeAt(i) + 848);
			}
			return str;
		}
		
		
		/**
		 * Конвертация строки из UTF-8 в cp-1251
		 * 
		 * @param	data Входящая строка в кодировке UTF-8
		 * @return
		 */
		static public function toANSII(data:String):String {
			var result:ByteArray = new ByteArray();
			result.writeMultiByte(data,"windows-1251");
			return result.toString();
		}

		
		public function replace(str:String, oldSubStr:String, newSubStr:String):String {
			return str.split(oldSubStr).join(newSubStr);
		}
		

		/**
		 * Ф-я обрезает спереди и сзади строки все символы char идущих в подстроке
		 * @param	str
		 * @param	char
		 * @return
		 */
		public function trim(str:String, char:String):String {
			return trimFront(trimBack(str, char), char);
		}

		
		public function trimFront(str:String, char:String):String {
			char = stringToCharacter(char);
			if (str.charAt(0) == char) {
				str = trimFront(str.substring(1), char);
			}
			return str;
		}

		
		public function trimBack(str:String, char:String):String {
			char = stringToCharacter(char);
			if (str.charAt(str.length - 1) == char) {							// 2 потому как последний символ это перевод каретки
				str = trimBack(str.substring(0, str.length - 1), char);
			}
			return str;
		}

		
		public function stringToCharacter(str:String):String {
			if (str.length == 1) {
				return str;
			}
			return str.slice(0, 1);
		}
		
		
		/**
		 * Функция разбивает текст (который содержится в переменной String) в массив строк.
		 * @param	str
		 * @return
		 */
		public function stringToMultiString(str:String):Array {
			return str.split("\n", 0x7fffffff); 
		}
		
		
	}

}