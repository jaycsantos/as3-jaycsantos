package com.jaycsantos.ai.bt
{
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	internal class ParallelNode implements ICompositeNode
	{
		
		public function ParallelNode( args:Array = null )
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
			var a:int, b:int = BehaviorTree.ACTION_RUNNING, c:int;
			
			for each( var node:IBehaviorNode in _nodeMap ) {
				a = node.update();
				if ( a < 0 ) {
					if ( a < b )
						b = a;
				} else if ( a > 0 )
					b = a;
			}
			
			return b;
		}
		
		public function dispose():void 
		{
			
		}
		
		
		/* INTERFACE com.jaycsantos.ai.ICompositeNode */
		
		public function add( node:IBehaviorNode ):void
		{
			_nodeMap.push( node );
		}
		
			// -- private --
			
			private var _weight:Number;
			private var _nodeMap:Vector.<IBehaviorNode> = new Vector.<IBehaviorNode>();
		
	}

}