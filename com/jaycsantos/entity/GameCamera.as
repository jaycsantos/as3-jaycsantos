package com.jaycsantos.entity 
{
	import apparat.math.FastMath;
	import com.jaycsantos.math.AABB;
	import com.jaycsantos.math.MathUtils;
	import com.jaycsantos.math.Vector2D;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class GameCamera extends Entity
	{
		public static const HIT_NONE:int = 0;
		public static const HIT_TOP:int = 1;
		public static const HIT_BOTTOM:int = 2;
		public static const HIT_LEFT:int = 4;
		public static const HIT_RIGHT:int = 8;
		
		
		// signals
		public var signalResize:Signal = new Signal( uint, uint )
		public var signalMove:Signal = new Signal( Number, Number )
		public var signalCentered:Signal = new Signal()
		public var signalHitEdge:Signal = new Signal( uint );
		
		public var velocity:Vector2D =  new Vector2D
		public var maxSpeed:Number = Number.MAX_VALUE
		
		public var np:Vector2D
		public var bounds:AABB
		public var offWorldWidth:Number, offWorldHeight:Number
		public var offX:Number, offY:Number
		
		
		// getter/setter
			public function set target( value:Vector2D ):void
			{
				if ( _flag.isFalse(FLAG_STOPCAM) )
					_targetVector = value;
			}
			
		
		public function GameCamera( world:GameWorld, width:uint, height:uint ) 
		{
			_id = "camera";
			
			offX = offY = offWorldWidth = offWorldHeight = 0;
			
			// center game camera
			p.Set( width / 2, height / 2 );
			np = p.clone();
			
			bounds = new AABB( p, width, height );
			signalResize.add( bounds.resize );
			signalMove.add( bounds.moveTo );
			
			world.signalResize.add( _worldResized );
			_worldResized( world.bounds.width, world.bounds.height );
			
			update();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			signalResize.removeAll(); signalResize = null;
			signalMove.removeAll(); signalMove = null;
			signalHitEdge.removeAll(); signalHitEdge = null;
			
			bounds = null;
			_targetVector = null;
		}
		
		
		override public function update():void 
		{
			if ( _targetVector ) {
				np.x = _targetVector.x +offX;
				np.y = _targetVector.y +offY;
			}
			
			var hitEdge:int;
			if ( _flag.isFalse(FLAG_STOPCAM) ) {
				var worldW:Number = _worldWidth +Math.abs(offWorldWidth*2);
				var worldH:Number = _worldHeight +Math.abs(offWorldHeight*2);
				
				if ( worldW > bounds.width ) {
					if ( np.x <= bounds.halfWidth ) {
						hitEdge |= HIT_LEFT;
						np.x = bounds.halfWidth -offWorldWidth;
						
					} else
					if ( np.x +bounds.halfWidth >= _worldWidth ) {
						hitEdge |= HIT_RIGHT;
						np.x = worldW -bounds.halfWidth +offWorldWidth;
					}
				} else {
					np.x = worldW /2 +offWorldWidth;
					hitEdge |= HIT_LEFT;
					hitEdge |= HIT_RIGHT;
				}
				
				if ( worldH > bounds.height ) {
					if ( np.y <= bounds.halfHeight ) {
						hitEdge |= HIT_TOP;
						np.y = bounds.halfHeight -offWorldHeight;
						
					} else
					if ( np.y + bounds.halfHeight >= _worldHeight ) {
						hitEdge |= HIT_BOTTOM;
						np.y = worldH -bounds.halfHeight +offWorldHeight;
					}
				} else {
					np.y = worldH /2 +offWorldHeight;
					hitEdge |= HIT_TOP;
					hitEdge |= HIT_BOTTOM;
				}
			}
			
			if ( _shakeLen > 0 ) {
				_shakeLen--;
				np.x += MathUtils.randomNumber( -_shakeIntensity, _shakeIntensity );
				np.y -= MathUtils.randomNumber( -_shakeIntensity, _shakeIntensity );
			}
			
			
			np.x = np.x <<0; np.y = np.y <<0;
			if ( p.x != np.x || p.y != np.y ) {
				var delta:Vector2D = np.subtractedBy( p );
				if ( maxSpeed && maxSpeed < Number.MAX_VALUE )
					delta.truncate( maxSpeed );
				
				p.addTo( delta );
				p.x = p.x << 0; p.y = p.y << 0;
				
				signalHitEdge.dispatch( hitEdge );
				signalMove.dispatch( p.x, p.y );
				_flag.setTrue( FLAG_ISMOVING );
				
			} else if ( _flag.isTrue(FLAG_ISMOVING) ) {
				signalCentered.dispatch();
				_flag.setFalse( FLAG_ISMOVING );
			}
			
		}
		
		
		public function stopFollow( fixedPos:Vector2D=null ):void
		{
			_flag.setTrue( FLAG_STOPCAM );
			if ( fixedPos )
				_targetVector = fixedPos;
		}
		
		public function startFollow( target:Vector2D=null ):void
		{
			_flag.setFalse( FLAG_STOPCAM );
			if ( target )
				_targetVector = target;
		}
		
		public function shake( intensity:uint, length:int ):void
		{
			if ( (_shakeIntensity = intensity) > 0 ) {
				_shakeLen = length;
				p.x += MathUtils.randomNumber( -_shakeIntensity, _shakeIntensity );
				p.y -= MathUtils.randomNumber( -_shakeIntensity, _shakeIntensity );
			}
		}
		
		public function resize( w:uint, h:uint ):void
		{
			signalResize.dispatch( w, h );
			
			/*if ( _worldWidth < bounds.width )
				p.x = _worldWidth / 2 << 0;
			if ( _worldHeight < bounds.height )
				p.y = _worldHeight / 2 << 0;*/
		}
		
		
			// -- private --
			private static const FLAG_ISMOVING:uint = 2 // 1<<2
			private static const FLAG_STOPCAM:uint = 4 // 1<<3
			
			
			protected var _targetVector:Vector2D
			protected var _worldWidth:Number, _worldHeight:Number
			protected var _shakeIntensity:uint, _shakeLen:int
			
			protected function _worldResized( w:Number, h:Number ):void
			{
				_worldWidth = w;
				_worldHeight = h;
				
				/*if ( _worldWidth < bounds.width )
					p.x = _worldWidth / 2 << 0;
				if ( _worldHeight < bounds.height )
					p.y = _worldHeight / 2 << 0;*/
			}
			
			
	}

}