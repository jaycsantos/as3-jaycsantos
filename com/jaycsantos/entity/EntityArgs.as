package com.jaycsantos.entity 
{
	import com.jaycsantos.IDisposable;
	import com.jaycsantos.math.Vector2D;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class EntityArgs implements IDisposable
	{
		
		public var id:String
		public var layer:uint = 0
		public var px:Number = 0
		public var py:Number = 0
		
		public var customClass:Class = Entity
		public var renderClass:Class = null
		public var data:Object = { }
		public var dimension:Point = new Point(0,0)
		public var depth:int = 0xff
		
		public var type:String
		
		public function EntityArgs( args:Object = null )
		{
			_argue( args );
		}
		
		/* INTERFACE com.jaycsantos.game.IGameSession */
		
		public function dispose():void
		{
			for ( var k:String in this ) {
				if ( this[k] is IDisposable )
					IDisposable( this[k] ).dispose();
				
				this[k] = null;
			}	
		}
		
		
			// -- private --
			
			protected function _argue( args:Object = null ):void
			{
				if ( args )
					for ( var k:String in args ) {
						if ( hasOwnProperty(k) )
							this[ k ] = args[ k ];
						else
							throw new Error( "[com.jaycsantos.object.EntityArgs] '" + k +"' is not a valid argument" );
					}
			}
	}

}