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
package org.extas.utils {
	import flash.utils.ByteArray;

	/**
	* 
	* Additional string functions
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
			if (str.charAt(str.length - 1) == char) {
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

		public function stringToMultiString(str:String):Array {
			return str.split("\n", 0x7fffffff); 
		}

	}
}