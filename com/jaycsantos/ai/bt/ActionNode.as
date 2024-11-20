package com.jaycsantos.ai.bt 
{
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class ActionNode implements IBehaviorNode 
	{
		
		public function ActionNode() 
		{
			
		}
		
		
		/* INTERFACE com.jaycsantos.ai.IBehaviorNode */
		
		public function get weight():Number 
		{
			return _weight;
		}
		public function set weight( value:Number ):void
		{
			_weight = value;
		}
		
		public function execute():int 
		{
			throw new Error("[com.jaycsantos.ai.ActionNode::execute] override execute method");
		}
		
		public function dispose():void 
		{
			throw new Error("[com.jaycsantos.ai.ActionNode::dispose] override dispose method");
		}
		
		
			// -- private --
			private var _weight:Number;
	}

}