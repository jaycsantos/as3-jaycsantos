package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class Decorator extends Composite implements IUniTask
	{
		// -- internal --
		
		behavior var node:BNode;
		
		/**
		 * Base decorator class for a Node
		 */
		public function Decorator()
		{
			
		}
		
		override public function execute():int 
		{
			return node.execute();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			node.dispose();
			node = null;
		}
		
		
			// -- private --
			
			override behavior function add( node:BNode ):void
			{
				if ( this.node != null )
					throw new Error( "[com.jaycsantos.ai.btree.Decorator::add] Decorator already has a child, cannot add more than one" );
				
				node.parent = this;
				this.node = node;
				_nodeMap[0] = node;
			}
			
			public function restart():void
			{
				if ( node is IUniTask )
					IUniTask(node).restart();
			}
			
			public function next():Boolean
			{
				if ( node is IUniTask )
					return IUniTask(node).next();
				return true;
			}
			
		
	}

}