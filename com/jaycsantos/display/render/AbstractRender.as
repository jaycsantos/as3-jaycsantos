package com.jaycsantos.display.render 
{	
	import com.jaycsantos.entity.Entity;
	import com.jaycsantos.entity.EntityArgs;
	import com.jaycsantos.game.GameRoot;
	import com.jaycsantos.game.IGameObject;
	import com.jaycsantos.internalJayc;
	import com.jaycsantos.math.AABB;
	import com.jaycsantos.math.Vector2D;
	import com.jaycsantos.util.DisplayKit;
	import com.jaycsantos.util.Flags;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class AbstractRender implements IGameObject
	{
		public static const STATE_ISOFFSCREEN:uint = 1 << 0;
		public static const STATE_ISVISIBLE:uint = 1 << 1;
		public static const STATE_MUSTREDRAW:uint = 1 << 2;
		public static const STATE_MUSTSORT:uint = 1 << 3;
		
		public var layer:uint
		public var buffer:DisplayObject = new Sprite
		public var depth:int
		public var bounds:AABB
		
		public function AbstractRender( entity:Entity, args:EntityArgs = null )
		{
			_entity = entity;
			_entity.render = this;
			
			layer = args.layer;
			//buffer.blendMode = BlendMode.LAYER;
			buffer.name = args.type + _entity.id + "_Render";
			buffer.visible = false; // defaultly hidden
			bounds = new AABB( new Vector2D, 0, 0 );
			depth = _entity.depth;
			_flags = new Flags( STATE_ISOFFSCREEN | STATE_ISVISIBLE | STATE_MUSTREDRAW );
			
			// listend so that when the entity is disposed off
			_entity.onDispose.addOnce( _entityDisposed );
			
			with ( Sprite(buffer) )
				mouseEnabled = mouseChildren = tabEnabled = tabChildren = false;
		}
		
		public function dispose():void
		{
			// don't null buffer, used on remove render
			
			_entity = null;
			
			if ( buffer is DisplayObjectContainer )
				DisplayKit.removeAllChildren( buffer as DisplayObjectContainer, 4 );
		}
		
		
		public function update():void
		{
			_review();
			_cull();
			
			if ( buffer.visible ) {
				if ( _flags.isTrue(STATE_MUSTREDRAW) )
					_draw();
				_reposition();
				_flags.setFalse( STATE_MUSTREDRAW );
			}
			if ( depth != _entity.depth )
				_flags.setTrue( STATE_MUSTSORT );
			depth = _entity.depth;
		}
		
		
		final public function get sortMe():Boolean
		{
			return _flags.isTrue( STATE_MUSTSORT );
		}
		
			internalJayc function sorted():void
			{
				_flags.setFalse( STATE_MUSTSORT );
			}
		
		
		final public function get isOffScreen():Boolean
		{
			return _flags.isTrue( STATE_ISOFFSCREEN );
		}
		
		final public function get isRendered():Boolean
		{
			return buffer.visible;
		}
		
		final public function get isVisible():Boolean
		{
			return _flags.isTrue( STATE_ISVISIBLE );
		}
		
		
		public function setVisible( value:Boolean ):void
		{
			_flags.setFlag( STATE_ISVISIBLE, buffer.visible = value );
		}
		
		
		public function redraw():void
		{
			_flags.setTrue( STATE_MUSTREDRAW );
		}
		
		public function cancelRedraw():void
		{
			_flags.setFalse( STATE_MUSTREDRAW );
		}
		
		
		internalJayc function forceShow():void
		{
			buffer.visible = true;
			_reposition();
			_onForcedShow();
		}
		
			// -- private --
			
			protected var _entity:Entity, _flags:Flags
			protected var _boundOffX:int, _boundOffY:int
			
			
			protected function _draw():void
			{
				throw new Error( "[com.jaycsantos.display.render.AbstractRender] override abstract method _draw()" );
			}
			
			protected function _review():void
			{
				bounds.moveTo( _entity.p.x +_boundOffX, _entity.p.y +_boundOffY );
			}
			
			protected function _cull():void
			{
				// hide if bounding box is outside of camera view
				if ( !_entity.world.camera.bounds.isColliding(bounds) ) {
					_flags.setTrue( STATE_ISOFFSCREEN );
					buffer.visible = false;
				} else {
					_flags.setFalse( STATE_ISOFFSCREEN )
					buffer.visible = _flags.isTrue( STATE_ISVISIBLE );
				}
			}
			
			protected function _reposition():void
			{
				var camera:AABB = _entity.world.camera.bounds;
				buffer.x = (_entity.p.x - camera.min.x);
				buffer.y = (_entity.p.y - camera.min.y);
			}
			
			final private function _entityDisposed( entity:Entity ):void
			{
				dispose();
			}
			
			protected function _onForcedShow():void
			{
				
			}
			
	}

}