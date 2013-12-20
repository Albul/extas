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
package org.extas.a3d.objects {
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import flash.display.Stage3D;
	import flash.geom.Vector3D;
	
	/**
	 *  A 1st and 3d person camera(depending on positionOffset!), hooked on a physical spring on an optional target.
	 */
	public class SpringCam extends Camera3D {
			
		/**
		 * [optional] Target object3d that camera should follow. If target is null, camera behaves just like a normal Camera3D.
		 */
		public var target:Object3D;
		
		//spring stiffness
		/**
		 * Stiffness of the spring, how hard is it to extend. The higher it is, the more "fixed" the cam will be.
		 * A number between 1 and 20 is recommended.
		 */
		public var stiffness:Number = 1;
		
		/**
		 * Damping is the spring internal friction, or how much it resists the "boinggggg" effect. Too high and you'll lose it!
		 * A number between 1 and 20 is recommended.
		 */
		public var damping:Number = 4;
		
		/**
		 * Mass of the camera, if over 120 and it'll be very heavy to move.
		 */
		public var mass:Number = 40;
		
		/**
		 * Offset of spring center from target in target object space, ie: Where the camera should ideally be in the target object space.
		 */
		public var positionOffset:Vector3D = new Vector3D(-50, 0, 5);
		
		
		/**
		 * offset of facing in target object space, ie: where in the target object space should the camera look.
		 */
		public var lookOffset:Vector3D = new Vector3D(0, 2, 10);
	
		// private physics members
		private var _velocity:Vector3D = new Vector3D();
		private var _dv:Vector3D = new Vector3D();
		private var _stretch:Vector3D = new Vector3D();
		private var _force:Vector3D = new Vector3D();
		private var _acceleration:Vector3D = new Vector3D();
		
		// private target members
		private var _desiredPosition:Vector3D = new Vector3D();
		private var _lookAtPosition:Vector3D = new Vector3D();
		
		// private transformed members
		private var _xPositionOffset:Vector3D = new Vector3D();
		private var _xLookOffset:Vector3D = new Vector3D();
		private var _xPosition:Vector3D = new Vector3D();
	
		
		/**
		 * Creates a <code>SpringCam</code> object.
		 *
		 * @param nearClipping  Near clipping distance.
		 * @param farClipping  Far clipping distance.
		 * @param target  Target object3d that camera should follow.
		 */
		public function SpringCam(nearClipping:Number, farClipping:Number, target:Object3D = null) {
			super(nearClipping, farClipping);
			this.target = target;
			this.position = target.position.add(positionOffset);
		}
		
		override public function render(stage3D:Stage3D):void {
			
			if(target != null) {
				_xPositionOffset = target.matrix.deltaTransformVector(positionOffset);
				_xLookOffset = target.matrix.deltaTransformVector(lookOffset);
				
				_desiredPosition = target.position.add(_xPositionOffset);
				_lookAtPosition = target.position.add(_xLookOffset);
				
				_stretch = this.position.subtract(_desiredPosition);
				_stretch.scaleBy(-stiffness);
				_dv = _velocity.clone();
				_dv.scaleBy(damping);
				_force = _stretch.subtract(_dv);
				
				_acceleration = _force.clone();
				_acceleration.scaleBy(1/mass);
				_velocity = _velocity.add(_acceleration);
				
				this.lookAt(_lookAtPosition);
				
				_xPosition = position.add(_velocity);
				this.position = _xPosition;
			}
			
			super.render(stage3D);
		}
		
		/**
		 * Set direction of camera3d to the given coordinates..
		 */
		public function lookAt(target : Vector3D) : void {
			var dx:Number = target.x - this.x;
			var dy:Number = target.y - this.y;
			var dz:Number = target.z - this.z;
			rotationX = Math.atan2(dz, Math.sqrt(dx * dx + dy * dy)) - Math.PI / 2;
			rotationY = 0;
			rotationZ = -Math.atan2(dx, dy);
		}

	}
}