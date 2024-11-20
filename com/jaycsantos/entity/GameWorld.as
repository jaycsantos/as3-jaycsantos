package com.jaycsantos.entity 
{
	import com.jaycsantos.display.render.GameWorldRender;
	import com.jaycsantos.game.ICollisionCheck;
	import com.jaycsantos.game.IGameSession;
	import com.jaycsantos.math.AABB;
	import com.jaycsantos.math.Vector2D;
	import com.jaycsantos.util.ds.LinkEntity;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class GameWorld extends Entity
	{
		
		public var camera:GameCamera
		public var bounds:AABB
		public var wrender:GameWorldRender
		public var collisionCheck:ICollisionCheck
		
		
		// signals
		public var signalResize:Signal
		
		
		public function GameWorld( width:uint, height:uint, cameraWidth:uint = 0, cameraHeight:uint = 0 )
		{
			_id = "world";
			
			// center game world
			p.Set( width / 2, height / 2 );
			
			bounds = new AABB( p, width, height );
			signalResize = new Signal( uint, uint );
			signalResize.add( bounds.resize );
			
			_head = _tail = new LinkEntity;
			_postDisposeList = new Vector.<Entity>;
			
			if ( cameraWidth && cameraHeight )
				_createCamera( cameraWidth, cameraHeight );
		}
		
		override public function dispose():void
		{
			// dispose of children
			var e:LinkEntity = _head.next;
			while ( e ) {
				e.entity.dispose();
				e.entity = null;
				e = e.next;
			}
			_tail = _head = null;
			
			super.dispose();
			
			wrender.dispose();
			wrender = null;
			
			camera.dispose();
			camera = null;
			
			bounds = null;
			
			signalResize.removeAll();
			signalResize = null;
		}
		
		
		override public function update():void 
		{
			CONFIG::debug {
				var t:int = getTimer();
			}
			
			camera.update();
			
			// update children
			var e:LinkEntity = _head.next;
			while ( e ) {
				if ( _postDisposeList.indexOf(e.entity) == -1 ) 
					e.entity.update();
				e = e.next;
			}
			
			if ( collisionCheck != null )
				collisionCheck.update( _head.next );
			
			// remove those marked for disposal
			var i:int = _postDisposeList.length;
			while ( i-- )
				_postDisposeList[i].dispose();
			_postDisposeList.splice( 0, _postDisposeList.length );
			
			CONFIG::debug {
				DOutput.show('entities: ' + (getTimer() - t) +'ms'); t = getTimer();
			}
			
			wrender.update();
			
			CONFIG::debug {
				DOutput.show('renderers: ' + (getTimer() - t) +'ms');
			}
			
		}
		
		
		public function resize( w:uint, h:uint ):void
		{
			signalResize.dispatch( w, h );
		}
		
		
		public function addEntity( entity:Entity ):void
		{
			//var node:LinkEntity = _findLinkEntityBefore( entity );
			//if ( node ) return;
			if ( entity.world ) return;
			
			_tail = _tail.next = new LinkEntity;
			_tail.entity = entity;
			
			entity.world = this;
			entity.onDispose.addOnce( removeEntity );
			if ( entity.render )
				wrender.addRender( entity.render );
		}
		
		public function removeEntity( entity:Entity ):void
		{
			var a:LinkEntity = _findLinkEntityBefore( entity ), b:LinkEntity;
			if ( ! a ) return;
			
			b = a.next;
			a.next = b.next;
			if ( b == _tail )
				_tail = a;
			
			b.next = null;
			b.entity = null;
			
			entity.world = null;
			entity.onDispose.remove( removeEntity );
			if ( entity.render )
				wrender.removeRender( entity.render );
		}
		
		public function disposeEntity( entity:Entity ):void
		{
			_postDisposeList.push( entity );
		}
		
		
		public function get entities():LinkEntity
		{
			return _head.next;
		}
		
		
			// -- private --
			
			protected var _head:LinkEntity
			protected var _tail:LinkEntity
			
			protected var _postDisposeList:Vector.<Entity>
			
			
			protected function _createCamera( cameraWidth:uint, cameraHeight:uint ):void
			{
				camera = new GameCamera( this, cameraWidth, cameraHeight );
			}
			
			/**
			 * searches for nodeA the where nodeA.next == nodeB and nodeB.entity == entity
			 * @param	entity
			 * @return node
			 */
			private function _findLinkEntityBefore( entity:Entity ):LinkEntity
			{
				var r:LinkEntity = _head;
				while ( r && r.next ) {
					if ( r.next.entity == entity )
						return r;
					r = r.next;
				}
				return null;
			}
			
	}

}
