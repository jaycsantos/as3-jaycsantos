package com.jaycsantos.util 
{
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class ColorMatrixUtil 
	{
		
		
		/**
		 * sets brightness value available are -100 ~ 100 @default is 0
		 * @param 		value:int	brightness value
		 * @return		ColorMatrixFilter
		 */
		public static function setBrightness( value:Number ):ColorMatrixFilter
		{
			value = value*( 255/250 );
			
			var m:Array = new Array();
			m = m.concat( [1, 0, 0, 0, value] );	// red
			m = m.concat( [0, 1, 0, 0, value] );	// green
			m = m.concat( [0, 0, 1, 0, value] );	// blue
			m = m.concat( [0, 0, 0, 1, 0] );		// alpha
			
			return new ColorMatrixFilter(m);
		}
		
		/**
		 * sets contrast value available are -100 ~ 100 @default is 0
		 * @param 		value:int	contrast value
		 * @return		ColorMatrixFilter
		 */
		public static function setContrast( value:Number ):ColorMatrixFilter
		{
			value /= 100;
			var s: Number = value +1;
    	var o : Number = 128 *(1 -s);
			
			var m:Array = new Array();
			m = m.concat( [s, 0, 0, 0, o] );	// red
			m = m.concat( [0, s, 0, 0, o] );	// green
			m = m.concat( [0, 0, s, 0, o] );	// blue
			m = m.concat( [0, 0, 0, 1, 0] );	// alpha
			
			return new ColorMatrixFilter(m);
		}
		
		/**
		 * sets saturation value available are -100 ~ 100 @default is 0
		 * @param 		value:int	saturation value
		 * @return		ColorMatrixFilter
		 */
		public static function setSaturation( value:Number ):ColorMatrixFilter
		{
			
			var v:Number = (value/100) + 1;
			var i:Number = 1 -v;
			var r:Number = i *LUM_R;
			var g:Number = i *LUM_G;
			var b:Number = i *LUM_B;
			
			var m:Array = new Array();
			m = m.concat( [(r + v), g, b, 0, 0] );	// red
			m = m.concat( [r, (g + v), b, 0, 0] );	// green
			m = m.concat( [r, g, (b + v), 0, 0] );	// blue
			m = m.concat( [0, 0, 0, 1, 0] );			// alpha
			
 			return new ColorMatrixFilter(m);
		}
		
			// -- private --
			
			private static const LUM_R:Number = 0.212671;
			private static const LUM_G:Number = 0.71516;
			private static const LUM_B:Number = 0.072169;
		
	}

}