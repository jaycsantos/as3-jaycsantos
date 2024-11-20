package com.jaycsantos.display.render
{
	import com.jaycsantos.entity.GameWorld;
	import com.jaycsantos.internalJayc;
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
		use namespace internalJayc
		
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
			
			name = "layer_" + layer +"_bmp";
		}
		
		public function dispose():void
		{
			if ( ! _isUsingLowerBmp )
				bitmapData.dispose();
			
			_renders.splice( 0, _renders.length );
		}
		
		
		public function update():void
		{
			var r:AbstractBmpRender;
			for each( r in _renders ) {
				r.update();
				if ( r.sortMe ) {
					r.sorted();
					_sort = true;
				}
			}
			if ( _sort ) {
				_renders.sort( _compare );
				_sort = false;
			}
			
			bitmapData.lock();
			if ( ! _isUsingLowerBmp )
				bitmapData.fillRect( bitmapData.rect, 0 );
			
			for each( r in _renders )
				if ( r.isRendered ) {
					_cache_point.x = r.buffer.x;
					_cache_point.y = r.buffer.y;
					bitmapData.copyPixels( r.bmp, r.bmp.rect, _cache_point, null, null, r.hasAlphaChannel );
				}
			bitmapData.unlock();
		}
		
		
		public function addRender( render:AbstractRender ):AbstractRender
		{
			if ( ! render is AbstractBmpRender )
				throw new Error("[com.jaycsantos.display.render.BitmapLayer::addRender] render must be a BitmapRender instance");
			
			var i:int = _renders.indexOf( render );
			if ( i > -1 ) return null;
			
			for ( i = 0; i < _renders.length; i++ ) {
				if ( _renders[i].depth > render.depth )
					break;
			}
			_renders.splice( i, 0, render );
			
			return render;
		}
		
		public function removeRender( render:AbstractRender ):AbstractRender
		{
			var i:int = _renders.indexOf( render );
			if ( i == -1 ) return null;
			
			_renders.splice( i, 1 );
			
			return render;
		}
		
		
			// -- private --
			
			protected var _layer:uint
			protected var _isUsingLowerBmp:Boolean
			protected var _cache_point:Point
			protected var _renders:Vector.<AbstractBmpRender> = new Vector.<AbstractBmpRender>()
			protected var _sort:Boolean
			
			protected function _compare( a:AbstractRender, b:AbstractRender ):int
			{
				return a.depth - b.depth;
			}
	}

}