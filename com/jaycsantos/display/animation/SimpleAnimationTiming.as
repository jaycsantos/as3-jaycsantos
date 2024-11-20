package com.jaycsantos.display.animation 
{
	import com.jaycsantos.util.GameLoop;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class SimpleAnimationTiming
	{
		public var frameSpeed:uint, looping:Boolean, onComplete:Function, step:uint, fixedStep:Boolean
		
		public function get isPlaying():Boolean
		{
			return ! _stop
		}
		public function set isPlaying( value:Boolean ):void
		{
			_timer = _index * frameSpeed;
			_stop = false;
		}
		
		
		public function get sequence():Vector.<uint> 
		{
			return _sequence.concat()
		}
		public function get length():uint 
		{
			return _length;
		}
		
		public function get index():uint
		{
			return _index;
		}
		
		public function get frame():uint
		{
			return _sequence[ _index ];
		}
		
		
		public function SimpleAnimationTiming( sequence:Array, framespeed:uint = 0, loop:Boolean = false, completeCallback:Function = null, fixedstep:int = -1 )
		{
			_sequence = Vector.<uint>( sequence );
			_length = sequence.length;
			frameSpeed = framespeed > 0? framespeed: GameLoop.instance.timeFrameRate;
			if ( fixedstep > -1 ) {
				fixedStep = true;
				step = fixedstep? fixedstep: GameLoop.instance.timeFrameRate;
			}
			looping = loop;
			onComplete = completeCallback;
			_indexCallback = new Vector.<Function>( sequence.length, true );
			_mcList = new Vector.<MovieClip>;
			
			_stop = true;
		}
		
		public function dispose():void 
		{
			onComplete = null;
			_indexCallback.fixed = false;
			_indexCallback.splice( 0, _indexCallback.length );
			
			_mcList.splice( 0, _mcList.length );
		}
		
		
		public function update():void 
		{
			if ( _stop ) return;
			
			var t:uint = fixedStep? step: GameLoop.instance.deltaTime;
			if ( ! t ) return;
			
			_timer += t;
			
			var frame:uint = _timer / frameSpeed << 0;
			var maxFrame:uint = _length - 1;
			
			if ( frame > maxFrame ) {
				if ( ! looping ) {
					frame = maxFrame;
					_timer = frame * frameSpeed;
					_stop = true;
					if ( onComplete != null ) onComplete();
					
				} else {
					frame %= maxFrame + 1;
					_timer = frame * frameSpeed;
				}
			}
			
			_index = frame;
			
			if ( !_stop && _indexCallback && _indexCallback[frame] != null )
				_indexCallback[frame]();
			
			for each( var mc:MovieClip in _mcList )
				mc.gotoAndStop( _sequence[_index] );
		}
		
		
		public function addIndexCallback( index:uint, callback:Function ):void 
		{
			if ( index < 0 || index >= _length )
				throw new Error( "[com.jaycsantos.display.animation.SimpleAnimationTiming::addIndexCallback] sequence index "+ frame +" is out of range" );
			
			_indexCallback[ index ] = callback;
		}
		
		public function addMovieClip( mc:MovieClip ):void
		{
			if ( _mcList.indexOf(mc) == -1 )
				_mcList.push( mc );
			mc.gotoAndStop( _sequence[_index] );
		}
		
		public function removeMovieClip( mc:MovieClip ):void
		{
			var p:int = _mcList.indexOf(mc);
			if ( p > -1 )
				_mcList.splice( p, 1 );
		}
		
		
		public function playAt( index:uint = 0 ):void 
		{
			if ( index < 0 || index >= _length )
				throw new Error( "[com.jaycsantos.display.animation.SimpleAnimationTiming::playAt] sequence index "+ index +" is out of range" );
			
			_index = index;
			_timer = _index * frameSpeed;
			_stop = false;
		}
		
		public function stop( index:int = -1 ):uint
		{
			if ( index < 0 ) index = _index;
			if ( index < 0 || index >= _length )
				throw new Error( "[com.jaycsantos.display.animation.SimpleAnimationTiming::stop] sequence index "+ index +" is out of range" );
			
			_index = index;
			_timer = _index * frameSpeed;
			_stop = true;
			return _index;
		}
		
		
			// -- private --
			
			protected var _sequence:Vector.<uint>
			protected var _length:uint
			protected var _index:uint
			protected var _timer:uint
			protected var _stop:Boolean
			protected var _indexCallback:Vector.<Function>
			protected var _mcList:Vector.<MovieClip>
			
	}

}