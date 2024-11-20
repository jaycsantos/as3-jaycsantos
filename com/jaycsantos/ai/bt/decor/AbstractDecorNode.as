package com.jaycsantos.ai.bt.decor 
{
	import com.jaycsantos.ai.bt.IBehaviorNode;
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class AbstractDecorNode implements IBehaviorNode 
	{
		
		public function AbstractDecorNode( node:IBehaviorNode )
		{
			_node = node;
		}
		
		/* INTERFACE com.jaycsantos.ai.IBehaviorNode */
		
		public function get weight():Number 
		{
			return _node.weight;
		}
		public function set weight( value:Number ):void 
		{
			_node.weight = value;
		}
		
		public function execute():int 
		{
			throw new Error("[com.jaycsantos.ai.AbstractDecoratorNode::execute] override execute method");
		}
		
		public function dispose():void 
		{
			_node.dispose();
			_node = null;
		}
		
		
			// -- private --
			
			protected var _node:IBehaviorNode;
			
	}

}