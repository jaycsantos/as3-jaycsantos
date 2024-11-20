package com.jaycsantos.display 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class CachedBmpAssetFactory extends AssetFactory 
	{
		
		public function CachedBmpAssetFactory() 
		{
			
			
		}
		
		public function cacheLinkages( list:Array, callback:Function = null ):void
		{
			_cacheMap = new Dictionary;
			for ( var i:String in list )
				_cacheMap[ list[i] ] = null;
			
			if ( callback )
				_cacheCallback = callback;
		}
		
		
		override public function createDisplayObject( linkage:String ):DisplayObject 
		{
			return super.createDisplayObject(linkage);
		}
		
			// -- private --
			
			private var _cacheCallback:Function;
			private var _cacheMap:Dictionary;
			
			
			override protected function _libraryReady( e:Event ):void 
			{
				super._libraryReady( e );
				
				_ready = false;
			}
			
			
	}

}