package com.jaycsantos.display.render
{
	import com.jaycsantos.entity.GameWorld;
	import com.jaycsantos.internalJayc;
	import com.jaycsantos.util.DisplayKit;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import pb2.game.Session;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	internal class RenderLayer extends Sprite implements IRenderLayer
	{
		use namespace internalJayc
		
		public function RenderLayer( layer:uint )
		{
			_layer = layer;
			
			mouseEnabled = false;
			mouseChildren = true;
			tabEnabled = false;
			tabChildren = true;
			
			name = "layer_" + layer;
		}
		
		public function dispose():void
		{
			DisplayKit.removeAllChildren( this, 2 );
			
			_renders.splice( 0, _renders.length );
		}
		
		
		public function update():void
		{
			for each( var r:AbstractRender in _renders ) {
				r.update();
				
				if ( r.sortMe ) {
					r.sorted();
					_sort = true;
				}
			}
			
			if ( _sort ) {
				var i:int;
				_renders.sort( _compare );
				i = _renders.length;
				while ( i-- )
					setChildIndex( _renders[i].buffer, i );
				_sort = false;
			}
			
		}
		
		
		public function addRender( render:AbstractRender ):AbstractRender
		{
			var i:int = _renders.indexOf( render );
			if ( i > -1 ) return null;
			
			for ( i = 0; i < _renders.length; i++ ) {
				if ( _renders[i].depth > render.depth )
					break;
			}
			_renders.splice( i, 0, render );
			addChildAt( render.buffer, i );
			
			return render;
		}
		
		public function removeRender( render:AbstractRender ):AbstractRender
		{
			var i:int = _renders.indexOf( render );
			if ( i == -1 ) return null;
			
			_renders.splice( i, 1 );
			if ( render.buffer.parent==this )
				removeChild( render.buffer );
			
			return render;
		}
		
		
			// -- private --
			
			protected var _layer:uint
			protected var _renders:Vector.<AbstractRender> = new Vector.<AbstractRender>()
			protected var _sort:Boolean
			
			protected function _compare( a:AbstractRender, b:AbstractRender ):int
			{
				return a.depth - b.depth;
			}
			
	}

}