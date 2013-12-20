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
	
	/**
	 * Additional math functions
	 * 
	 */
	public class MathUtils {

		static public function roundTo(value:Number, to:Number):Number {
			//return (Math.floor(value / to) * to);
			return value - value % to;	
		}

		static public function toRadians(val:Number):Number {
			return val * Math.PI / 180;
		}

		static public function toDegrees(val:Number):Number {
			return val * 180 / Math.PI;
		}

		static public function signum(val:Number):Number {
//			if (val == 0) {
//				return 0;
//			} else if (val < 0) {
//				return -1;
//			} else {
//				return 1;
//			}
			return (val == 0? 0 : (val < 0? -1 : 1));
		}

		static public function ln(val:Number):Number {
			return Math.log(val);
		}

		static public function log(a:Number, b:Number):Number {
			if (a > 0 && b > 0 && a != 1) {
				return Math.log(b) / Math.log(a);
			} else {
				throw new ArgumentError("Inaccessible arguments"); 
			}
		}

		static public function lg(val:Number):Number {
			if (val > 0) {
				return Math.log(val) / Math.log(10);
			} else {
				throw new ArgumentError("Inaccessible arguments"); 
			}
		}

		static public function tg(angleRadians:Number):Number {
			return Math.tan(angleRadians);
		}

		static public function ctg(angleRadians:Number):Number {
			return 1 / Math.tan(angleRadians);
		}
				
	}
}