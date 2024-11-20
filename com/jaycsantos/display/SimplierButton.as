package com.jaycsantos.display 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class SimplierButton extends SimpleButton 
	{
		//public var onClick:NativeSignal, onDblClick:NativeSignal, onMove:NativeSignal, onOver:NativeSignal, onOut:NativeSignal, onDown:NativeSignal, onUp:NativeSignal
		
		
		public function SimplierButton( upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, disableState:DisplayObject=null, lockState:DisplayObject=null, hitTestState:DisplayObject=null )
		{
			super( upState, overState, downState, hitTestState );
			
			_disableState = disableState;
			_lockState = lockState;
			
			/*onClick = new NativeSignal( this, MouseEvent.CLICK, MouseEvent );
			onDblClick = new NativeSignal( this, MouseEvent.DOUBLE_CLICK, MouseEvent );
			onMove = new NativeSignal( this, MouseEvent.MOUSE_MOVE, MouseEvent );
			onOver = new NativeSignal( this, MouseEvent.MOUSE_OVER, MouseEvent );
			onOut = new NativeSignal( this, MouseEvent.MOUSE_OUT, MouseEvent );
			onDown = new NativeSignal( this, MouseEvent.MOUSE_DOWN, MouseEvent );
			onUp = new NativeSignal( this, MouseEvent.MOUSE_UP, MouseEvent );*/
		}
		
		public function dispose():void
		{
			/*onClick.removeAll(); onClick = null;
			onDblClick.removeAll(); onDblClick = null;
			onMove.removeAll(); onMove = null;
			onOver.removeAll(); onOver = null;
			onOut.removeAll(); onOut = null;
			onDown.removeAll(); onDown = null;
			onUp.removeAll(); onUp = null;*/
		}
		
		
		override public function get upState():DisplayObject
		{
			return _default;
		}
		
		override public function set upState( value:DisplayObject ):void 
		{
			_default = value;
			if ( !enabled && _disableState )
				super.upState = _disableState;
			else
				super.upState = _default;
		}
		
		
		public function get disableState():DisplayObject
		{
			return _disableState;
		}
		
		public function set disableState( value:DisplayObject ):void
		{
			_disableState = value;
			enabled = super.enabled;
		}
		
		public function get lockState():DisplayObject
		{
			return _lockState;
		}
		
		public function set lockState( value:DisplayObject ):void
		{
			_lockState = value;
			locked = _locked;
		}
		
		
		override public function set enabled( value:Boolean ):void 
		{
			tabEnabled = mouseEnabled = super.enabled = !_locked && value;
			
			if ( _locked )
				super.upState = _lockState;
			else if ( !value )
				super.upState = _disableState;
			else
				super.upState = _default;
			
		}
		
		
		public function get locked():Boolean
		{
			return _locked;
		}
		
		public function set locked( value:Boolean ):void
		{
			_locked = value;
			enabled = !value;
		}
		
		
		
		
			// -- private --
			
			private var _default:DisplayObject, _disableState:DisplayObject, _lockState:DisplayObject, _locked:Boolean = false;
			
	}

}