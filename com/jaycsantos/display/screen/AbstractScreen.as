package com.jaycsantos.display.screen 
{
	import avmplus.getQualifiedClassName;
	import com.jaycsantos.game.GameRoot;
	import com.jaycsantos.game.IGameObject;
	import com.jaycsantos.util.DisplayKit;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class AbstractScreen implements IGameObject
	{
		public static const f_IDLE:uint = 0
		public static const f_ENTERING:uint = 2
		public static const f_EXITING:uint = 4
		public static const f_UPDATING:uint = 1
		public static const f_GONE:uint = 8
		
		
		// getter/setter
		public function get root():GameRoot
		{
			return _root;
		}
		
		public function get isReady():Boolean
		{
			return nAbstractScreen::_state == f_UPDATING;
		}
		
		
		public function AbstractScreen( root:GameRoot, data:Object = null )
		{
			_root = root;
			root.addChild( _canvas );
			
			_canvas.visible = _canvas.mouseEnabled = _canvas.tabEnabled = false;
			_canvas.name = getQualifiedClassName(this);
		}
		
		public function dispose():void
		{
			_root.removeChild( _canvas );
			DisplayKit.removeAllChildren( _canvas, 1 );
			_root = null; _canvas = null;
		}
		
		
		public function update():void
		{
			
		}
		
		
		public function changeScreen( screenClass:Class, data:Object = null ):void
		{
			_root.changeScreen( screenClass, data );
		}
		
		
			// -- private --
			
			protected var _root:GameRoot
			protected var _canvas:Sprite = new Sprite
			
			protected function _forceEnter():void
			{
				nAbstractScreen::n_enter();
			}
			
			protected function _onPreEnter():Boolean
			{
				return true;
			}
			
			protected function _onPreExit():void
			{
				
			}
			
			protected function _doWhileEntering():Boolean
			{
				_canvas.visible = true;
				return false;
			}
			
			protected function _doWhileExiting():Boolean
			{
				return false;
			}
			
			
			nAbstractScreen var _state:uint = f_IDLE
			
			nAbstractScreen function n_enter():void
			{
				use namespace nAbstractScreen;
				if ( _state == f_IDLE && _onPreEnter() )
					_state = f_ENTERING;
			}
			
			nAbstractScreen function n_exit():void
			{
				use namespace nAbstractScreen;
				if ( _state == f_UPDATING ) {
					_state = f_EXITING;
					_onPreExit();
				}
			}
			
			nAbstractScreen function n_update():void
			{
				use namespace nAbstractScreen;
				
				if ( _state == f_UPDATING ) {
					update();
				} else
				if ( _state == f_EXITING ) {
					if ( !_doWhileExiting() )
						_state = f_GONE;
				} else
				if ( _state == f_ENTERING ) {
					if ( !_doWhileEntering() )
						_state = f_UPDATING;
				}
				
			}
			
			
	}

}