package com.jaycsantos.entity 
{
	import apparat.math.FastMath;
	import com.jaycsantos.math.Matrix2D;
	import com.jaycsantos.math.Trigo;
	import com.jaycsantos.math.Vector2D;
	import com.jaycsantos.entity.Entity;
	import com.jaycsantos.entity.EntityArgs;
	import com.jaycsantos.util.GameLoop;
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class MovableEntity extends Entity
	{
		public var np:Vector2D; // set to magically move the entity to that position
		
		public var rotation:Number; // logical rotation of the object
		public var velocity:Vector2D; // pixels per second
		public var accel:Vector2D; // acceleration
		public var friction:Number = 1; // slow down when hitting things
		public var damping:Number = 1; // slow down on velocity per tick
		public var heading:Vector2D; // the direction this is moving to
		public var headingSide:Vector2D; // parallel to heading direction
		
		public var maxSpeed:Number; // max speed
		public var maxAccel:Number; // max accel
		public var matchHeadingRotation:Boolean; // lock rotation to direction heading
		public var maxTurnSpeed:Number; // turn rate per second, set to 0 for infinite;
		
		// singals
		public var onMove:Signal;
		
		
		public function MovableEntity( args:MovableEntityArgs = null )
		{
			super( args );
			
			np = p.clone();
			
			accel = new Vector2D;
			velocity = new Vector2D;
			heading = new Vector2D( 1, 0 );
			headingSide = heading.getPerp();
			_oldVelocity = new Vector2D;
			_forces = new Vector2D;
			_constantForces = new Vector2D;
			_constantForcesMap = new Dictionary;
			
			rotation = args.rotation;
			friction = args.friction;
			damping = args.damping;
			maxSpeed = args.maxSpeed;
			maxAccel = args.maxAccel;
			matchHeadingRotation = args.matchHeadingRotation;
			maxTurnSpeed = args.maxTurnSpeed;
			
			onMove = new Signal( Number, Number );
		}
		
		
		override public function update():void 
		{
			_timeStep = GameLoop.instance.timeStep;
			
			_calcAccel();
			if ( velocity.lengthSq )
				_calcFinalVelocity();
			
			_updatePosition();
			_updateHeading();
			
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			onMove.removeAll();
			onMove = null;
			
			np = null;
			velocity = null;
			accel = null;
			heading = null;
			headingSide = null;
			_oldVelocity = null;
			_forces = null;
			
		}
		
		
		public function applyForce( x:Number, y:Number ):void
		{
			_forces.x += x;
			_forces.y += y;
		}
		
		
		public function addConstantForce( force:Vector2D, name:String ):void
		{
			_constantForcesMap[ name ] = force;
			_constantForcesMap[ force.toString() ] = name;
			
			_constantForces.x += force.x;
			_constantForces.y += force.y;
		}
		
		public function removeConstantForce( name:String ):void
		{
			if ( ! _constantForcesMap[name] ) return;
			
			var force:Vector2D = _constantForcesMap[ name ];
			delete _constantForcesMap[ force.toString() ];
			delete _constantForcesMap[ name ];
			
			_constantForces.x -= force.x;
			_constantForces.y -= force.y;
		}
		
		
		
			// -- private --
			
			protected var _oldVelocity:Vector2D;
			protected var _forces:Vector2D;
			protected var _constantForces:Vector2D;
			protected var _constantForcesMap:Dictionary;
			protected var _timeStep:Number;
			
			
			protected function _calcAccel():void
			{
				// clear acceleration
				accel.x = accel.y = 0;
				
				// apply forces
				accel.x += _forces.x;
				accel.y += _forces.y;
				
				// apply global forces
				accel.x += _constantForces.x;
				accel.y += _constantForces.y;
				
				if ( ! accel.lengthSq ) return;
				
				accel.truncate( maxAccel );
				
				velocity.x += accel.x;
				velocity.y += accel.y;
				
				// clear applied forces
				_forces.x = _forces.y = 0;
			}
			
			protected function _calcFinalVelocity():void
			{
				if ( maxTurnSpeed > 0 ) {
					var angle:Number = maxTurnSpeed * Trigo.DEG_TO_RAD * _timeStep;
					if ( _oldVelocity.angleTo(velocity) > angle ) {
						var mat:Matrix2D = new Matrix2D;
						mat.rotate( angle * heading.sign(velocity) );
						mat.transformVector( _oldVelocity );
						mat.transformVector( heading );
						velocity.x = _oldVelocity.x;
						velocity.y = _oldVelocity.y;
					}
				}
				
				// apply damping
				velocity.x *= damping;
				velocity.y *= damping;
				
				velocity.truncate( maxSpeed );
			}
			
			protected function _updatePosition():void
			{
				var dx:Number = velocity.x * _timeStep;
				var dy:Number = velocity.y * _timeStep;
				
				np.x += dx;
				np.y += dy;
				
				onMove.dispatch( np );
				
				p.x = np.x;
				p.y = np.y;
			}
			
			protected function _updateHeading():void
			{
				if ( velocity.lengthSq > 0.01 ) {
					heading = velocity.getNormalized();
					headingSide.x = -heading.y;
					headingSide.y = -heading.x;
					
					if ( matchHeadingRotation ) {
						var x:Number = heading.x, y:Number = heading.y;
						var rad:Number = Math.atan( y / x );
						if ( y < 0 && x > 0 )
							rotation = rad;
						else if ( (y < 0 && x < 0) || (y > 0 && x < 0) )
							rotation = rad + 3.141592653589793;
						else
							rotation = rad + 6.283185307179586;
					}
					
				} else {
					velocity.x = velocity.y = 0;
				}
			}
			
			
			
	}

}