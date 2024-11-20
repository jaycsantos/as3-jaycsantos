package com.jaycsantos.display
{
	import com.jaycsantos.game.IGameObject;
	import com.jaycsantos.util.GameLoop;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author ...
	 */
	public class AbstractAnimator implements IGameObject
	{
		public var buffer:DisplayObject;
		public var frameSpeed:uint;
		public var loop:Boolean;
		public var paused:Boolean;
		
		public function get sequence():Vector.<uint> 
		{
			return _sequence.concat();
		}
		public function get currentFrame():uint
		{
			return _currentFrame + 1;
		}
		public function get totalFrames():uint
		{
			return _sequenceLen;
		}
		
		
		public var onFrameTick:Signal;
		public var onEndFrame:Signal;
		
		
		public function AbstractAnimator( sequence:Vector.<uint>, frameSpeed:uint = 0, loop:Boolean = true )
		{
			_sequence = sequence.concat();
			_sequence.fixed = true;
			_sequenceLen = _sequence.length;
			_sequenceCallbacks = new Vector.<Function>( _sequenceLen, true );
			
			this.loop = loop;
			this.frameSpeed = frameSpeed ? frameSpeed : (GameLoop.timeFrameRate << 0);
			
			onFrameTick = new Signal( uint );
			onEndFrame = new Signal();
			
			_currentFrame = 0;
			_frameTimer = 0;
		}
		
		public function dispose():void
		{
			if ( buffer.parent )
				buffer.parent.removeChild( buffer );
			
			buffer = null;
			
			_sequence.fixed = false;
			_sequence.splice( 0, _sequence.length );
			_sequenceCallbacks.fixed = false;
			_sequenceCallbacks.splice( 0, _sequenceCallbacks.length );
			
			onFrameTick.removeAll();
			onFrameTick = null;
			onEndFrame.removeAll();
			onEndFrame = null;
		}
		
		
		public function update():void
		{
			if ( paused ) return;
			
			
			_frameTimer += GameLoop.deltaTime;
			
			var frame:uint = _frameTimer / frameSpeed << 0;
			var totalFrames:uint = _sequenceLen - 1;
			
			if ( ! loop ) {
				if ( frame > totalFrames ) {
					frame = totalFrames;
					_frameTimer = frameSpeed * frame;
					onEndFrame.dispatch();
					paused = true;
				}
			} else {
				if ( frame > totalFrames ) {
					_frameTimer = _frameTimer % (frameSpeed * _sequenceLen);
					frame = frame % _sequenceLen;
				}
			}
			
			if ( _currentFrame != frame )
				onFrameTick.dispatch( frame );
			
			_currentFrame = frame;
			
			if ( _sequenceCallbacks[frame] != null )
				_sequenceCallbacks[ frame ]();
			
			_updateAnimation();
		}
		
		
		public function clone():void
		{
			throw new Error( "[com.jaycsantos.display.AbstractAnimator::clone] Subclass should override the clone method" );
		}
		
		
		public function addFrameCallback( frame:int, callback:Function ):void
		{
			if ( frame <= 0 || frame > _sequenceLen )
				throw new Error( "[com.jaycsantos.display.AbstractAnimator::addFrameScript] frame index "+ frame +" is out of scope" );
			
			_sequenceCallbacks[ frame - 1 ] = callback;
		}
		
		public function playFrame( frame:int ):void
		{
			if ( frame <= 0 || frame > _sequenceLen )
				throw new Error( "[com.jaycsantos.display.AbstractAnimator::playFrame] frame index "+ frame +" is out of scope" );
			
			_currentFrame = frame - 1;
			_frameTimer = _currentFrame * frameSpeed;
			paused = false;
			_updateAnimation();
		}
		
		public function replay():void
		{
			_frameTimer = 0;
			_currentFrame = 0;
			paused = false;
			_updateAnimation();
		}
		
		public function playNewSequence( sequence:Vector.<uint> ):void
		{
			_sequence = sequence.concat();
			_sequence.fixed = true;
			_sequenceLen = _sequence.length;
			
			_sequenceCallbacks = new Vector.<Function>( _sequenceLen, true );
			
			_currentFrame = 0;
			_frameTimer = 0;
			_updateAnimation();
		}
		
		public function appendSequence( sequence:Vector.<uint> ):void
		{
			_sequence.fixed = _sequenceCallbacks.fixed = false;
			_sequence = _sequence.concat( sequence );
			
			_sequenceCallbacks = _sequenceCallbacks.concat( new Vector.<Function>(sequence.length) );
			
			_sequenceLen = _sequence.length;
			
			_sequence.fixed = _sequenceCallbacks.fixed = true;
		}
		
		
			// -- private --
			
			protected var _sequence:Vector.<uint>;
			protected var _sequenceLen:uint;
			protected var _sequenceCallbacks:Vector.<Function>;
			protected var _currentFrame:uint = 0;
			protected var _frameTimer:uint;
			
			
			protected function _updateAnimation():void
			{
				throw new Error( "[com.jaycsantos.display.AbstractAnimator::_updateAnimation] Subclass should override the _updateAnimation method" );
			}
			
			
			
	}

}