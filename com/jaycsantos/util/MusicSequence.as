package com.jaycsantos.util 
{
	import com.greensock.easing.Quad;
	import com.jaycsantos.math.MathUtils;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class MusicSequence 
	{
		
		public function MusicSequence( fps:uint, fadeIn:uint=0, fadeOut:uint=0 ) 
		{
			_soundObjMap = new Vector.<String>;
			_soundObjMapLoop = new Vector.<uint>;
			
			var delay:uint = Math.max((1000 / fps),20) >> 0;
			if ( fadeIn ) {
				_fadeIn = new Timer( delay, Math.ceil(fadeIn/delay) );
				_fadeIn.addEventListener( TimerEvent.TIMER, _fadingIn, false, 0, true );
			}
			if ( fadeOut ) {
				_fadeOut = new Timer( delay, Math.ceil(fadeOut/delay) );
			}
		}
		
		public function add( sndObjName:String, loop:uint=0 ):void
		{
			var sndObj:GameSoundObj = GameSounds.instance.getSoundObj( sndObjName );
			if ( ! sndObj ) return;
			
			_soundObjMap.push( sndObjName );
			_soundObjMapLoop.push( loop );
			
			_length += sndObj.sound.length *Math.max(loop,1);
			//_length += sndObj.sound.length *(loop+1);
		}
		
		public function get length():uint
		{
			return _length;
		}
		
		
		public function play( onComplete:Function=null ):void
		{
			_onComplete = onComplete;
			_index = 0;
			_timeStart = getTimer();
			
			trace( '3:  ...playing sequence ['+ _index +'/'+ _soundObjMap.length +']... end at '+ (length +_timeStart) +'ms ' );
			
			GameSounds.play( _soundObjMap[_index], 0, _soundObjMapLoop[_index], _fadeIn? 0: GameSounds.volumeMusic, _playNext );
			
			if ( _fadeIn ) {
				_fadeIn.start();
			}
			if ( _fadeOut && _length -1000 > _fadeOut.repeatCount*_fadeIn.delay ) {
				_fadeOut.delay = _length - _fadeOut.repeatCount *_fadeIn.delay -1000;
				_fadeOut.addEventListener( TimerEvent.TIMER, _startFadeOut, false, 0, true );
				_fadeOut.removeEventListener( TimerEvent.TIMER, _fadingOut );
				_fadeOut.start();
			}
		}
		
		public function stop():void
		{
			if ( _fadeIn ) _fadeIn.stop();
			if ( _fadeOut ) _fadeOut.stop();
			
			if ( _index < _soundObjMap.length ) {
				var n:String = _soundObjMap[_index];
				_index = _soundObjMap.length;
				GameSounds.stop( n );
			}
		}
		
		
			// -- private --
			
			private var _fadeIn:Timer, _fadeOut:Timer, _timeStart:uint
			private var _index:uint, _onComplete:Function, _length:uint;
			private var _soundObjMap:Vector.<String>
			private var _soundObjMapLoop:Vector.<uint>
			
			private function _playNext( sndObj:GameSoundObj ):void
			{
				if ( _index + 1 < _soundObjMap.length ) {
					trace( '3:  ...next sequence ['+ _index +']...' );
					
					_index++;
					//var vol:Number = Math.max( _fadeIn? Math.min(_fadeIn.currentCount/_fadeIn.repeatCount, 1): 1, _fadeOut? Math.min(1 -_fadeIn.currentCount/_fadeIn.repeatCount, 1): 1 );
					GameSounds.play( _soundObjMap[_index], 0, _soundObjMapLoop[_index], GameSounds.volumeMusic, _playNext );
					
				} else
				if ( _onComplete != null ) {
					_onComplete.call();
					_onComplete = null;
				}
			}
			
			private function _fadingIn( e:TimerEvent ):void
			{
				GameSounds.setPanVol( _soundObjMap[_index], 0, Quad.easeOut(_fadeIn.currentCount, 0, 1, _fadeIn.repeatCount) *GameSounds.volumeMusic );
			}
			
			private function _startFadeOut( e:TimerEvent ):void
			{
				_fadeOut.delay = _fadeIn.delay;
				_fadeOut.removeEventListener( TimerEvent.TIMER, _startFadeOut );
				_fadeOut.addEventListener( TimerEvent.TIMER, _fadingOut, false, 0, true );
			}
			
			private function _fadingOut( e:TimerEvent ):void
			{
				GameSounds.setPanVol( _soundObjMap[_index], 0, Quad.easeOut(_fadeOut.currentCount, 1, -1, _fadeOut.repeatCount) *GameSounds.volumeMusic );
			}
			
	}

}