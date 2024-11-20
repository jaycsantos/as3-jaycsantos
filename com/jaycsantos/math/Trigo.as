package com.jaycsantos.math 
{
	import flash.geom.Point;
	/**
	 * Useful trigonometry methods
	 * @author jaycsantos
	 */
	public class Trigo
	{
		// @usage multiply value to constant to get the result
		// 	ex: radianAngle = 45 * DEG_TO_RAD;
		public static const RAD_TO_DEG:Number = (180 / Math.PI); //57.29577951;
		public static const DEG_TO_RAD:Number = (Math.PI / 180); //0.017453293;
		public static const PI2:Number = Math.PI * 2; // 360 degrees
		public static const HALF_PI:Number = Math.PI / 2; // 90 degrees
		public static const QUART_PI:Number = Math.PI / 4; // 45 degreess
		
		public static const SQRT_2:Number = Math.sqrt(2);
		public static const SQRT_3:Number = Math.sqrt(3);
		
		public static const VEC2_45_DEG:Point = new Point( Math.cos(QUART_PI), Math.sin(QUART_PI) )
		public static const VEC2_30_DEG:Point = new Point( Math.cos(30*DEG_TO_RAD), Math.sin(30*DEG_TO_RAD) )
		public static const VEC2_60_DEG:Point = new Point( Math.cos(60*DEG_TO_RAD), Math.sin(60*DEG_TO_RAD) )
		
		
 		// @returns the angle between two points
 		public static function calcAngle( p1:Vector2D, p2:Vector2D ):Number
 		{
			return getAngle( p2.x - p1.x, p2.y - p1.y );
			
 			/*
 			var angle:Number = Math.atan( (p2.y - p1.y) / (p2.x - p1.x) ) * RAD_TO_DEG;
			
 			//if it is in the first quadrant
 			if( p2.y < p1.y && p2.x > p1.x )
 			{
 				return angle;
 			}
 			//if its in the 2nd or 3rd quadrant
 			if( ( p2.y < p1.y && p2.x < p1.x ) || ( p2.y > p1.y && p2.x < p1.x ) )
 		   	{
 		   		return angle + 180;
 		   	}
 			//it must be in the 4th quadrant so:
 			return angle + 360;*/
			
 		}
		
		public static function getAngle( x:Number, y:Number ):Number
		{
			return Math.atan2(y, x) *RAD_TO_DEG;
			/*var a:Number = Math.atan( y / x ) * RAD_TO_DEG;
			
			if ( x < 0 )
				a += 180;
			if ( x >= 0 && y < 0 )
				a += 360;
			if ( a > 180 )
				a -= 360;
			
			return a;*/
		}
		
		public static function getRadian( x:Number, y:Number ):Number
		{
			return Math.atan2(y, x);
			/*var r:Number = Math.atan( y / x );
			if ( isNaN(r) )
				r = 0;
			if ( x < 0 )
				r += Math.PI;
			if ( x >= 0 && y < 0 )
				r += Math.PI * 2;
			return r;*/
		}
		
		
		//origin means original starting radian, dest destination radian around a circle
		/**
		 * Determines which direction a point should rotate to match rotation the quickest 
		 * @param objectRotationRadians The object you would like to rotate
		 * @param radianBetween the angle from the object to the point you want to rotate to
		 * @return -1 if left, 0 if facing, 1 if right
		 * 
		 */ 		
		public static function getSmallestRotationDirection( objectRotationRadians:Number, radianBetween:Number, errorRadians:Number = 0 ):int
		{
			objectRotationRadians = simplifyRadian( objectRotationRadians );
			radianBetween = simplifyRadian( radianBetween );
			
			radianBetween += -objectRotationRadians;
			radianBetween = simplifyRadian( radianBetween );
			objectRotationRadians = 0;
			if( radianBetween < -errorRadians )
			{
				return -1;
			}
			else if( radianBetween > errorRadians )
			{
				return 1;
			}
			return 0;
		}
		
		
		public static function simplifyRadian( radian:Number ):Number
		{
			if( radian > Math.PI || radian < -Math.PI )
			{
				var newRadian:Number;
				newRadian = radian - int( radian / ( Math.PI *2 ) ) * ( Math.PI * 2 );
				if( radian > 0)
				{
					if( newRadian < Math.PI )
					{
						return newRadian;
					}
					else
					{
						newRadian =- ( Math.PI * 2 - newRadian );
						return newRadian;
					}
				}
				else
				{
					if( newRadian > -Math.PI )
					{
						return newRadian;
					}
					else
					{
						newRadian = ( ( Math.PI * 2 ) + newRadian );
						return newRadian;
					}
				}
			}
			return radian;
		}
		
	}

}