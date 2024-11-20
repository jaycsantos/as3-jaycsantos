package com.jaycsantos.display.screen 
{
	import com.jaycsantos.IDisposable;
	import com.jaycsantos.math.MathUtils;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class DialogBox implements IDisposable 
	{
		public static const OK:uint = 0
		public static const OKCANCEL:uint = 1
		public static const INPUT:uint = 2
		public static const YESNO:uint = 3
		
		public static function create( dtype:uint = 0, text:String = "Unknown", callback1:Function = null, callback2:Function = null, cover:uint = Number.NaN, data:Object = null ):DialogBox
		{
			return new DialogBox( dtype, text, callback1, callback2, cover, data );
		}
		
		
		
		public var buffer:DisplayObject;
		
		
		public function DialogBox( dtype:uint = 0, text:String = "Unknown", callback1:Function = null, callback2:Function = null, cover:uint = Number.NaN, data:Object = null ) 
		{
			buffer = new Sprite();
			
			if ( ! isNaN(cover) ) {
				_cover = new Sprite;
				Sprite(buffer).addChild( _cover );
			}
			
			switch( dtype ) {
				case OK:
					break;
				case OKCANCEL:
					break;
				case INPUT:
					break;
				case YESNO:
					break;
				default: break;
			}
			
			buffer.addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		public function init( e:Event ):void
		{
			if ( _cover !== undefined ) {
				var g:Graphics = _cover.graphics;
				g.beginFill( MathUtils.argbToRGB(_coverColor), MathUtils.argbToAlpha(_coverColor) );
				g.drawRect( 0, 0, buffer.stage.width, buffer.stage.height );
				g.endFill();
			}
			
			
			
		}
		
		/* INTERFACE com.jaycsantos.IDisposable */
		
		public function dispose():void 
		{
			
		}
		
		
			// -- private --
			
			protected var _cover:Sprite;
			protected var _coverColor:uint;
			
			protected var _dialog:Sprite;
			protected var _button:Sprite;
		
	}

}