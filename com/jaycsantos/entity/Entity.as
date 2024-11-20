package com.jaycsantos.entity
{
	import com.jaycsantos.display.render.AbstractRender;
	import com.jaycsantos.game.IGameObject;
	import com.jaycsantos.math.Vector2D;
	import com.jaycsantos.util.Flags;
	import flash.utils.getQualifiedClassName;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class Entity implements IGameObject
	{
		// public variables
		public var type:String
		public var p:Vector2D
		public var onDispose:Signal = new Signal( Entity )
		public var depth:int
		public var world:GameWorld
		public var render:AbstractRender
		
		// getters/setters
			public function get id():String
			{
				return _id;
			}
			
		
		public function Entity( args:EntityArgs = null )
		{
			type = args ? args.type : 'entity';
			p = args ? new Vector2D( args.px, args.py ) : new Vector2D;
			_id = (args && args.id ? args.id : type) +'_' + nextID;
			depth = args? args.depth: 0;
			_flag = new Flags;
		}
		
		public function dispose():void
		{
			_flag.setTrue( EntityFlag.ISDISPOSED );
			onDispose.dispatch( this );
			
			onDispose.removeAll();
			onDispose = null;
			
			render = null;
		}
		
		
		public function update():void
		{
			
		}
		
		public function toString():String
		{
			return "#" + _id //+"_"+ getQualifiedClassName( this );
		}
		
		
		public function isDisposed():Boolean
		{
			return _flag.isTrue( EntityFlag.ISDISPOSED );
		}
		
		
			// -- private --
			
			private static var _nextId:uint = 0
			
			protected var _id:String, _flag:Flags
			
			
			protected static function get nextID():uint
			{
				return _nextId++;
			}
			
		
	}

}