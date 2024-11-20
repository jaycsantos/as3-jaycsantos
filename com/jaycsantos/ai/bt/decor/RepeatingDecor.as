package com.jaycsantos.ai.bt.decor 
{
	import com.jaycsantos.ai.bt.*;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class RepeatingDecor extends AbstractDecorNode 
	{
		
		public function RepeatingDecor( node:IBehaviorNode )
		{
			super( node );
		}
		
		override public function execute():int 
		{
			_node.execute();
			
			return BehaviorTree.ACTION_RUNNING;
		}
		
	}

}