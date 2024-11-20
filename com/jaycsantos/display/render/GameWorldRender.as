package com.jaycsantos.display.render 
{
	import com.jaycsantos.game.GameRoot;
	import com.jaycsantos.entity.Entity;
	import com.jaycsantos.entity.EntityArgs;
	import com.jaycsantos.entity.GameCamera;
	import com.jaycsantos.entity.GameWorld;
	import com.jaycsantos.internalJayc;
	import com.jaycsantos.math.AABB;
	import com.jaycsantos.util.ds.LinkEntity;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class GameWorldRender implements IRenderLayer
	{
		
		public function GameWorldRender( world:GameWorld, renderSurface:DisplayObjectContainer )
		{
			_world = world;
			_world.wrender = this;
			_layers = new Vector.<IRenderLayer>();
			
			_buffer = new Sprite();
			_buffer.name = "GameWorldRender";
			_buffer.mouseEnabled = false;
			_buffer.mouseChildren = true;
			//CONFIG::release {
				_buffer.scrollRect = new Rectangle( 0, 0, world.camera.bounds.width, world.camera.bounds.height );
			//}
			renderSurface.addChildAt( _buffer, 0 );			
		}
		
		public function dispose():void 
		{
			for each( var layer:IRenderLayer in _layers )
				layer.dispose();
			
			_layers.splice( 0, _layers.length );
			
			if ( _buffer.parent )
				_buffer.parent.removeChild( _buffer );
			
			var i:int = _buffer.numChildren;
			while ( i-- ) _buffer.removeChildAt( i );
		}
		
		
		public function update():void 
		{
			for each( var layer:IRenderLayer in _layers )
				layer.update();
		}
		
		
		public function addLayer():void
		{
			var layer:RenderLayer = new RenderLayer( _layers.length );
			
			_buffer.addChild( layer );
			_layers.push( layer );
		}
		
		public function addBitmapLayer():void
		{
			var layer:BitmapLayer = new BitmapLayer( _layers.length, this, _world.camera.bounds.width, _world.camera.bounds.height );
			
			_buffer.addChild( layer );
			_layers.push( layer );
		}
		
		
		public function addRender( render:AbstractRender ):AbstractRender
		{
			return getLayer( render.layer ).addRender( render );
		}
		
		public function removeRender( render:AbstractRender ):AbstractRender
		{
			return getLayer( render.layer ).removeRender( render );
		}
		
		
		public function snapShot( watermark:DisplayObject=null ):BitmapData
		{
			var cam:AABB = _world.camera.bounds;
			// loop through all renders
			var e:LinkEntity = _world.entities;
			while ( e ) {
				if ( e.entity.render )// && !e.entity.render.isRendered )
					e.entity.render.internalJayc::forceShow();
				e = e.next;
			}
			
			_buffer.scrollRect = null;
			
			var m:Matrix = new Matrix;
			m.tx = cam.min.x;
			m.ty = cam.min.y;
			var bmpData:BitmapData = new BitmapData( _world.bounds.width, _world.bounds.height, false, 0xff191919 );
			
			if ( watermark )
				_buffer.addChild( watermark );
			
			bmpData.draw( _buffer, m );
			
			if ( watermark )
				_buffer.removeChild( watermark );
			_buffer.scrollRect = new Rectangle( 0, 0, cam.width, cam.height );
			
			return bmpData;
		}
		
		public function get canvas():DisplayObjectContainer
		{
			return _buffer.parent;
		}
		
			// -- private --
			
			protected var _buffer:Sprite
			protected var _layers:Vector.<IRenderLayer>
			protected var _world:GameWorld
			
			
			internal function getLayer( value:uint ):IRenderLayer
			{
				if ( value >= _layers.length ) {
					throw new Error("[com.jaycsantos.display.render.GameWorldRender::_getLayer] Layer value is invalid");
					return null;
					//return _layers[ _layers.length - 1 ] as IRenderLayer;
				}
				
				return _layers[ value ] as IRenderLayer;
			}
			
			
	}

}