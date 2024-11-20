package com.jaycsantos.entity 
{
	import com.jaycsantos.entity.EntityArgs;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class MovableEntityArgs extends EntityArgs
	{
		
		public var rotation:Number = 0; // the default rotation
		public var friction:Number = 1; // slow down when hitting things
		public var damping:Number = 1; // reduces movement on space
		
		public var maxSpeed:Number = 100; // max speed
		public var maxAccel:Number = 100; // max accel
		public var maxTurnSpeed:Number = 0; // turn rate per second, set to 0 for infinite;
		
		public var matchHeadingRotation:Boolean = false; // lock rotation to direction heading
		
		public var isCollidable:Boolean = false;
		
		
		public function MovableEntityArgs( args:Object = null ) 
		{
			_argue( args );
		}
		
	}

}