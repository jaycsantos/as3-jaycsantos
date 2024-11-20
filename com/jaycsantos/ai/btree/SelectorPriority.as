package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class SelectorPriority extends Sequence
	{
		/**
		 * A composite that selects a single node based on its priority.
		 * Succeeds if selected node succeeds and fails only if all of the child
		 * nodes fails. Imediately returns higher failures from any child node.
		 */
		public function SelectorPriority()
		{
			
		}
		
		override public function execute():int 
		{
			if ( _node == null )
				next();
			
			var r:int = _node.execute();
			
			if ( r < -1 ) {
				restart();
				return r;
				
			} else if ( r == -1 ) {
				if ( next() )
					return 0;
			}
			
			return r;
		}
		
		
			// -- private --
			
			protected var _sorted:Boolean = false;
			
			// -- internal --
			
			override behavior function add( node:BNode ):void 
			{
				super.add( node );
				_sorted = false;
			}
			
			override public function restart():void 
			{
				super.restart();
				
				if ( ! _sorted ) {
					_nodeMap.sort( Composite.sortAsc );
					_sorted = true;
				}
			}
		
			
	}

}