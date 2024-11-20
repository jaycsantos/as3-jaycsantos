package com.jaycsantos.sound 
{
	import com.jaycsantos.game.IGameObject;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameSounds
	{
		public static const SFX_GROUP:uint = 1;
		public static const MUSIC_GROUP:uint = 2;
		
		public static const instance:GameSounds = new GameSounds
		public static var maxChannels:uint = 8
		public static var poolDelayGap:uint = 500
		public static var musicPlaying:GameSoundObj
		public static var volumeMusic:Number = 1
		public static var volumeSfx:Number = 1
		
		public function GameSounds() 
		{
			if ( instance ) throw new Error('[com.jaycsantos.sound.GameSounds] Singleton class, use static property instance');
			
			
		}
		
		
		public function addPool( sndObj:GameSoundObj ):GameSoundObj
		{
			if ( _pool[sndObj.name] == undefined )
				_pool[sndObj.name] = new Vector.<GameSoundObj>;
			
			_pool[sndObj.name].push( sndObj );
			
			return sndObj;
		}
		
		public function add( sndObj:GameSoundObj ):GameSoundObj
		{
			return _map[ sndObj.name ] = sndObj;
		}
		
		
		public function play( name:String, startTime:Number=0, loops:int=0, volume:Number=1, onEnd:Function=null, onStop:Function=null ):Boolean
		{
			var i:int, prioritize:Boolean = _nowPlaying.length >= maxChannels;
			var sndObj:GameSoundObj;
			
			//if ( !volume && ) return false;
			if ( _lastPlayMap[name] != undefined && uint(_lastPlayMap[name]) > getTimer() )
				return false;
			_lastPlayMap[name] = getTimer() +poolDelayGap;
			
			if ( _map[name] != undefined ) {
				sndObj = _map[name];
				if ( sndObj.isPlaying() || (sndObj.group & _muteFlag) > 0 ) return false;
				
			} else
			if ( _pool[name] != undefined ) {
				// find from pool
				i = _pool[name].length;
				if ( (_pool[name][0].group & _muteFlag) > 0 ) return false;
				while ( i-- )
					if ( !_pool[name][i].isPlaying() ) {
						sndObj = _pool[name][i];
						break;
					}
			}
			if ( ! sndObj ) return false;
			
			if ( prioritize ) {
				i = _nowPlaying.length;
				while ( i-- )
					if ( sndObj.priority > _nowPlaying[i].priority ) {
						_nowPlaying[i].stop();
						prioritize = false;
						break;
					}
			}
			
			if ( ! prioritize ) {
				//if ( (sndObj.group & MUSIC_GROUP) > 0 ) {
				if ( sndObj.group == MUSIC_GROUP ) {
					if ( musicPlaying ) musicPlaying.stop();
					musicPlaying = sndObj;
					_lastMusic = sndObj.name;
				}
				
				sndObj.play( startTime, loops, volume );
				_nowPlaying.push( sndObj );
				sndObj.onStop.addOnce( _onStop );
				sndObj.onEnd.addOnce( _onStop );
				if ( onEnd != null )
					sndObj.onEnd.addOnce( onEnd );
				if ( onStop != null ) 
					sndObj.onStop.addOnce( onStop );
				
				return true;
			}
			
			return false;
		}
		
		public function stop( name:String ):void
		{
			var i:int = _nowPlaying.length;
			if ( name )
				while ( i-- )
					if ( _nowPlaying[i].name == name ) {
						_nowPlaying[i].stop();
						break;
					}
		}
		
		public function setPanVol( name:String, pan:Number=0, vol:Number=1 ):void
		{
			var i:int = _nowPlaying.length;
			if ( name )
				while ( i-- )
					if ( _nowPlaying[i].name == name ) {
						_nowPlaying[i].setPanVol( pan, vol );
						break;
					}
		}
		
		public function getSoundObj( name:String ):GameSoundObj
		{
			return _map[ name ];
		}
		
		public function isPlaying( name:String ):Boolean
		{
			var i:int = _nowPlaying.length;
			if ( name )
				while ( i-- )
					if ( _nowPlaying[i].name == name )
						return true;
			return false;
		}
		
		public function getLastMusic():String
		{
			return _lastMusic;
		}
		
		
		public static function play( name:String, startTime:Number=0, loops:int=0, volume:Number=1, onEnd:Function=null, onStop:Function=null ):Boolean
		{
			return instance.play( name, startTime, loops, volume, onEnd, onStop );
		}
		
		public static function stop( name:String ):void
		{
			instance.stop( name );
		}
		
		public static function setPanVol( name:String, pan:Number=0, vol:Number=1 ):void
		{
			instance.setPanVol( name, pan, vol );
		}
		
		public static function mute( group:uint=0xffffff ):void
		{
			var snd:GameSoundObj, i:int = instance._nowPlaying.length;
			while ( i-- ) {
				snd = instance._nowPlaying[i];
				if ( (snd.group & group) > 0 )
					snd.stop();
			}
			
			instance._muteFlag |= group;
		}
		
		public static function unMute( group:uint=0xffffff ):void
		{
			instance._muteFlag &= ~group;
		}
		
		public static function stopGroup( group:uint=0xffffff ):void
		{
			for each( var gSndObj:GameSoundObj in instance._nowPlaying )
				if ( (gSndObj.group & group) > 0 ) 
					gSndObj.stop();
		}
		
		public static function setPanVolGroup( group:uint=0xffffff, pan:Number=0, vol:Number=1 ):void
		{
			for each( var gSndObj:GameSoundObj in instance._nowPlaying )
				if ( (gSndObj.group & group) > 0 ) 
					gSndObj.setPanVol( pan, vol );
		}
		
		
			// -- private --
			
			private var _pool:Dictionary = new Dictionary
			private var _map:Dictionary = new Dictionary
			private var _nowPlaying:Vector.<GameSoundObj> = new Vector.<GameSoundObj>
			private var _lastPlayMap:Dictionary = new Dictionary
			private var _muteFlag:uint, _lastMusic:String
			
			private function _onStop( sndObj:GameSoundObj ):void
			{
				var p:int = _nowPlaying.indexOf( sndObj );
				if ( p > -1 )
					_nowPlaying.splice( p, 1 );
				
				if ( (sndObj.group & MUSIC_GROUP) > 0 )
					musicPlaying = null;
			}
			
			
	}

}