package com.jaycsantos.ai.bt.decor 
{
	import com.jaycsantos.ai.bt.*;
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class ErrHandlingDecor extends AbstractDecorNode 
	{
		
		public function ErrHandlingDecor( node:IBehaviorNode ) 
		{
			super( node );
		}
		
		override public function execute():int 
		{
			var r:int = _node.execute();
			if ( r == BehaviorTree.ACTION_ERROR && _node is ISelectCompositeNode )
				if ( ISelectCompositeNode(_node).nextNode() )
					return BehaviorTree.ACTION_RUNNING;
				
			return r;
		}
		
		
	}

}