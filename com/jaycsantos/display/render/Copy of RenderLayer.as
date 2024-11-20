package com.jaycsantos.display.render
{
	import com.jaycsantos.entity.GameWorld;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	internal class RenderLayer extends Sprite implements IRenderLayer
	{
		
		public function RenderLayer( layer:uint )
		{
			_layer = layer;
			_head = _tail = new RenderNode
			//_rendersToAdd = new Vector.<AbstractRender>();
			
			mouseEnabled = false;
			mouseChildren = true;
			tabEnabled = false;
			tabChildren = true;
			
			name = "layer_" + layer;
			_mustSort = new Vector.<RenderNode>();
		}
		
		public function dispose():void
		{
			var r:RenderNode = _head.next;
			while ( r ) {
				removeChild( r.render.buffer );
				r.render = null;
				r = r.next;
			}
			_tail = _head = null;
			_mustSort.splice( 0, _mustSort.length );
		}
		
		
		public function update():void
		{
			var r:RenderNode = _head.next;
			while ( r ) {
				r.render.update();
				if ( r.render.sortMe ) {
					_mustSort.push( r );
					r.render.sortMe = false;
				}
				r = r.next;
			}
		}
		
		
		public function addRender( render:AbstractRender ):AbstractRender
		{
			var r:RenderNode = _findRenderBefore( render );
			if ( r || ! render ) return render;
			
			_tail = _tail.next = new RenderNode;
			_tail.render = render;
			
			addChild( render.buffer );
			return render;
		}
		
		public function removeRender( render:AbstractRender ):AbstractRender
		{
			var r:RenderNode = _findRenderBefore( render ), n:RenderNode;
			if ( r ) {
				n = r.next;
				r.next = n.next;
				if ( n == _tail )
					_tail = r;
				
				n.next = null;
				n.render = null;
				
				removeChild( render.buffer );
			}
			return render;
		}
		
		
			// -- private --
			
			protected var _layer:uint
			
			protected var _head:RenderNode
			protected var _tail:RenderNode
			
			protected var _mustSort:Vector.<RenderNode>
			
			/**
			 * searches for nodeA the where nodeA.next == nodeB and nodeB.render == render
			 * @param	render
			 * @return node
			 */
			private function _findRenderBefore( render:AbstractRender ):RenderNode
			{
				var r:RenderNode = _head;
				while ( r && r.next ) {
					if ( r.next.render == render )
						return r;
					r = r.next;
				}
				return null;
			}
			
			
	}

}

import com.jaycsantos.display.render.AbstractRender;

internal class RenderNode
{
	public var next:RenderNode
	public var render:AbstractRender
}