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
	
	/**
	 * Класс содержит дополнительные математические функции 
	 * 
	 */
	
	public class MathUtils {
		
		/**
		 * Возвращает округленное число параметра val до значения to
		 * @param val Число или выражение.
		 * @param to Число или выражение.
		 * @return 
		 * 
		 */
		static public function roundTo(value:Number, to:Number):Number {
			//return (Math.floor(value / to) * to);
			return value - value % to;	
		}
		
		/**
		 * Преобразовывает градусы в радианы
		 * @param val Число или выражение.
		 * @return 
		 * 
		 */
		static public function toRadians(val:Number):Number {
			return val * Math.PI / 180;
		}
		
		/**
		 * Преобразовывает радианы в градусы
		 * @param val Число или выражение.
		 * @return 
		 * 
		 */
		static public function toDegrees(val:Number):Number {
			return val * 180 / Math.PI;
		}
		
		/**
		 * Определяет знак параметра val.
		 * @param val Число или выражение.
		 * @return Положительное число если val больше нуля, отрицательное если val меньше нуля, иначе 0.
		 * 
		 */
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
					
		/**
		 * Возвращает натуральный логарифм параметра val. 
		 * @param val Число или выражение со значением большим за 0.
		 * @return Натуральный логарифм параметра val.
		 * 
		 */
		static public function ln(val:Number):Number {
			return Math.log(val);
		}
		
		/**
		 * Возвращает логарифм числа b за основою а.
		 * @param a Число или выражение со значением не равным 1.
		 * @param b Число или выражение со значением большим за 0.
		 * @return логарифм числа b за основою а.
		 * 
		 */
		static public function log(a:Number, b:Number):Number {
			if (a > 0 && b > 0 && a != 1) {
				return Math.log(b) / Math.log(a);
			} else {
				throw new ArgumentError("Inaccessible arguments"); 
			}
		}
			
		/**
		 * Возвращает десятичный логарифм параметра val. 
		 * @param val Число или выражение со значением большим за 0.
		 * @return Десятичный логарифм параметра val.
		 * 
		 */
		static public function lg(val:Number):Number {
			if (val > 0) {
				return Math.log(val) / Math.log(10);
			} else {
				throw new ArgumentError("Inaccessible arguments"); 
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Тригонометрические функции
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Вычисляет и возвращает тангенс заданного угла.
		 * @param angleRadians Число, представляющее угол, измеренный в радианах. 
		 * @return Тангенс параметра angleRadians.
		 * 
		 */
		static public function tg(angleRadians:Number):Number {
			return Math.tan(angleRadians);
		}
		
		/**
		 * Вычисляет и возвращает котангенс заданного угла.
		 * @param angleRadians Число, представляющее угол, измеренный в радианах.
		 * @return Котангенс параметра angleRadians.
		 * 
		 */
		static public function ctg(angleRadians:Number):Number {
			return 1 / Math.tan(angleRadians);
		}
				
	}
	
}