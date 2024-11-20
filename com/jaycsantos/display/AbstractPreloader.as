package com.jaycsantos.display 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class AbstractPreloader extends MovieClip
	{
		
		public function AbstractPreloader() 
		{
			trace( "[preloader] " + Number(this.loaderInfo.bytesLoaded / 1024).toFixed(2) +"kb"  );
			
			//_initStage();
			_initContextMenu();
			
			if ( stage ) _initStage();
			else  addEventListener( Event.ADDED_TO_STAGE, _initStage, false, 0, true );
		}
		
			// -- private --
			private static const JAYC_SITE_URL:String = "http://jaycsantos.com/?ref=";
			
			protected var _mainClassName:String;
			protected var _url:String;
			protected var _menuItemCaptionOwner:String = "Built by Jayc Santos!";
			
			protected function _initStage( e:Event = null ):void
			{
				removeEventListener( Event.ADDED_TO_STAGE, _initStage );
				
				
				stage.scaleMode = StageScaleMode.NO_SCALE;
				CONFIG::release
				{
					stage.align = StageAlign.TOP_LEFT;
				}
				stage.stageFocusRect = false;
				
				addEventListener( Event.ENTER_FRAME, _enterFrame, false, 0, true );
			}
			
			protected function _initContextMenu():void
			{
				contextMenu = new ContextMenu;
				contextMenu.hideBuiltInItems();
				
				_url = loaderInfo.url;
				
				var menu:ContextMenuItem = new ContextMenuItem( _menuItemCaptionOwner, false );
				menu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _onOwnerMenuItemSelect, false, 0, true );
				
				contextMenu.customItems.push( menu );
			}
			
			
			protected function _onOwnerMenuItemSelect( e:Event ):void
			{
				navigateToURL( new URLRequest(JAYC_SITE_URL + _url), "_blank" );
			}
			
			
			
			
			protected function _enterFrame( e:Event ):void
			{
				if ( currentFrame == totalFrames ) {
					removeEventListener( Event.ENTER_FRAME, _enterFrame );
					_preloadComplete();
				}
			}
			
			protected function _preloadComplete():void
			{
				trace( "[preloader] completed " + Number(this.loaderInfo.bytesLoaded/1024).toFixed(2) +"kb"  );
				
				stop();
				if ( _mainClassName == null )
					throw new Error( "Main class not defined" );
				
				var mainClass:Class = getDefinitionByName(_mainClassName) as Class;
				addChild( new mainClass() as DisplayObject );
			}
			
			
			
	}

}