package com.jaycsantos.sound 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class GameSoundGroup extends GameSoundObj 
	{
		
		public function GameSoundGroup( name:String, priority:int=50, group:uint=2 )
		{
			super( name, null, priority, group );
			
			_queue = new Vector.<Sound>;
		}
		
		override public function dispose():void 
		{
			_queue.splice( 0, _queue.length );
			
			super.dispose();
		}
		
		
		public function queue( sounds:Array, arrangement:Array ):void
		{
			if ( !sounds.length ) throw new Error( '[com.jaycsantos.util.GameSoundGroup] must have arguments' );
			
			for each ( var i:int in arrangement )
				_queue.push( sounds[i] );
			
			sound = _queue[0];
			_len = 0;
		}
		
		
		override public function play( startTime:Number=0, loops:int=0, volume:Number=1, pan:Number=0 ):void 
		{
			_index = 0;
			_loop = 1;
			_start = getTimer();
			
			sound = _queue[ _index ];
			channel = sound.play( startTime );
			channel.addEventListener( Event.SOUND_COMPLETE, _playNext, false, 0, true );
			setPanVol( pan, volume );
			_loops = Math.max( loops, 1 );
			
			CONFIG::debug { trace( '2:[snd grp] play '+ name +' @'+ volume.toFixed(2) +' @'+ Number(getTimer()/1000).toFixed(2) +'s' ); }
		}
		
		override public function stop():void 
		{
			CONFIG::debug { trace('2:[snd grp] stop '+ name); }
			
			sound = _queue[0];
			if ( channel ) {
				channel.stop();
				channel.removeEventListener( Event.SOUND_COMPLETE, _playNext );
				channel = null;
			}
			
			onStop.dispatch( this );
		}
		
		
		override public function getLength():uint 
		{
			if ( !_len ) {
				var n:Number = 0;
				for each( var snd:Sound in _queue )
					n += snd.length;
				_len = n *_loops;
			}
			return _len;
		}
		
		
		
			// -- private --
			
			private var _index:uint, _loop:uint, _len:uint
			private var _queue:Vector.<Sound>
			
			
			private function _playNext( e:Event=null ):void
			{
				if ( channel ) channel.removeEventListener( Event.SOUND_COMPLETE, _playNext );
				
				var pan:Number, vol:Number;
				if ( _index + 1 < _queue.length ) {
					_index++;
					sound = _queue[ _index ];
					
					pan = channel.soundTransform.pan;
					vol = channel.soundTransform.volume;
					
					channel = sound.play();
					channel.addEventListener( Event.SOUND_COMPLETE, _playNext, false, 0, true );
					setPanVol( pan, vol );
					
				} else if ( _loop < _loops ) {
					if ( _loops != int.MAX_VALUE )
						_loop++;
					_index = 0;
					sound = _queue[ _index ];
					
					pan = channel.soundTransform.pan;
					vol = channel.soundTransform.volume;
					
					channel = sound.play();
					channel.addEventListener( Event.SOUND_COMPLETE, _playNext, false, 0, true );
					setPanVol( pan, vol );
					
				} else {
					sound = _queue[0];
					channel = null;
					onEnd.dispatch( this );
					CONFIG::debug { trace( '2:[snd grp] end '+ name +' @'+ Number(getTimer()/1000).toFixed(2) +'s' ); }
					
				}
			}
			
	}

}