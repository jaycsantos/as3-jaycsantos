package com.jaycsantos.ai.bt 
{
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	internal class SelectorProbability implements ISelectCompositeNode
	{
		
		public function SelectorProbability( args:Array = null ) 
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
			if ( _activeNode == null )
				nextNode();
			
			var r:int = _activeNode.execute();
			
			if ( r == BehaviorTree.ACTION_COMPLETE || r == BehaviorTree.ACTION_ERROR ) {
				// resets this node properties
				_unUsedMap.splice( 0, _unUsedMap.length );
				_activeNode = null;
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
			_unUsedMap.splice( 0, _unUsedMap.length );
			_unUsedMap = null;
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
		}
		
		/* INTERFACE com.jaycsantos.ai.ISelectCompositeNode */
		
		/**
		 * forces this composite to reselect another node
		 * @return true if there is a next node
		 */
		public function nextNode():Boolean
		{
			var renewed:Boolean;
			if ( ! _unUsedMap.length ) {
				_unUsedMap = _nodeMap.concat();
				renewed = true;
			}
			
			var sum:Number = 0, sums:Vector.<Number> = new Vector.<Number>();
			for each( var node:IBehaviorNode in _unUsedMap ) {
				sum += node.weight;
				sums.push( sum );
			}
			
			var i:Number = Math.random() * sum;
			var j:int = _unUsedMap.length;
			while ( j-- )
				if ( sums[j] < i )
					_activeNode = _unUsedMap[j];
				else
					break;
			
			return ! renewed;
		}
		
		
			// -- private --
			
			private var _weight:Number;
			private var _nodeMap:Vector.<IBehaviorNode> = new Vector.<IBehaviorNode>();
			private var _unUsedMap:Vector.<IBehaviorNode>;
			private var _activeNode:IBehaviorNode;
	}

}