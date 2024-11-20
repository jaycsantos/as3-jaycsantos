package com.jaycsantos.math
{
	import com.jaycsantos.IDisposable;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class AABB
	{
		public static function fromRect( rect:Rectangle ):AABB
		{
			return new AABB( new Vector2D(rect.left+rect.width/2, rect.top+rect.height/2), rect.width, rect.height );
		}
		
		
		public var min:Vector2D, max:Vector2D
		public var width:Number, height:Number;
		public var halfWidth:Number, halfHeight:Number;
		
		
		public function AABB( center:Vector2D, w:Number, h:Number )
		{
			min = new Vector2D;
			max = new Vector2D;
			
			Set( center, w, h );
		}
		
		public function toString():String
		{
			return "AABB( "+ min +","+ max +" )";
		}
		
		
		/**
		 * Use to change any values in the AABB so that everything is updated correctly. 
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 */
		public function Set( center:Vector2D, w:Number, h:Number ):void
		{
			width = w;
			height = h;
			halfWidth = w / 2;
			halfHeight = h / 2;
			
			min.x = center.x - halfWidth;
			min.y = center.y - halfHeight;
			max.x = center.x + halfWidth;
			max.y = center.y + halfHeight;
		}
		
		public function resize( w:Number, h:Number ):void
		{
			width = w;
			height = h;
			halfWidth = w / 2;
			halfHeight = h / 2;
			
			var cx:Number = (max.x - min.x) -w,
			cy:Number = (max.y - min.y) -h;
			
			min.x += cx;
			min.y += cy;
			max.x -= cx;
			max.y -= cy;
		}
		
		public function concat( aabb:AABB ):void
		{
			min.x = Math.min( min.x, aabb.min.x );
			min.y = Math.min( min.y, aabb.min.y );
			max.x = Math.max( max.x, aabb.max.x );
			max.y = Math.max( max.y, aabb.max.y );
			
			width = max.x -min.x; halfWidth = width /2;
			height = max.y -min.y; halfHeight = height /2;
		}
		
		/**
		 * Centers the box at the specified point. 
		 * @param point Center point at which to move the box.
		 */
		public function moveTo( x:Number, y:Number ):void
		{
			min.x = x - halfWidth;
			min.y = y - halfHeight;
			max.x = x + halfWidth;
			max.y = y + halfHeight;
		}
		
		public function clone():AABB
		{
			return new AABB( new Vector2D(max.x-min.x, max.y-min.y), width, height );
		}
		
		
		public function isV2Inside( v:Vector2D ):Boolean
		{
			return v.isInsideRegion( min, max );
		}
		
		public function isColliding( box:AABB ):Boolean
		{
			return min.x < box.max.x && box.min.x < max.x && min.y < box.max.y && box.min.y < max.y;
			//return (left <= box.right || right >= box.left) && (top <= box.bottom || bottom >= box.top);
		}
		
		public function isContaining( x:Number, y:Number ):Boolean
		{
			return min.x<x && max.x>x && min.y<y && max.y>y;
		}
		
		public function isContainingPt( p:Point ):Boolean
		{
			return isContaining( p.x, p.y );
		}
		
		
	}
}