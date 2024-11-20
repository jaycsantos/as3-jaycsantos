package com.jaycsantos.sound 
{
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class FadeSoundEffect
	{
		
		public static function fadeIn( name:String, func:Function, length:uint, startTime:Number=0, loops:int=0, onEnd:Function=null, onStop:Function=null ):void
		{
			if ( GameSounds.play(name, startTime, loops, 0, onEnd, onStop) ) {
				var t:uint = getTimer();
				while ( _map[t] ) t++;
				_map[t] = [ name, 0, 1, length, func ];
			}
			
		}
		
		public static function fadeOutAtEnd( name:String, func:Function, length:uint, onFaded:Function=null ):void
		{
			var snd:GameSoundObj = GameSounds.instance.getSoundObj(name);
			if ( snd && snd.isPlaying() ) {
				var t:uint = snd.getStartTime() +snd.getLength() -length;
				while ( _map[t] ) t++;
				_map[t] = [ name, 1, -1, length, func, onFaded ];
			}
		}
		
		public static function fadeOut( name:String, func:Function, length:uint, onFaded:Function=null ):void
		{
			var snd:GameSoundObj = GameSounds.instance.getSoundObj(name);
			if ( snd && snd.isPlaying() ) {
				var t:uint = getTimer();
				while ( _map[t] ) t++;
				_map[t] = [ name, 1, -1, length, func, onFaded ];
			}
			
		}
		
		
		public static function update():void
		{
			var v:Number, t:uint = getTimer();
			var a:Array, snd:GameSoundObj;
			
			for ( var k:String in _map ) {
				var n:uint = uint(k);
				a = _map[k];
				snd = GameSounds.instance.getSoundObj( a[0] );
				
				if ( snd.isPlaying() ) {
					if ( n >= t ) continue;
					
					if ( n + a[3] >= t ) {
						snd.setPanVol( 0, v = a[4].call(null, t-n, a[1], a[2], a[3]) );
						
					} else {
						if ( a[2] != 1 ) {
							snd.setPanVol( 0, 0 );
							snd.stop();
							if ( a[5] != null ) a[5].call(null, snd);
						} else {
							snd.setPanVol( 0, 1 );
						}
						delete _map[k];
					}
					
				} else {
					delete _map[k];
				}
				
			}
			
			
		}
		
		
			// -- private --
			
			private static var _map:Object = { };
		
	}

}