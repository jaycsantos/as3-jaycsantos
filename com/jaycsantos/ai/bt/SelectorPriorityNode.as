package com.jaycsantos.ai.bt 
{
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	internal class SelectorPriorityNode implements ISelectCompositeNode
	{
		
		public function SelectorPriorityNode( args:Array = null )
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
			var r:int = _activeNode.execute();
			
			if ( r == BehaviorTree.ACTION_COMPLETE || r == BehaviorTree.ACTION_ERROR ) {
				// resets this node properties
				_activeNode = _nodeMap[ _index = 0 ];
				return r;
				
			} else if ( r == BehaviorTree.ACTION_FAIL ) {
				if ( ! nextNode() )
					return BehaviorTree.ACTION_ERROR;
			}
			
			return r;
		}
		
		public function dispose():void 
		{
			for each( var node:IBehaviorNode in _nodeMap )
				node.dispose();
			
			_nodeMap.splice( 0, _nodeMap.length );
			_nodeMap = null;
			_activeNode = null;
		}
		
		/* INTERFACE com.jaycsantos.ai.ICompositeNode */
		
		public function add( node:IBehaviorNode ):void
		{
			// insertion sort
			var pos:int = 0;
			var i:int = _nodeMap.length;
			while( i-- )
				if ( _nodeMap[i].weight < node.weight ) break;
			_nodeMap.splice( i+1, 0, val );
			
			_activeNode = _nodeMap[0];
		}
		
		/* INTERFACE com.jaycsantos.ai.ISelectCompositeNode */
		
		/**
		 * forces this composite to reselect another node
		 * @return true if there is a next node
		 */
		public function nextNode():Boolean
		{
			if ( ++_index >= _nodeMap ) {
				_activeNode = _nodeMap[ _index = 0 ];
				return false;
			}
			
			_activeNode = _nodeMap[ _index ];
			
			return true;
		}
		
		
			// -- private --
			
			private var _weight:Number;
			private var _nodeMap:Vector.<IBehaviorNode> = new Vector.<IBehaviorNode>();
			private var _index:int = 0;
			private var _activeNode:IBehaviorNode;
	}

}