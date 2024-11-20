package com.jaycsantos.ai.fsm 
{
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class EmptyState implements IState
	{
		public static function get instance():EmptyState
		{
			if ( _instance == null )
				_instance = new EmptyState;
			
			return _instance;
		}
		
			// -- private --
			private static var _instance:EmptyState;
			
		
		public function get owner():*
		{
			return _owner;
		}
		public function set owner( theOwner:* ):void
		{
			_owner = theOwner;
		}
		
		
		public function EmptyState() 
		{
			
		}
		
		public function enter():void
		{
			
		}
		
		public function update():void
		{
			
		}
		
		public function exit():void
		{
			
		}
		
		public function dispose():void
		{
			_owner = null;
		}
		
		
			// -- private --
			
			private var _owner:*;
		
	}

}