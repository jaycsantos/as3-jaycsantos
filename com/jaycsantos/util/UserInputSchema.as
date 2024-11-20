package com.jaycsantos.util 
{
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author ...
	 */
	public class UserInputSchema 
	{
		public var onKeyBind:Signal;
		public var onKeyUnbind:Signal;
		
		
		public function UserInputSchema( schema:Object )
		{
			onKeyBind = new Signal( String, uint );
			onKeyUnbind = new Signal( String, uint );
			
			_schemaMap = new Dictionary();
			for ( var k:String in schema )
				_schemaMap[ k ] = int( schema[k] );
		}
		
		
		public function bind( scheme:String, keyCode:uint ):void
		{
			if ( _schemaMap[scheme] != undefined ) {
				_schemaMap[ scheme ] = keyCode;
				onKeyBind.dispatch( scheme, keyCode );
			}
		}
		
		public function unbind( scheme:String, keyCode:uint ):void
		{
			if ( _schemaMap[scheme] != undefined ) {
				_schemaMap[ scheme ] = 0;
				onKeyUnbind.dispatch( scheme, keyCode );
			}
		}
		
		
		public function getKeyCode( scheme:String ):uint
		{
			if ( _schemaMap[scheme] != undefined )
				return _schemaMap[ scheme ];
			
			return 0;
		}
		
		public function getKeyString( scheme:String ):String
		{
			if ( _schemaMap[scheme] != undefined )
				return UserInput.instance.getKeyString( _schemaMap[scheme] );
			
			return null;
		}
		
		
			// -- private --
			
			protected var _schemaMap:Dictionary;
			
			
	}

}