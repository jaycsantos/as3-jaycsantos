package com.jaycsantos.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ...
	 */
	public class BitmapAnimator extends AbstractAnimator 
	{
		public function get bmpFrames():Vector.<BitmapData>
		{
			return _bmpFrames.concat();
		}
		
		
		public function BitmapAnimator( bmpFrames:Vector.<BitmapData>, sequence:Vector.<uint> = null, frameSpeed:uint = 0, loop:Boolean = true )
		{
			if ( sequence == null ) {
				sequence = new Vector.<uint>( bmpFrames.length, true );
				var i:int = bmpFrames.length;
				while ( i-- )
					sequence[i] = i;
			}
			
			buffer = new Bitmap;
			
			super( sequence, frameSpeed, loop );
			
			_bmpFrames = bmpFrames.concat();
		}
		
		
		override public function dispose():void 
		{
			Bitmap(buffer).bitmapData = null;
			
			super.dispose();
			
			_bmpFrames.splice( 0, _bmpFrames.length );
		}
		
		public function disposeWithBitmapData():void
		{
			for each( var bmp:BitmapData in _bmpFrames )
				bmp.dispose();
			
			dispose();
		}
		
		
			// -- private --
			
			protected var _bmpFrames:Vector.<BitmapData>;
			
			override protected function _updateAnimation():void 
			{
				Bitmap( buffer ).bitmapData = _bmpFrames[ _sequence[_currentFrame] ];
			}
		
		
		
		
		
		
		// static
		
		public static var rasterFramesPerTick:uint = 12;
		
		public static function rasterize( mc:MovieClip, onComplete:Function ):Boolean
		{
			if ( _timer )
				return false;
			
			_mc = mc;
			_callback = onComplete;
			_bmps = new Vector.<BitmapData>( mc.totalFrames, true );
			_mcFrame = 1;
			
			_timer = new Timer( 20, Math.ceil(mc.totalFrames / rasterFramesPerTick) );
			_timer.addEventListener( TimerEvent.TIMER, _rasterLoop, false, 0, true );
			_timer.start();
			
			return true;
		}
			
			// -- static private --
			
			private static var _mc:MovieClip;
			private static var _mcFrame:int;
			private static var _bmps:Vector.<BitmapData>;
			private static var _callback:Function;
			private static var _timer:Timer;
			
			private static function _rasterLoop( e:TimerEvent ):void
			{
				var l:int = rasterFramesPerTick;
				var rect:Rectangle, bmp:BitmapData, matrix:Matrix;
				
				while ( l-- ) {
					_mc.gotoAndStop( _mcFrame );
					
					rect = _mc.getBounds( _mc );
					
					if ( rect.width <= 0 || rect.height <= 0 ) {
						bmp = new BitmapData( rect.width, rect.height, true, 0 );
						matrix = new Matrix;
						matrix.translate( -rect.x, -rect.y );
						
						bmp.draw( _mc, matrix, null, null, null, true );
						
						_bmps[ _mcFrame -1 ] = bmp;
						
					} else {
						_bmps[ _mcFrame -1 ] = null;
					}
						
					
					_mcFrame++;
					// we are done, clean up!
					if ( _mcFrame > _mc.totalFrames ) {
						
						_timer.stop();
						_timer.removeEventListener( TimerEvent.TIMER, _rasterLoop );
						_timer = null;
						
						_mc = null;
						
						_callback( _bmps.concat() );
						_callback = null;
						
						_bmps.splice( 0, _bmps.length );
						
						break;
					}
				}
				
			}
		
		
		
	}

}