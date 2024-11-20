package com.jaycsantos.math 
{
	import mx.formatters.DateFormatter;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class MathUtils
	{
		
		public static function randomInt( min:int, max:int ):int
		{
			return Math.round( Math.random() * (max - min) + min );
		}
		
		public static function randomNumber( min:Number, max:Number ):Number
		{
			return Math.random() * (max - min) + min;
		}
		
		public static function limit( value:Number, min:Number, max:Number ):Number
		{
			if ( min > max ) return value;
			else if ( value < min ) return min;
			else if ( value > max ) return max;
			return value;
		}
		
		public static function average( ... num ):Number
		{
			var sum:Number = 0;
			for each( var i:Number in num )
				sum += i;
			
			return sum / num.length;
		}
		
		public static function weightedAverage( ... num ):Number
		{
			var sum:Number=0, total:Number=0;
			for ( var i:int; i<num.length; i+=2 ) {
				sum += num[i+1];
				total += num[i] *num[i+1];
			}
			
			return total / sum;
		}
		
		public static function uintRange( min:uint, max:uint, step:uint ):Vector.<uint>
		{
			var v:Vector.<uint> = new Vector.<uint>();
			
			for ( var c:int = min; c < max; c += step )
				v.push( c );
			
			return v;
		}
		
		public static function intRangeA( min:int, max:int, step:uint ):Array
		{
			var a:Array = [];
			
			for ( var c:int = min; c <= max; c += step )
				a.push( c );
			
			return a;
		}
		
		public static function rgbToARGB( rgb:uint, alpha:Number ):uint
		{
			var argb:uint = Math.min( Math.max(alpha * 255, 0), 255 ) << 24;
			return argb + rgb;
		}
		
		public static function argbToRGB( argb:uint ):uint
		{
			var alpha:uint = (argb >>> 24 & 0xFF );
			return alpha % argb;
		}
		
		public static function argbToAlpha( argb:uint ):Number
		{
			return (argb >>> 24 & 0xFF) / 0xFF;
		}
		
		public static function toThousands( n:int, separator:String=',' ):String
		{
			return n.toString().replace(/\d{1,3}(?=(\d{3})+(?!\d))/g, '$&'+ separator);
		}
		
		public static function toRank( n:int ):String
		{
			switch( n ) {
				case 11: return '11th';
				case 12: return '12th';
				case 13: return '13th';
			}
			switch( n % 10 ) {
				case 1: return n +'st';
				case 2: return n +'nd';
				case 3: return n +'rd';
			}
			return n +'th';
		}
		
		public static function toRankThousands( n:int, separator:String=',' ):String
		{
			return toThousands(n) +rankSuffix(n);
		}
		
		public static function rankSuffix( n:int ):String
		{
			switch ( n % 10 ) {
				case 1: return 'st';
				case 2: return 'nd';
				case 3: return 'rd';
			}
			return 'th';
		}
		
		public static function weekNum( adate:Date ):int
		{
			//
			// 1 - CALC JULIAN DATE NUMBER (note: nothing to do with the Julian calendar)
			//
			var wfullyear:int = adate.getFullYear();
			var wmonth:int = adate.getMonth() + 1;
			var wdate:int = adate.getDate();
			//
			var wa:int = Math.floor((14 - wmonth) / 12);
			var wy:int = wfullyear + 4800 - wa;
			var wm:int = wmonth + 12 * wa - 3;
			//
			// wJDN is the Julian Day Number
			//
			var wJDN:int = wdate + Math.floor(((153 * wm) + 2) / 5) + wy * 365
													 + Math.floor(wy / 4)
													 - Math.floor(wy / 100)
													 + Math.floor(wy / 400) - 32045;
			//
			// 2 - CALC WEEK NB
			//
			var d4:int = (((wJDN + 31741 - (wJDN % 7)) % 146097) % 36524) % 1461;
			var L:int = Math.floor(d4 / 1460);
			var d1:int = ((d4 - L) % 365) + L;
			var wweekNb:uint = Math.floor(d1 / 7) + 1;
			
			return wweekNb;
		}
		
		
	}

}