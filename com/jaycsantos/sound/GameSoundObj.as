package com.jaycsantos.sound 
{
	import com.jaycsantos.IDisposable;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameSoundObj implements IDisposable 
	{
		public static var ChangeGap:uint = 60
		
		public var name:String, sound:Sound, priority:uint, group:uint
		public var channel:SoundChannel
		public var onStop:Signal, onEnd:Signal
		
		public function GameSoundObj( name:String, sound:Sound, priority:int=50, group:uint=1 )
		{
			this.name = name;
			this.sound = sound;
			this.priority = priority;
			this.group = group;
			onStop = new Signal( GameSoundObj );
			onEnd = new Signal( GameSoundObj );
		}
		
		public function dispose():void 
		{
			onStop.removeAll();
			onEnd.removeAll();
			channel = null;
			sound = null;
		}
		
		
		public function play( startTime:Number=0, loops:int=0, volume:Number=1, pan:Number=0 ):void
		{
			_start = getTimer();
			channel = sound.play( startTime, _loops = Math.max(loops,1) );
			channel.addEventListener( Event.SOUND_COMPLETE, _onSoundComplete, false, 0, true );
			setPanVol( pan, volume );
			
			CONFIG::debug { trace( '2:[audio] play '+ name +' @'+ volume.toFixed(2) +' @'+ Number(getTimer()/1000).toFixed(2) +'s' ); }
		}
		
		public function stop():void
		{
			CONFIG::debug { trace('2:[audio] stop '+ name +' @'+ Number(getTimer()/1000).toFixed(2) +'s'); }
			
			if ( channel ) {
				channel.stop();
				channel.removeEventListener( Event.SOUND_COMPLETE, _onSoundComplete );
				channel = null;
			}
			
			onStop.dispatch( this );
		}
		
		public function setPanVol( pan:Number=0, vol:Number=1 ):void
		{
			if ( _lastChange > getTimer() || !channel ) return;
			
			_lastChange = getTimer() +ChangeGap;
			
			var sndXform:SoundTransform = channel.soundTransform;
			sndXform.pan = pan;
			sndXform.volume = vol;
			channel.soundTransform = sndXform;
			
			//CONFIG::debug { trace('2:[audio] '+ name +' vol @'+ vol.toFixed(2) +' | pan @'+ pan.toFixed(2)); }
		}
		
		public function get volume():Number
		{
			return channel ? channel.soundTransform.volume : 0;
		}
		
		public function get pan():Number
		{
			return channel ? channel.soundTransform.pan : 0;
		}
		
		
		public function isPlaying():Boolean
		{
			return channel != null;
		}
		
		public function getLength():uint
		{
			return (sound.length >> 0) *_loops;
		}
		
		public function getStartTime():uint
		{
			return channel != null ? _start : 0;
		}
		
		
			// -- private --
			
			protected var _lastChange:uint, _loops:int, _start:int
			
			protected function _onSoundComplete( e:Event ):void
			{
				CONFIG::debug { trace( '2:[audio] end '+ name +' @'+ Number(getTimer()/1000).toFixed(2) +'s' ); }
				
				channel.removeEventListener( Event.SOUND_COMPLETE, _onSoundComplete );
				channel = null;
				
				onEnd.dispatch( this );
			}
		
	}

}