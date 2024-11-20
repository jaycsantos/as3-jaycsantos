package com.jaycsantos.ai.fsm
{	
	import com.jaycsantos.entity.IDisposable;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class StateMachine implements IDisposable
	{
		
		public var currentState:IState;
		public var signalChanged:Signal;
		
		public function StateMachine( owner:*, theCurrentState:IState = null, thePrimeState:IState = null )
		{
			_owner = owner;
			currentState = theCurrentState;
			_primeState = thePrimeState;
			
			if ( currentState == null )
				currentState = EmptyState.instance;
				
			if ( _primeState == null )
				_primeState = EmptyState.instance;
			
			currentState.owner = owner;
			_primeState.owner = owner;
			
			_previousState = currentState;
			
			signalChanged = new Signal( IState );
		}
		
		
		public function update():void
		{
			_primeState.update();
			currentState.update();
		}
		
		public function dispose():void
		{
			_owner = null;
			currentState = null;
			_previousState = null;
			_primeState = null;
		}
		
		public function changeState( newState:IState ):void
		{
			_previousState = currentState;
			currentState.exit();
			currentState = newState;
			currentState.owner = _owner;
			currentState.enter();
			signalChanged.dispatch( newState );
		}
		
		public function changePrimeState( newState:IState ):void
		{
			_primeState.exit();
			_primeState = newState;
			_primeState.owner = _owner;
			_primeState.enter();
		}
		
		public function changeToPreviousState():void
		{
			changeState( _previousState );
		}
		
		
			// -- private --
			
			protected var _owner:*;
			protected var _previousState:IState;
			protected var _primeState:IState;
		
	}

}