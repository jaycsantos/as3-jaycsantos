package com.jaycsantos.util
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class L10n
	{
		public static function get instance():L10n
		{
			if ( _instance == null ) {
				_allow = true;
				_instance = new L10n();
				_allow = false;
			}
			
			return _instance;
		}
		
		public static function t( str:String ):String
		{
			return instance.translate( str );
		}
			// -- private
			
			private static var _instance:L10n;
			private static var _allow:Boolean;
		
		
		public function L10n() 
		{
			if ( ! L10n._allow )
				throw new Error( "[com.jaycsantos.util.L10n] do not directly instantiate, use static property instance" );
			
			_localMap = new XML( '<xml></xml>' );
			_fontMap = new Dictionary();
			_locals = new Vector.<String>();
		}
		
		public function loadXmlClass( byteCodeClass:Class, useDefault:Boolean = false ):Boolean
		{
			var file:ByteArray = new byteCodeClass();
			var str:String = file.readUTFBytes( file.length );
			var xml:XML = new XML( str );
			
			if ( ! _validate(xml) )
				return false;
			
			_load( xml );
			
			if ( useDefault )
				useLocal( xml.attribute("local") );
			
			return true;
		}
		
		public function getLocals():Vector.<String>
		{
			return _locals.concat();
		}
		
		public function getLocalName( str:String ):String
		{
			if ( _locals.indexOf(str) < 0 ) return null;
			
			return _localMap.l10n.(@local == str).@name;
		}
		
		public function useLocal( str:String ):Boolean
		{
			if ( _locals.indexOf(str) < 0 ) return false;
			
			_useLocal = str;
			return true;
		}
		
		public function translate( str:String, lang:String = null ):String
		{
			
			if ( str.length < 2 ) return str;
			
			// if lang is not specified, use the preffered local lang
			if ( lang == null ) lang = _useLocal;
			
			// english, no need to translate
			if ( lang == "en" ) return str;
			
			// no lang not found on local, cannot translate
			if ( ! _locals.indexOf(str) < 0 ) return str;
			
			var translated:String = _localMap.l10n.(@local == lang).string.(@value == str).toString();
			if ( translated.length )
				return translated;
			
			return str;
		}
		
		
		public function setLocalFont( local:String, font:String ):Boolean
		{
			if ( ! _locals.indexOf(local) < 0 ) return false;
			
			_fontMap[ local ] = font;
			return true;
		}
		
		public function getLocalFont( local:String = null ):String
		{
			return _fontMap[ local ];
		}
		
			// -- private
			
			protected var _localMap:XML;
			protected var _fontMap:Dictionary;
			protected var _useLocal:String = "en";
			protected var _locals:Vector.<String>;
			protected var _dirty:Boolean = true;
			
			protected function _validate( xml:XML ):Boolean
			{
				return xml.attribute("local") && xml.attribute("name") && xml.child("string");
			}
			
			protected function _load( xml:XML ):Boolean
			{
				_localMap.appendChild( xml );
				_locals.push( xml.attribute("local") );
				
				return _dirty = true;
			}
			
			
	}

}