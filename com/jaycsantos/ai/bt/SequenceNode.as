package com.jaycsantos.ai.bt
{
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	internal class SequenceNode implements ICompositeNode
	{
		
		public function SequenceNode( args:Array = null )
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
			if ( _activeNode == null ) {
				_index = 0;
				_activeNode = _nodeMap[ _index ];
			}
			
			var r:int = _activeNode.execute();
			if ( r == BehaviorTree.ACTION_COMPLETE ) {
				_index++;
				
				if ( _index < _nodeMap.length ) {
					_activeNode = _nodeMap[ _index ];
				
				} else {
					_activeNode = null;
					_index = 0;
					return BehaviorTree.ACTION_COMPLETE;
				}
				
			} else
			if ( r != BehaviorTree.ACTION_RUNNING )
				return r;
			
			
			return BehaviorTree.ACTION_RUNNING;
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
			_nodeMap.push( node );
		}
		
			// -- private --
			
			private var _weight:Number = 0.1;
			private var _nodeMap:Vector.<IBehaviorNode> = new Vector.<IBehaviorNode>();
			private var _index:int = 0;
			private var _activeNode:IBehaviorNode;
		
	}

}