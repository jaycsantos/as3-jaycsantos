package com.jaycsantos.sound 
{
	import com.jaycsantos.math.MathUtils;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class PlayRequestPriority
	{
		
		public static function requestPlay( name:String, startTime:Number=0, loops:int=0, volume:Number=1, pan:Number=0 ):void
		{
			var snd:GameSoundObj = GameSounds.instance.getSoundObj( name );
			if ( ! snd ) return;
			
			var request:PlayRequest
			
			// is already on queue
			if ( _queue[snd] ) {
				request = _queue[snd];
				if ( request.lastRequest == PlayRequest.PLAY ) {
					request.volume = Math.max( request.volume, volume );
					if ( request.pan != pan )
						request.pan = MathUtils.weightedAverage( request.pan, request.ctr, pan, 1 );
				} else {
					request.volume = volume;
					request.pan = pan;
				}
				request.lastRequest = PlayRequest.PLAY;
				request.ctr++;
				
			} else {
				request = _queue[snd] = new PlayRequest( startTime, loops, volume, pan );
			}
			
		}
		
		public static function requestStop( name:String ):void
		{
			var snd:GameSoundObj = GameSounds.instance.getSoundObj( name );
			if ( !snd || !_queue[snd] || !snd.isPlaying() ) return;
			
			var request:PlayRequest = _queue[snd];
			if ( request.lastRequest == PlayRequest.NONE )
				request.lastRequest = PlayRequest.STOP;
			
		}
		
		
		public static function update():void
		{
			var request:PlayRequest, snd:GameSoundObj
			for ( var key:Object in _queue ) {
				snd = GameSoundObj(key);
				request = _queue[snd];
				
				switch( request.lastRequest ) {
					case PlayRequest.PLAY:
						if ( !snd.isPlaying() )
							GameSounds.play( snd.name, request.startTime, request.loops, request.volume );
						snd.setPanVol( request.pan, request.volume );
						request.lastRequest = PlayRequest.NONE;
						request.ctr = 0;
						break;
						
					case PlayRequest.STOP:
						GameSounds.stop( snd.name );
						delete _queue[snd];
						break;
						
					case PlayRequest.NONE:
					default: continue; break;
				}
			}
			
		}
		
		public static function clear():void
		{
			for ( var key:Object in _queue )
				delete _queue[key];
		}
		
		
			// -- private --
			
			private static var _queue:Dictionary = new Dictionary( true );
			
	}

}

