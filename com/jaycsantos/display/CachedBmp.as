package com.jaycsantos.display 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author ...
	 */
	public class CachedBmp 
	{
		public var data:BitmapData
		public var offX:int
		public var offY:int
		//public var id:uint;
		
		public function CachedBmp( Data:BitmapData, OffX:int, OffY:int )
		{
			data = Data;
			offX = OffX;
			offY = OffY;
			//id = _id++;
		}
		
			// -- private --
			
			//private static var _id:uint
	}

}