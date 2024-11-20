package com.jaycsantos.game
{
	import apparat.math.FastMath;
	import com.jaycsantos.AssetFactory;
	import com.jaycsantos.display.screen.AbstractScreen;
	import com.jaycsantos.display.screen.nAbstractScreen;
	import com.jaycsantos.IDisposable;
	import com.jaycsantos.util.GameLoop;
	import com.jaycsantos.util.KeyCode;
	import com.jaycsantos.util.UserInput;
	import com.jaycsantos.util.ns.internalGameloop;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	
	public final class GameRoot extends Sprite
	{
		CONFIG::debug {
			public static function togglePause():void
			{
				_breakUpdate = !_breakUpdate;
				trace( "[GameRoot] togglePause " + (_breakUpdate ? "true" : "false") +"" );
			}
			
			public static function breakPoint( msg:String, force:Boolean = false ):void
			{
				if ( _allowBreakPoints || force ) {
					_breakUpdate = true;
					trace( "[GameRoot] Breakpoint: " + msg );
				}
			}
			
			public static function toggleAllowBreakPoints():void
			{
				_allowBreakPoints = ! _allowBreakPoints;
				trace( "[GameRoot] break points allowed " + (_allowBreakPoints ? "true" : "false") +"" );
			}
			
			
			// -- static private --
			
			public static var _breakUpdate:Boolean = false;
			public static var _allowBreakPoints:Boolean = false;
		}
		
		
		public static function get screen():AbstractScreen
		{
			return _i.currentScreen;
		}
		
		public static function get screenClass():Class
		{
			return _i._currentScreenClass;
		}
		
		public static function get nextScreenClass():Class
		{
			return _i._screenClassToShow;
		}
		
		public static function changeScreen( screenClass:Class, data:Object = null ):void
		{
			_i.changeScreen( screenClass, data );
		}
		
			private static var _i:GameRoot
		
		
		public var maxTimeStep:Number = 1.6
		public var minTimeStep:Number = 0.8
		
		public var currentScreen:AbstractScreen;
		
		public function GameRoot()
		{
			name = "com_jaycsantos_GameRoot";
			mouseEnabled = tabEnabled = false;
			
			if ( stage ) _init();
			else addEventListener( Event.ADDED_TO_STAGE, _init, false, 0, true );
			
			_i = this;
			
			//currentScreen = new AbstractScreen( this );
			//changeScreen( AbstractScreen );
		}
		
		public function changeScreen( ScreenClass:Class, data:Object = null ):void
		{
			// its the same screen
			if ( ! _locked && _currentScreenClass != ScreenClass ) {
				_screenClassToShow = ScreenClass;
				_screenClassData = data;
			} else {
				if ( _locked )
					trace( "[com.jaycsantos.game.GameRoot::changeScreen] Attempted to change screen to '"+ ScreenClass +"' while a screen is still entering/exiting" );
			}
		}
		
		
		public function get screenClass():Class
		{
			return _currentScreenClass;
		}
		
		public function get nextScreenClass():Class
		{
			return _screenClassToShow;
		}
		
			// -- private --
			
			protected var _input:UserInput = UserInput.instance
			protected var _screenClassToShow:Class
			protected var _screenClassData:Object
			protected var _currentScreenClass:Class
			protected var _screenToShow:AbstractScreen
			
			private var _locked:Boolean
			private var _lastLoopTime:int = 0
			
			protected function _init( e:Event = null ):void
			{
				removeEventListener( Event.ADDED_TO_STAGE, _init );
				
				_input.initialize( stage );
				
				
				use namespace internalGameloop;
				
				with( GameLoop.instance ) {
					activate( this );
					addCallback( _update );
					maxDeltaTime = stage.frameRate * maxTimeStep;
					minDeltaTime = stage.frameRate * minTimeStep;
				}
			}
			
			protected function _update():void
			{
				use namespace nAbstractScreen;
				
				if ( _screenClassToShow != null )
					_updateChangeScreen();
				
				CONFIG::debug {
					if ( ! _breakUpdate && currentScreen != null )
						currentScreen.n_update();
					_debugInputHandler();
					DOutput.show( _input.mouseX, _input.mouseY );
				}
				CONFIG::release {
					if ( currentScreen != null )
						currentScreen.n_update();
				}
				
				_input.update();
			}
			
			CONFIG::debug {
				protected function _debugInputHandler():void
				{
					if ( _input.isKeyPressed(KeyCode.END) )
						GameRoot.togglePause();
					if ( _input.isKeyPressed(KeyCode.EQUALS) )
						GameRoot.toggleAllowBreakPoints();
				}
			}
			
			protected function _updateChangeScreen():void
			{
				use namespace nAbstractScreen;
				
				if ( !(_screenToShow is _screenClassToShow) ) {
					_locked = true;
					
					if ( currentScreen && currentScreen._state == AbstractScreen.f_UPDATING )
						currentScreen.n_exit();
					else if ( _screenToShow )
						_screenToShow.dispose();
					
					_screenToShow = new _screenClassToShow( this, _screenClassData );
					if (! _screenToShow is AbstractScreen )
						throw new Error( "[com.jaycsantos.game.GameRoot::changeScreen] '" + getQualifiedClassName(_screenToShow) + "' should be a subclass of AbstractScreen" );
					
					return;
				}
				
				// supports pre-enter of screen to be showned
				if ( !_screenToShow._state == AbstractScreen.f_ENTERING )
					_screenToShow.n_update();
				
				if ( !currentScreen || currentScreen._state == AbstractScreen.f_GONE || currentScreen._state == AbstractScreen.f_IDLE ) {
					if ( currentScreen )
						currentScreen.dispose();
					
					currentScreen = _screenToShow;
					currentScreen.n_enter();
					stage.focus = stage;
					
					_screenToShow = null;
					_screenClassToShow = null;
					_screenClassData = null;
					_locked = false;
				}
				
			}
			
	}

}