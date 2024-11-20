package com.jaycsantos.display.render 
{
	import com.jaycsantos.display.render.AbstractRender;
	import com.jaycsantos.entity.Entity;
	import com.jaycsantos.entity.EntityArgs;
	import com.jaycsantos.entity.GameCamera;
	import com.jaycsantos.math.AABB;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class AbstractBmpRender extends AbstractRender
	{
		public var bmp:BitmapData
		// set to true so that render layer will merge alpha
		public var hasAlphaChannel:Boolean = false
		
		public var bmpOffX:int, bmpOffY:int
		
		
		public function AbstractBmpRender( entity:Entity, args:EntityArgs = null )
		{
			super( entity, args );
			
			buffer = new Bitmap( args.data.bmp? args.data.bmp: (args.dimension.length? bmp=new BitmapData(args.dimension.x, args.dimension.y, true , 0): null) );
			buffer.name = args.type + _entity.id + "_bmpRender";
			buffer.visible = false;
			
			if ( bmp )
				bounds.Set( entity.p, bmp.width, bmp.height );
		}
		
		override public function dispose():void 
		{
			if ( bmp ) bmp.dispose();
			bmp = null;
			
			super.dispose();
		}
		
			// -- private --
			
			override protected function _reposition():void 
			{
				var camera:AABB = _entity.world.camera.bounds;
				buffer.x = (_entity.p.x -camera.min.x) +bmpOffX;
				buffer.y = (_entity.p.y -camera.min.y) +bmpOffY;
			}
			
	}

}