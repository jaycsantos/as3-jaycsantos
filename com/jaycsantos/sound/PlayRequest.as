package com.jaycsantos.sound 
{
	/**
	 * ...
	 * @author jaycsantos
	 */
	internal class PlayRequest 
	{
		public static const NONE:int = 0
		public static const STOP:int = 1
		public static const PLAY:int = 2
		
		public var startTime:Number, loops:int, volume:Number, pan:Number
		public var lastRequest:int, ctr:int
		
		public function PlayRequest( startTime:Number=0, loops:int=0, volume:Number=1, pan:Number=0 )
		{
			this.startTime = startTime;
			this.loops = loops;
			this.volume = volume;
			this.pan = pan;
			
			lastRequest = PLAY;
			ctr = 1;
		}
		
	}

}