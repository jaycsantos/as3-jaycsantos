package com.jaycsantos.display.animation 
{
	import com.jaycsantos.util.GameLoop;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class AnimationTiming
	{
		public var frameSpeed:uint, looping:Boolean, step:uint, fixedStep:Boolean
		
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
		public function get setName():String 
		{
			return _setName
		}
		public function get length():uint 
		{
			return _setLen
		}
		
		public function get index():uint
		{
			return _index;
		}
		
		public function get frame():uint
		{
			return _sequence[ _index ];
		}
		
		
		public function AnimationTiming( defaultSequence:Array, defaultFramespeed:uint=0, fixedstep:int=-1, loop:Boolean=false, onComplete:Function=null, onInterupt:Function=null )
		{
			_sets = new Dictionary;
			_dataMap = new Dictionary;
			
			frameSpeed = defaultFramespeed ? defaultFramespeed : GameLoop.instance.timeFrameRate;
			if ( fixedstep > -1 ) {
				fixedStep = true;
				step = fixedstep? fixedstep: GameLoop.instance.timeFrameRate;
			}
			
			_sets[ "default" ] = Vector.<uint>( defaultSequence );
			_dataMap[ "fs_default" ] = frameSpeed;
			_dataMap[ "l_default" ] = loop;
			_dataMap[ "co_default" ] = onComplete;
			_dataMap[ "ci_default" ] = onInterupt;
			
			_setQueue = new Vector.<String>();
			_mcList = new Vector.<MovieClip>;
			
			playSet( "default" );
			_stop = true;
		}
		
		public function dispose():void 
		{
			_setQueue.splice( 0, _setQueue.length );
			_sequence.splice( 0, _sequence.length );
			_mcList.splice( 0, _mcList.length );
			_setName = null;
			
			for ( var k:String in _sets ) {
				delete _sets[k];
				if ( _dataMap["call_"+k] ) {
					_indexCallback = Vector.<Function>( _dataMap["call_"+k] );
					_indexCallback.fixed = false;
					_indexCallback.splice( 0, _indexCallback.length );
					delete _dataMap["call_"+k];
				}
				delete _dataMap["l_"+k];
				delete _dataMap["fs_"+k];
			}
			
			_setQueue = null;
			_sequence = null;
			_mcList = null;
			_indexCallback = null;
		}
		
		
		public function update():void 
		{
			if ( _stop ) return;
			
			var t:uint = fixedStep? step: GameLoop.instance.deltaTime;
			if ( ! t ) return;
			
			_timer += t;
			
			var fr:uint = _timer / frameSpeed << 0;
			var frMax:uint = _setLen - 1;
			
			if ( fr > frMax ) {
				if ( ! looping ) {
					fr = frMax;
					_timer = fr * frameSpeed;
					_stop = true;
					if ( _dataMap["co_" + _setName] != null )
						_dataMap[ "co_" + _setName ]();
					if ( _setQueue.length ) {
						_playSet( _setQueue.shift() );
						replay();
					}
					return;
					
				} else {
					fr %= frMax + 1;
					_timer = fr * frameSpeed;
					if ( _dataMap["co_" + _setName] != null )
						_dataMap[ "co_" + _setName ]();
				}
			}
			
			_index = fr;
			
			if ( _indexCallback && _indexCallback[fr] != null )
				_indexCallback[fr]();
			
			for each ( var mc:MovieClip in _mcList )
				mc.gotoAndStop( _sequence[index] );
		}
		
		
		public function addIndexScript( index:uint, callback:Function, setName:String='default' ):void 
		{
			if ( ! setName ) setName = 'default';
			if ( ! _sets[setName] )
				throw new Error("[com.jaycsantos.display.animation.ClipAnimator::addIndexScript] Sequence set name '" + setName +"' does not exist");
			
			var list:Vector.<Function>;
			if ( _dataMap["call_" + setName] == undefined )
				list = _dataMap[ "call_" + setName ] = new Vector.<Function>( Vector.<uint>(_sets[setName]).length, true );
			else
				list = Vector.<Function>( _dataMap[ "call_" + setName ] );
			
			if ( index < 0 || index >= list.length )
				throw new Error( "[com.jaycsantos.display.animation.ClipAnimator::addIndexScript] sequence index "+ frame +" for sequence set '"+ setName +"' is out of range" );
			
			list[ index ] = callback;
		}
		
		public function addSequenceSet( setName:String, sequence:Array, framespeed:uint = 0, loop:Boolean = false, onComplete:Function = null, onInterupt:Function = null ):void 
		{
			if ( _sets[setName] )
				throw new Error("[com.jaycsantos.display.animation.ClipAnimator::addSequenceSet] Sequence set name '" + setName +"' is already added");
			
			_sets[ setName ] = Vector.<uint>( sequence );
			_dataMap[ "fs_" + setName ] = framespeed? framespeed: _dataMap[ "fs_default" ];
			_dataMap[ "l_" + setName ] = loop;
			_dataMap[ "co_" + setName ] = onComplete;
			_dataMap[ "ci_" + setName ] = onInterupt;
		}
		
		
		public function replay():void 
		{
			_index = 0;
			_timer = 0;
			_stop = false;
		}
		
		public function playAt( index:uint = 0 ):void 
		{
			if ( index < 0 || index >= _setLen )
				throw new Error( "[com.jaycsantos.display.animation.ClipAnimator::playAt] sequence index "+ frame +" is out of range" );
			
			_index = index;
			_timer = _index * frameSpeed;
			_stop = false;
		}
		
		public function stop( index:int =-1 ):void
		{
			if ( index <= -1 ) index = _index;
			if ( index < 0 || index >= _setLen )
				throw new Error( "[com.jaycsantos.display.animation.ClipAnimator::stop] sequence index "+ frame +" is out of range" );
			
			_index = index;
			_timer = _index * frameSpeed;
			_stop = true;
		}
		
		public function playSet( setName:String='default', index:uint=0 ):void 
		{
			if ( _dataMap["ci_" + _setName] != null && ! _stop && _setName != setName )
				_dataMap["ci_" + _setName]();
			
			_playSet( setName );
			playAt( index );
			
			if ( _setQueue.length )
				_setQueue.splice( 0, _setQueue.length );
		}
		
		public function replaySet( setName:String ):void
		{
			playSet( setName );
			replay();
		}
		
		public function appendSet( setName:String ):void 
		{
			if ( ! _sets[setName] )
				throw new Error("[com.jaycsantos.display.animation.ClipAnimator::appendSet] Sequence set name '" + setName +"' does not exist");
			
			_setQueue.push( setName );
		}
		
		
		public function addMovieClip( mc:MovieClip ):void
		{
			var p:int = _mcList.indexOf( mc );
			if ( p == -1 ) _mcList.push( mc );
		}
		
		public function removeMovieClip( mc:MovieClip ):void
		{
			var p:int = _mcList.indexOf( mc );
			if ( p > -1 )
				_mcList.splice( p, 1 );
		}
		
		
			// -- private --
			
			protected var _setQueue:Vector.<String>
			protected var _sequence:Vector.<uint>
			protected var _setName:String
			protected var _setLen:uint
			protected var _sets:Dictionary
			protected var _dataMap:Dictionary
			protected var _index:uint
			protected var _timer:uint
			protected var _stop:Boolean
			protected var _indexCallback:Vector.<Function>
			protected var _mcList:Vector.<MovieClip>
			
			protected function _playSet( setName:String = 'default' ):void
			{
				if ( setName == _setName )
					return;
				
				if ( ! _sets[setName] )
					throw new Error("[com.jaycsantos.display.animation.ClipAnimator::playSet] Sequence set name '" + setName +"' does not exist");
				replay();
				
				
				_setName = setName;
				_sequence = Vector.<uint>( _sets[setName] );
				_indexCallback = _dataMap["call_" + setName] ? Vector.<Function>( _dataMap["call_" + setName] ) : null;
				looping = _dataMap[ "l_" + setName ];
				frameSpeed = _dataMap[ "fs_" + setName ];
				_setLen = _sequence.length;
			}
			
	}

}