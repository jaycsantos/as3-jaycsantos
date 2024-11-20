package com.jaycsantos.util 
{
	import apparat.math.FastMath;
	import flash.display.Stage;
	import flash.events.*;
 	import flash.utils.getTimer;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class UserInput
	{
		public static var bufferSize:uint = 5;
		
		// last key pressed
		public var lastKeyName:String = "";
		public var lastKeyCode:int = 0;
		
		// mouse states
		public var isFocused:Boolean = true
		public var isFocusLost:Boolean = false
		public var isMouseDown:Boolean = false
		public var isMousePressed:Boolean = false
		public var isMouseReleased:Boolean = false
		public var mouseX:Number = 0
		public var mouseY:Number = 0
		public var mouseWheelDelta:int = 0
		
		
		public function UserInput()
		{
			if ( ! _allow )
				throw new Error( "[com.jaycsantos.util.UserInput] Singleton, use static property instance" );
			
			// init ascii array
			_ascii = new Array( 222 );
			_fillAscii();
			
			// init key state array
			_keyState = new Vector.<int>( 222 );
			_keyArr = new Vector.<int>();
			for ( var i:int = 0; i < 222; i++ ) {
				_keyState[ i ] = new int(0);
				if ( _ascii[i] != undefined )
					_keyArr.push( i );
			}
			
			// buffer
			_keyBuffer = new Vector.<Array>( bufferSize );
			for ( var j:int = 0; j < bufferSize; j++ )
				_keyBuffer[ j ] = new Array(0, 0);
			
			_lastLoopTime = 0;
		}
		
		public function initialize( stage:Stage ):void
		{
			_stage = stage;
			
			// key listeners
			stage.addEventListener( KeyboardEvent.KEY_DOWN, _keyPressed, false, 0, true );
			stage.addEventListener( KeyboardEvent.KEY_UP, _keyReleased, false, 0, true );
			
			// mouse listeners
			stage.addEventListener( MouseEvent.MOUSE_DOWN, _mousePressed, false, 0, true );
			stage.addEventListener( MouseEvent.MOUSE_UP, _mouseReleased, false, 0, true );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, _mouseMoved, false, 0, true );
			stage.addEventListener( MouseEvent.MOUSE_WHEEL, _mouseScrolled, false, 0, true );
			
			// focus listeners
			stage.addEventListener( Event.ACTIVATE, _stageActivate, false, 0, true );
			stage.addEventListener( Event.DEACTIVATE, _stageDeactivate, false, 0, true );
		}
		
		public function update():void
		{
			var time:uint = getTimer();
			var delta:uint = time - _lastLoopTime;
			_lastLoopTime = time;
			
			// update used keys
			for each( var k:int in _keyArr )
				if ( _keyState[k] != 0 )
					_keyState[k]++;
			
			// update buffer
			for each( var b:Array in _keyBuffer )
				b[1] += delta;
			
			
			isMousePressed = false;
			isMouseReleased = false;
			isFocusLost = false;
			mouseWheelDelta = 0;
		}
		
		
		/**
		 * TO USE PUBLIC METHODS
		 */
		public function isKeyDown( keyCode:int ):Boolean
		{
			return _keyState[ keyCode ] > 0;
		}
		
		public function isKeyPressed( keyCode:int ):Boolean
		{
			return _keyState[ keyCode ] == 1;
		}
		
		public function isKeyReleased( keyCode:int ):Boolean
		{
			return _keyState[ keyCode ] == -1;
		}
		
		public function isKeyBuffered( keyCode:int, index:int, time:int ):Boolean
		{
			return _keyBuffer[ index ][0] == keyCode && _keyBuffer[ index ][1] <= time;
		}
		
		public function getKeyString( keyCode:int ):String
		{
			return _ascii[ keyCode ];
		}
		
		
		/**
		 * TO USE GETTERS
		 */
		public function get timeOfLastKeyPress():int
		{
			return getTimer() - _timeKeyPressed;
		}
		
		public function get timeOfLastKeyRelease():int
		{
			return getTimer() - _timeKeyReleased;
		}
		
		public function get timeOfMousePress():int
		{
			return getTimer() - _timeMousePressed;
		}
		
		public function get timeOfMouseRelease():int
		{
			return getTimer() - _timeMouseReleased;
		}
		
		
		
		
			// -- private --
			
			private var _stage:Stage;
			private var _ascii:Array;
			private var _keyState:Vector.<int>;
			private var _keyArr:Vector.<int>;
			private var _keyBuffer:Vector.<Array>;
			
			private var _timeKeyPressed:int;
			private var _timeKeyReleased:int;
			private var _timeMousePressed:int;
			private var _timeMouseReleased:int;
			
			private var _lastLoopTime:uint;
			
			
			private function _fillAscii():void
			{
				_ascii[65] = "A";
				_ascii[66] = "B";
				_ascii[67] = "C";
				_ascii[68] = "D";
				_ascii[69] = "E";
				_ascii[70] = "F";
				_ascii[71] = "G";
				_ascii[72] = "H";
				_ascii[73] = "I";
				_ascii[74] = "J";
				_ascii[75] = "K";
				_ascii[76] = "L";
				_ascii[77] = "M";
				_ascii[78] = "N";
				_ascii[79] = "O";
				_ascii[80] = "P";
				_ascii[81] = "Q";
				_ascii[82] = "R";
				_ascii[83] = "S";
				_ascii[84] = "T";
				_ascii[85] = "U";
				_ascii[86] = "V";
				_ascii[87] = "W";
				_ascii[88] = "X";
				_ascii[89] = "Y";
				_ascii[90] = "Z";
				_ascii[48] = "0";
				_ascii[49] = "1";
				_ascii[50] = "2";
				_ascii[51] = "3";
				_ascii[52] = "4";
				_ascii[53] = "5";
				_ascii[54] = "6";
				_ascii[55] = "7";
				_ascii[56] = "8";
				_ascii[57] = "9";
				_ascii[32] = "Space";
				_ascii[13] = "Enter";
				_ascii[17] = "Ctrl";
				_ascii[16] = "Shift";
				_ascii[192] = "~";
				_ascii[38] = "Up";
				_ascii[40] = "Down";
				_ascii[37] = "Left";
				_ascii[39] = "Right";
				_ascii[96] = "Numpad 0";
				_ascii[97] = "Numpad 1";
				_ascii[98] = "Numpad 2";
				_ascii[99] = "Numpad 3";
				_ascii[100] = "Numpad 4";
				_ascii[101] = "Numpad 5";
				_ascii[102] = "Numpad 6";
				_ascii[103] = "Numpad 7";
				_ascii[104] = "Numpad 8";
				_ascii[105] = "Numpad 9";
				_ascii[111] = "Numpad /";
				_ascii[106] = "Numpad *";
				_ascii[109] = "Numpad -";
				_ascii[107] = "Numpad +";
				_ascii[110] = "Numpad .";
				_ascii[45] = "Insert";
				_ascii[46] = "Delete";
				_ascii[33] = "Page Up";
				_ascii[34] = "Page Down";
				_ascii[35] = "End";
				_ascii[36] = "Home";
				_ascii[112] = "F1";
				_ascii[113] = "F2";
				_ascii[114] = "F3";
				_ascii[115] = "F4";
				_ascii[116] = "F5";
				_ascii[117] = "F6";
				_ascii[118] = "F7";
				_ascii[119] = "F8";
				_ascii[188] = ",";
				_ascii[190] = ".";
				_ascii[186] = ";";
				_ascii[222] = "'";
				_ascii[219] = "[";
				_ascii[221] = "]";
				_ascii[189] = "-";
				_ascii[187] = "+";
				_ascii[220] = "\\";
				_ascii[191] = "/";
				_ascii[9] = "TAB";
				_ascii[8] = "Backspace";
				_ascii[27] = "ESC";
			}
			
			
			/**
			 * KEY LISTENERS
			 */
			private function _keyPressed( e:KeyboardEvent ):void
			{
				// last key (for key config)
				lastKeyCode = e.keyCode;
				lastKeyName = _ascii[ lastKeyCode ];
				
				// set key state
				_keyState[ lastKeyCode ] = FastMath.max( _keyState[lastKeyCode], 1 );
				
				if ( _keyState[lastKeyCode] == 1 )
					_timeKeyPressed = getTimer();
			}
			
			private function _keyReleased( e:KeyboardEvent ):void
			{
				var keyCode:uint = e.keyCode;
				
				_keyState[ keyCode ] = -1;
				
				// add key to buffer
				for ( var i:int = bufferSize-1; i > 0; i-- )
					_keyBuffer[i] = _keyBuffer[i - 1];
				_keyBuffer[0] = [keyCode, 0];
				_timeKeyReleased = getTimer();
			}
			
			
			/**
			 * MOUSE LISTENERS
			 */
			private function _mousePressed( e:MouseEvent ):void
			{
				isMouseDown = true;
				isMousePressed = true;
				_timeMousePressed = getTimer();
			}
			
			private function _mouseReleased( e:MouseEvent ):void
			{
				isMouseDown = false;
				isMouseReleased = true;
				_timeMouseReleased = getTimer();
			}
			
			private function _mouseMoved( e:MouseEvent ):void
			{
				mouseX = e.stageX - _stage.x;
				mouseY = e.stageY - _stage.y;
			}
			
			private function _mouseScrolled( e:MouseEvent ):void
			{
				mouseWheelDelta = e.delta;
			}
			
			
			/**
			 * FOCUS LISTENERS
			 */
			private function _stageActivate( e:Event ):void
			{
				isFocused = true;
			}
			
			private function _stageDeactivate( e:Event ):void
			{
				isFocused = false;
				isFocusLost = true;
				
				// force pressed keys to be released
				for each( var k:int in _keyArr )
					if ( _keyState[k] > 0 )
						_keyState[k] = -1;
			}
			
			
		
		public static function get instance():UserInput
		{
			if ( _instance == null ) {
				_allow = true;
				_instance = new UserInput;
				_allow = false;
			}
			
			return _instance;
		}
		
			private static var _instance:UserInput;
			private static var _allow:Boolean = false;
		
	}

}