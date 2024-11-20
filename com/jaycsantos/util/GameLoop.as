package com.jaycsantos.util
{
	import com.jaycsantos.util.ns.internalGameloop;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public final class GameLoop
	{
		use namespace internalGameloop;
		
		public static function get instance():GameLoop
		{
			if ( ! _instance ) {
				_allow = true;
				_instance = new GameLoop;
				_allow = false;
			}
			
			return _instance;
		}
		
		
		public function get frameRate():uint
		{
			return _fps;
		}
		public function get timeFrameRate():uint
		{
			return _stageFrameTime;
		}
		public function get deltaTime():uint
		{
			return _deltaTime;
		}
		public function get timeStep():Number
		{
			return _timeStep;
		}
		public function get time():uint
		{
			return _lastTime;
		}
		
		
		public function GameLoop()
		{
			if ( ! _allow )
				throw new Error("[com.jaycsantos.util.GameLoop::constructor] Singleton, use static property instance");
			
			
			_callbacks = new Vector.<Function>();
		}
		
		
		internalGameloop var maxDeltaTime:uint;
		internalGameloop var minDeltaTime:uint;
		
		internalGameloop function activate( clip:DisplayObject ):void
		{
			_fps = 0;
			_fpsCounter = 0;
			_fpsClock = 0;
			_stageFps = clip.stage.frameRate;
			_stageFrameTime = 1000 / _stageFps;
			
			maxDeltaTime = _stageFrameTime * 1.75 << 0;
			minDeltaTime = _stageFrameTime * 0.75 << 0;
			
			clip.addEventListener( Event.ENTER_FRAME, update );
		}
		
		internalGameloop function addCallback( callback:Function ):void
		{
			if ( _callbacks.indexOf(callback) == -1 )
				_callbacks.push( callback );
		}
		
		internalGameloop function removeCallback( callback:Function ):void
		{
			var pos:int = _callbacks.indexOf( callback );
			if ( pos > -1 )
				_callbacks.splice( pos, 1 );
		}
		
		
			// -- private --
			
			private static var _allow:Boolean;
			private static var _instance:GameLoop;
			
			private var _timeStep:Number;	// time step multiplier
			private var _deltaTime:uint;	// Delta time between frames
			private var _lastTime:uint;	// Last getTimer() value
			
			private var _stageFps:uint;
			private var _stageFrameTime:Number;
			private var _fps:uint;		// Frames counted in the last second
			private var _fpsCounter:uint;	// Frames beign counted this second
			private var _fpsClock:uint;	// Clock to know when one second passed
			
			private var _callbacks:Vector.<Function>; // the update loop callbacks
			
			
			private function update( e:Event ):void
			{
				// delta time
				var time:uint = getTimer();
				_deltaTime = time - _lastTime;
				_deltaTime = Math.max( minDeltaTime, Math.min(_deltaTime, maxDeltaTime) );
				
				_lastTime = time;
				_timeStep = _deltaTime / _stageFrameTime;
				
				// update fps
				_fpsCounter++;
				_fpsClock += _deltaTime;
				
				if ( _fpsClock >= 1000 ) {
					_fps = _fpsCounter;
					_fpsClock -= 1000;
					_fpsCounter = 0;
				}
				
				for each( var callback:Function in _callbacks )
					callback.call();
			}
			
			
	}

}