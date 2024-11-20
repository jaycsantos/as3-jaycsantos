package com.jaycsantos 
{
	import com.jaycsantos.IDisposable;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class AssetFactory
	{
		public function get ready():Boolean
		{
			return _ready;
		}
		
		
		public function AssetFactory() 
		{
			
		}
		
		public function activate( byteClass:Class, callback:Function = null ):void
		{
			if ( callback != null )
				_callback = callback;
			
			_loader = new Loader;
			_loader.contentLoaderInfo.addEventListener( Event.INIT, _libraryReady, false, 0, true );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError, false, 0, true );
			_loader.loadBytes( new byteClass );
		}
		
		
		public function createDisplayObject( linkage:String ):DisplayObject
		{
			return (new (Class( _loaderInfo.applicationDomain.getDefinition(linkage) ))) as DisplayObject;
		}
		
		public function createBitmapData( linkage:String ):BitmapData
		{
			return (new (Class( _loaderInfo.applicationDomain.getDefinition(linkage) ))) as BitmapData;
		}
		
		public function createSound( linkage:String ):Sound
		{
			return (new (Class( _loaderInfo.applicationDomain.getDefinition(linkage) ))()) as Sound;
		}
		
		public function createObject( linkage:String ):Object
		{
			return new (Class( _loaderInfo.applicationDomain.getDefinition(linkage) ));
		}
		
			
			
			// -- private --
			
			protected var _loader:Loader;
			protected var _loaderInfo:LoaderInfo;
			protected var _callback:Function;
			
			protected var _ready:Boolean = false;
			
			
			protected function _libraryReady( e:Event ):void
			{
				_loader.contentLoaderInfo.removeEventListener( Event.INIT, _libraryReady );
				_loaderInfo = e.target as LoaderInfo;
				_ready = true;
				
				if ( _callback != null ) {
					_callback();
					_callback = null;
					_loader = null;
				}
			}
			
			protected function _ioError( e:IOErrorEvent ):void
			{
				trace( "ioError: " + e.toString() );
			}
			
	}

}