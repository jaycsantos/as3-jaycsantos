package com.jaycsantos.game 
{
	import com.jaycsantos.display.render.GameWorldRender;
	import com.jaycsantos.entity.*;
	import com.jaycsantos.IDisposable;
	import com.jaycsantos.math.Vector2D;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class GameFactory
	{
		public static const instance:GameFactory = new GameFactory
		public const onSpawn:Signal = new Signal( Entity )
		
		public function GameFactory()
		{
			if ( instance ) throw new Error("[com.jaycsantos.game.GameFactory] Singleton class, use static property instance");
			
			_entityArgsMap = new Dictionary;
			_globalForcesMap = new Dictionary;
		}
		
		public function clean():void
		{
			resignWorld();
			
			for ( var k:String in _entityArgsMap ) {
				IDisposable( _entityArgsMap ).dispose();
				delete _entityArgsMap[k];
			}
			for ( k in _globalForcesMap ) {
				IDisposable( _entityArgsMap ).dispose();
				delete _globalForcesMap[k];
			}
		}
		
		
		public function registerWorld( world:GameWorld, render:GameWorldRender ):GameWorld
		{
			_world = world;
			_worldRender = render;
			
			return _world;
		}
		
		public function resignWorld():void
		{
			_world = null;
			_worldRender = null;
		}
		
		
		public function registerEntityType( args:EntityArgs ):void
		{
			if ( ! args.type ) throw new Error( "[com.jaycsantos.GameFactory.registerEntityType()] must declare entity args type" );
			if ( ! args.customClass ) throw new Error( "[com.jaycsantos.GameFactory.registerEntityType()] must declare entity args customClass for '" + args.type +"' entity type" );
			
			_entityArgsMap[ args.type ] = args;
		}
		
		public function getEntityArguments( type:String ):EntityArgs
		{
			if ( ! _entityArgsMap[type] ) return null;
			
			return _entityArgsMap[type] as EntityArgs;
		}
		
		public function spawnEntity( type:String, addToWorld:Boolean = true ):Entity
		{
			if ( ! _world ) throw new Error("[com.jaycsantos.GameFactory::spawnEntity] no game world was registered, cannot spawn without a registered world");
			
			var args:EntityArgs;
			var entity:Entity;
			
			args = _entityArgsMap[ type ];
			if ( ! args ) throw new Error( "[com.jaycsantos.GameFactory::spawnEntity] '" + type + "' is not a registered entity type" );
			
			entity = new args.customClass( args );
			
			if ( entity is MovableEntity ) {
				var mEn:MovableEntity = MovableEntity( entity );
				for each( var obj:Object in _globalForcesMap )
					if ( obj is Vector2D ) {
						var force:Vector2D = obj as Vector2D;
						mEn.addConstantForce( force, _globalForcesMap[force.toString()] );
					}
			}
			
			if ( args.renderClass )
				entity.render = new args.renderClass( entity, args );
			
			if ( addToWorld )
				_world.addEntity( entity );
			
			onSpawn.dispatch( entity );
			return entity;
		}
		
		
		
		public function addGlobalForce( force:Vector2D, name:String ):void
		{
			_globalForcesMap[ name ] = force;
			_globalForcesMap[ force.toString() ] = name;
		}
		
		public function removeGlobalForce( name:String ):void
		{
			if ( ! _globalForcesMap[name] ) return;
			
			var force:Vector2D = _globalForcesMap[ name ];
			delete _globalForcesMap[ force.toString() ];
			delete _globalForcesMap[ name ];
		}
		
		
			// -- private --
			
			protected var _entityArgsMap:Dictionary;
			protected var _globalForcesMap:Dictionary;
			
			protected var _world:GameWorld;
			protected var _worldRender:GameWorldRender;
		
		
	}

}