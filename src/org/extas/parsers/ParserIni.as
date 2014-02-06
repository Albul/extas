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
	 * Class is responsible for loading and access to the sections and keys ini-files
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
		 * Get the key value in the section
		 * @param section Ini-file section
		 * @param key The key name in the section
		 * @param size Maximal size of the buffer that will be returned
		 * @return
		 */
		public function getValue(section:String, key:String, size:int = 1024):String {
			var result:String;
			section = "[" + section + "]";
			for (var i:int = 0; i < iniFile.length; i++) {
				if (iniFile[i] == section) {
					for (var j:int = i + 1; j < iniFile.length; j++) {
						if (iniFile[j].slice(0, iniFile[j].indexOf("=")) == key) {
							result = iniFile[j].slice(iniFile[j].indexOf("=") + 1, iniFile[j].length);
							return result.substr(0, size);
						}
					}
				}
			}
			return NULL;
		}

		/**
		 * Get the section name for a given value
		 * @param value
		 * @return
		 */
		public function getSection(value:String):String {
			var currentSection:String;
			var signEqual:int;
			for (var i:int = 0; i < iniFile.length; i++) {
				if (iniFile[i].charAt(0) == "[") {
					currentSection = iniFile[i];
					continue;
				}
				signEqual = iniFile[i].indexOf("=");
				if (signEqual != -1) {
					if (iniFile[i].slice(signEqual + 1, iniFile[i].length) == value) {
						return currentSection;
					}
				}
			}
			return NULL;
		}

		/**
		 * Get the key name for a given value
		 * @param value
		 * @return
		 */
		public function	getKey(value:String):String {
			var currentKey:String;
			var signEqual:int;
			for (var i:int = 0; i < iniFile.length; i++) {
				signEqual = iniFile[i].indexOf("=");
				if (signEqual != -1) {
					if (iniFile[i].slice(signEqual + 1, iniFile[i].length) == value) {
						return iniFile[i].slice(0, signEqual);
					}
				}
			}
			return NULL;
		}

		/**
		 * Upload ini-file
		 * @param url
		 */
		public function load(url:String):void {
			var request:URLRequest = new URLRequest(url);
			iniLoader.load(request);
		}

		public function parse(data:String):void {
			parseIni(data);
		}


		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------


		private function parseIni(data:String):void {
			var
					strUtils:StringUtils = new StringUtils(),
					str:String;
			iniFile = strUtils.stringToMultiString(data);
			for (var i:int = 0; i < iniFile.length ; i++) {
				str = iniFile[i];
				str = strUtils.trim(str, " ");
				str = str.substr(0, str.length - 1);
				iniFile[i] = str;
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function onLoaderComplete(e:Event):void {
			parseIni(String(e.target.data));
		}

		private function onIOError(event:IOErrorEvent):void {
			dispatchEvent(event);
		}
	}
}
