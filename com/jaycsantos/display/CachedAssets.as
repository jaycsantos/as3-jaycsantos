package com.jaycsantos.display 
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.jaycsantos.util.GameLoop;
	import com.jaycsantos.util.ns.internalGameloop;
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CachedAssets 
	{
		public static const instance:CachedAssets = new CachedAssets
		
		public static function get isReady():Boolean
		{
			return instance._ready;
		}
		
		public static function getClip( name:String ):CachedBmp
		{
			if ( instance._map[name] != undefined )
				return instance._map[name] as CachedBmp;
			if ( instance._tempMap[name] != undefined )
				return instance._tempMap[name];
			return null;
		}
		
		public static function getClipList( list:Array ):Vector.<CachedBmp>
		{
			var i:int = list.length;
			var v:Vector.<CachedBmp> = new Vector.<CachedBmp>( i, true );
			while ( i-- ) {
				if ( instance._map[list[i]] != undefined )
					v[i] = instance._map[list[i]];
				else if ( instance._tempMap[list[i]] != undefined )
					v[i] = instance._tempMap[list[i]];
			}
			
			return v;
		}
		
		
		public function CachedAssets()
		{
			if ( instance ) throw new Error('[pb2.game.CachedAssets] Singleton class, use static property instance');
		}
		
		public function initialize( callback:Function, onComplete:Function ):void
		{
			if ( _ready ) {
				onComplete();
				return;
			}
			GameLoop.instance.internalGameloop::addCallback( _update );
			
			_callback = callback;
			_onComplete = onComplete;
		}
		
		
		public function cacheClip( name:String, clip:DisplayObject, transparent:Boolean = false, copyPattern:String = null ):CachedBmp
		{
			var c:CachedBmp = _cacheClip( name, clip, transparent );
			
			if ( copyPattern )
				for ( var k:String in _map )
					if ( k.substr(0,copyPattern.length) == copyPattern )
						if ( c.data.compare(_map[k].data) == 0 ) {
							c.data.dispose();
							return _map[name] = _map[k];
						}
			//MonsterDebugger.snapshot( this, new Bitmap(c.data), '', name );
			
			return _map[name] = c;
		}
		
		public function copyCache( sourceName:String, newName:String ):CachedBmp
		{
			if ( _map[sourceName] != undefined )
				return _map[newName] = _map[sourceName];
			else if ( _tempMap[sourceName] != undefined )
				return _tempMap[newName] = _tempMap[sourceName];
			return null;
		}
		
		public function mergeSameCache( list:Vector.<String> ):int
		{
			var c1:CachedBmp, c2:CachedBmp, found:int;
			
			for ( var i:int = 0; i < list.length; i++ ) {
				if ( _map[list[i]] == undefined ) continue;
				c1 = _map[list[i]];
				for ( var j:int = i + 1; j < list.length; j++ ) {
					if ( _map[list[j]] == undefined || _map[list[j]] == _map[list[i]] ) continue;
					c2 = _map[list[j]];
					if ( c1.data.compare(c2.data) == 0 ) {
						_map[list[j]] = c1;
						found++;
					}
				}
			}
			
			return found;
		}
		
		
		public function cacheTempClip( name:String, clip:DisplayObject, transparent:Boolean = false ):CachedBmp
		{
			return _tempMap[name] = _cacheClip( name, clip, transparent );
		}
		
		public function clearTempCache():void
		{
			for ( var k:String in _tempMap ) {
				_tempMap[k].data.dispose();
				delete _tempMap[k];
			}
		}
		
		public function clearCache( name:String ):void
		{
			if ( _map[name] != undefined ) {
				_map[name].data.dispose();
				delete _map[name];
			} else
			if ( _tempMap[name] != undefined ) {
				_tempMap[name].data.dispose();
				delete _tempMap[name];
			}
			
		}
		
			// -- private --
			
			private var _ready:Boolean
			private var _callback:Function
			private var _onComplete:Function
			private var _map:Dictionary = new Dictionary
			private var _tempMap:Dictionary = new Dictionary
			
			private var _empty:Shape = new Shape
			private var _emptyPt:Point = new Point
			
			
			private function _update():void
			{
				if ( ! _callback() ) {
					GameLoop.instance.internalGameloop::removeCallback( _update );
					_onComplete();
					_callback = _onComplete = null;
				}
			}
			
			private function _cacheClip( name:String, clip:DisplayObject, transparent:Boolean = false ):CachedBmp
			{
				var rect:Rectangle = clip.getBounds( _empty );
				// use local, this is global
				if ( clip.stage ) {
					var loc:Point = clip.localToGlobal( _emptyPt );
					rect.x -= loc.x;
					rect.y -= loc.y;
				}
				
				var x:int = Math.floor(rect.x), y:int = Math.floor(rect.y);
				var w:int = Math.ceil(rect.right)-x, h:int = Math.ceil(rect.bottom)-y;
				
				var bd:BitmapData = new BitmapData( w, h, transparent, 0 );
				var m:Matrix = clip.transform.matrix.clone();
				m.translate( -x, -y );
				bd.draw( clip, m, clip.transform.colorTransform, clip.blendMode );
				
				return new CachedBmp( bd, x, y );
			}
			
	}

}