package com.jaycsantos.display 
{
	import com.jaycsantos.IDisposable;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class Cache4Bmp
	{
		public var bitmapData:BitmapData, point:Point, rect:Rectangle, matrix:Matrix, colorTrnsfrm:ColorTransform
		
		public function Cache4Bmp( usePt:Boolean=false, useRect:Boolean=false, useMatrix:Boolean=false, useClrTrnsfrm:Boolean=false ) 
		{
			if ( usePt ) point = new Point;
			if ( useRect ) rect = new Rectangle;
			if ( useMatrix ) matrix = new Matrix;
			if ( useClrTrnsfrm ) colorTrnsfrm = new ColorTransform;
		}
		
	}

}