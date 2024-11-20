package com.jaycsantos.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MovieClipAnimator extends AbstractAnimator 
	{
		
		public function MovieClipAnimator( mc:MovieClip, sequence:Vector.<uint>, frameSpeed:uint = 0, loop:Boolean = true ) 
		{
			if ( sequence == null ) {
				sequence = new Vector.<uint>( mc.totalFrames, true );
				var i:int = sequence.length;
				while ( i-- )
					sequence[i] = i + 1;
			}
			
			buffer = mc;
			
			super( sequence, frameSpeed, loop );
		}
		
		
			// -- private --
			
			override protected function _updateAnimation():void 
			{
				MovieClip( buffer ).gotoAndStop( _sequence[_currentFrame] );
			}
			
	}

}