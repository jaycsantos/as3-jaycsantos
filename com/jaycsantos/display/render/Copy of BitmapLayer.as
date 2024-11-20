package com.jaycsantos.display.render
{
	import com.jaycsantos.entity.GameWorld;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	internal class BitmapLayer extends Bitmap implements IRenderLayer
	{
		
		public function BitmapLayer( layer:uint, wRender:GameWorldRender, width:uint, height:uint )
		{
			if ( layer > 0 && wRender.getLayer(layer - 1) is BitmapLayer ) {
				bitmapData = (wRender.getLayer(layer - 1) as BitmapLayer).bitmapData;
				_isUsingLowerBmp = true;
				
			} else {
				bitmapData = new BitmapData( width, height, true, 0 );
				_isUsingLowerBmp = false;
			}
			
			_layer = layer;
			_cache_point = new Point;
			_head = _tail = new RenderNode;
			
			name = "layer_" + layer +"_bmp";
		}
		
		public function dispose():void
		{
			if ( ! _isUsingLowerBmp )
				bitmapData.dispose();
			
			var r:RenderNode = _head.next;
			while ( r ) {
				r.render = null;
				r = r.next;
			}
			_tail = _head = null;
		}
		
		
		public function update():void
		{
			bitmapData.lock();
			
			if ( ! _isUsingLowerBmp )
				bitmapData.fillRect( bitmapData.rect, 0 );
			
			var bmp:Bitmap, r:RenderNode = _head.next, t:int;
			while ( r ) {
				r.render.update();
				if ( r.render.isRendered ) {
					bmp = Bitmap(r.render.buffer);
					_cache_point.x = bmp.x;
					_cache_point.y = bmp.y;
					
					t = getTimer();
					bitmapData.copyPixels( bmp.bitmapData, bmp.bitmapData.rect, _cache_point, null, null, AbstractBmpRender(r.render).hasAlphaChannel );
					DOutput.show( 'bmp render:', (getTimer() -t) +'ms' );
				}
				r = r.next;
			}
			
			bitmapData.unlock();
		}
		
		
		public function addRender( render:AbstractRender ):AbstractRender
		{
			if ( ! render is AbstractBmpRender )
				throw new Error("[com.jaycsantos.display.render.BitmapLayer::addRender] render must be a BitmapRender instance");
			
			
			var r:RenderNode = _findRenderBefore( render );
			if ( r || ! render ) return render;
			
			_tail = _tail.next = new RenderNode;
			_tail.render = render as AbstractBmpRender;
			
			return render;
		}
		
		public function removeRender( render:AbstractRender ):AbstractRender
		{
			if ( ! render is AbstractBmpRender )
				throw new Error("[com.jaycsantos.display.render.BitmapLayer::addRender] render must be a BitmapRender instance");
			
			var r:RenderNode = _findRenderBefore( render ), n:RenderNode;
			if ( r ) {
				n = r.next;
				r.next = n.next;
				if ( n == _tail )
					_tail = r;
				
				n.next = null;
				n.render = null;
			}
			return render;
		}
		
		
			// -- private --
			
			protected var _layer:uint
			protected var _isUsingLowerBmp:Boolean
			protected var _cache_point:Point
			
			private var _head:RenderNode
			private var _tail:RenderNode
			
			
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

import com.jaycsantos.display.render.AbstractBmpRender;

internal class RenderNode
{
	public var next:RenderNode
	public var render:AbstractBmpRender
}