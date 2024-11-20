package com.jaycsantos
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ExternalAssetFactory extends AssetFactory
	{
		public static function get instance():ExternalAssetFactory
		{
			if ( _instance == null ) {
				_allow = true;
				_instance = new ExternalAssetFactory;
				_allow = false;
			}
			return _instance;
		}
		
		
		public var defaultSwfLib:String;
		
		override public function get ready():Boolean
		{
			return _ready;
		}
		
		
		
		public function ExternalAssetFactory() 
		{
			if ( ! _allow )
				throw new Error("[com.jaycsantos.util.ExternalAssetFactory] Singleton only");
			
			_filesToLoad = new Vector.<String>();
			_dataMap = new Dictionary;
			_swfs = new Dictionary;
			_bmps = new Dictionary;
			_xmls = new Dictionary;
		}
		
		
		public function addSwfLibrary( name:String, url:String ):void
		{
			if ( _lock ) return;
			
			if ( _dataMap[name] )
				throw new Error("[com.jaycsantos.util.ExternalAssetFactory::addSwfLibrary] name '" + name +"' is already used");
			
			defaultSwfLib = name;
			_swfs[ name ] = url;
			_dataMap[ name ] = null;
			_filesToLoad.push( name );
		}
		
		public function addBitmap( name:String, url:String ):void
		{
			if ( _lock ) return;
			
			if ( _dataMap[name] )
				throw new Error("[com.jaycsantos.util.ExternalAssetFactory::addBitmap] name '" + name +"' is already used");
			
			_bmps[ name ] = url;
			_dataMap[ name ] = null;
			_filesToLoad.push( name );
		}
		
		public function addXML( name:String, url:String ):void
		{
			if ( _lock ) return;
			
			if ( _dataMap[name] )
				throw new Error("[com.jaycsantos.util.ExternalAssetFactory::addXML] name '" + name +"' is already used");
			
			_xmls[ name ] = url;
			_dataMap[ name ] = null;
			_filesToLoad.push( name );
		}
		
		
		override public function activate( byteClass:Class, callback:Function = null ):void 
		{
			trace( "WARNING: Do not use activate() for ExternalAssetFactory, use load() instead" );
		}
		
		public function load( callback:Function = null ):void
		{
			if ( _lock ) return;
			
			if ( callback !== null )
				_callback = callback;
			_lock = true;
			
			_loadNextObject();
		}
		
		
		
		override public function createBitmapData( linkage:String ):BitmapData
		{
			return (new (Class( LoaderInfo(_dataMap[ defaultSwfLib ]).applicationDomain.getDefinition(linkage) ))) as BitmapData;
		}
		
		override public function createDisplayObject( linkage:String ):DisplayObject 
		{
			return (new (Class( LoaderInfo(_dataMap[ defaultSwfLib ]).applicationDomain.getDefinition(linkage) ))) as DisplayObject;
		}
		
		override public function createSound( linkage:String ):Sound 
		{
			return (new (Class( LoaderInfo(_dataMap[ defaultSwfLib ]).applicationDomain.getDefinition(linkage) ))) as Sound;
		}
		
		override public function createObject( linkage:String ):Object 
		{
			return (new (Class( LoaderInfo(_dataMap[ defaultSwfLib ]).applicationDomain.getDefinition(linkage) )));
		}
		
		
		public function getXML( name:String ):XML
		{
			if ( ! _xmls[name] ) return null;
			
			return XML(_dataMap[ name ]);
		}
		
		public function getBitmap( name:String ):Bitmap
		{
			if ( ! _bmps[name] ) return null;
			
			return Bitmap(_dataMap[ name ]);
		}
		
		
			// -- private --
			
			private static var _allow:Boolean = false;
			private static var _instance:ExternalAssetFactory;
			
			//private var _ready:Boolean;
			private var _lock:Boolean;
			
			private var _filesToLoad:Vector.<String>;
			private var _swfs:Dictionary;
			private var _bmps:Dictionary;
			private var _xmls:Dictionary;
			
			//private var _loader:Loader;
			private var _urlLoader:URLLoader;
			
			//private var _callback:Function;
			
			private var _dataMap:Dictionary;
			
			
			protected function _loadNextObject():void
			{
				if ( ! _filesToLoad.length ) {
					_ready = true;
					trace( "[Extrnl] complete, continuing to game" );
					
					if ( _callback !== null ) _callback();
					_callback = null;
					
					_lock = false;
					return;
				}
				
				
				var key:String = _filesToLoad[0];
				if ( _swfs[key] ) {
					_loader = new Loader;
					_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _libraryReady, false, 0, true );
					_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError, false, 0, true );
					_loader.load( new URLRequest(_swfs[key]) );
					
				} else if ( _bmps[key] ) {
					_loader = new Loader;
					_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _bmpReady, false, 0, true );
					_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _ioError, false, 0, true );
					_loader.load( new URLRequest(_bmps[key]) );
					
				} else if ( _xmls[key] ) {
					_urlLoader = new URLLoader();
					_urlLoader.addEventListener( Event.COMPLETE, _xmlReady, false, 0, true );
					_urlLoader.addEventListener( IOErrorEvent.IO_ERROR, _ioError, false, 0, true );
					_urlLoader.load( new URLRequest(_xmls[key]) );
				}
				
				trace( "[Extrnl] loading "+ key );
			}
			
			override protected function _libraryReady( e:Event ):void
			{
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _libraryReady );
				_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
				
				var key:String = _filesToLoad[0];
				_dataMap[ key ] = e.target as LoaderInfo;
				
				trace( "[Extrnl] swf "+ key + " done" );
				
				_filesToLoad.splice( 0, 1 );
				_loadNextObject();
			}
			
			protected function _bmpReady( e:Event ):void
			{
				_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _libraryReady );
				_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
				
				var key:String = _filesToLoad[0];
				_dataMap[ key ] = _loader.content as Bitmap;
				
				trace( "[Extrnl] bmp "+ key + " done" );
				
				_filesToLoad.splice( 0, 1 );
				_loadNextObject();
			}
			
			protected function _xmlReady( e:Event ):void
			{
				_urlLoader.removeEventListener( Event.COMPLETE, _libraryReady );
				_urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
				
				var key:String = _filesToLoad[0];
				_dataMap[ key ] = new XML( e.target.data );
				
				trace( "[Extrnl] xml "+ key + " done" );
				
				_filesToLoad.splice( 0, 1 );
				_loadNextObject();
			}
			
			
			override protected function _ioError( e:IOErrorEvent ):void
			{
				trace( "3: ioError: " + e.text );
				
				_filesToLoad.splice( 0, 1 );
				_loadNextObject();
			}
			
	}

}