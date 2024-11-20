package com.jaycsantos.util 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class DisplayKit 
	{
		
		public static function removeAllChildren( d:DisplayObjectContainer, lvl:int=0 ):void
		{
			var d2:DisplayObject, i:int = d.numChildren;
			while ( i-- ) {
				d2 = d.removeChildAt( i );
				if ( lvl>0 && d2 is DisplayObjectContainer )
					removeAllChildren( d2 as DisplayObjectContainer, lvl -1 );
			}
		}
		
		
	}

}