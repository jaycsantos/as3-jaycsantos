package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class SelectorProbability extends Sequence
	{
		/**
		 * A composite that selects a single child node based
		 * on its probability weight. Searches its child nodes
		 * until it returns succeess or high value failures.
		 */
		public function SelectorProbability() 
		{
			
		}
		
		override public function execute():int 
		{
			if ( _node == null ) next();
			
			var r:int
			while ( true ) {
				r = _node.execute();
				
				if ( r == 0 ) break;
				if ( r > 0 || r < -1 ) {
					restart();
					return r;
					
				} else if ( r == 1 ) {
					next();
				}
			}
				
			return r;
		}
		
		
			// -- private --
			
			override public function restart():void 
			{
				_node = null;
			}
			
			override public function next():Boolean 
			{
				var nodes:Vector.<BNode> = _nodeMap.concat();
				if ( _node != null ) // remove active node from selection
					nodes.splice( _ptr, 1 );
				
				var sum:Number = 0;
				var sumList:Vector.<Array> = new Vector.<Array>();
				for each( var node:BNode in nodes ) {
					sum += node.weight;
					sumList.push( [sum, node] );
				}
				
				var ran:Number = Math.random() * sum;
				var i:int = nodes.length;
				while ( i-- )
					if ( sumList[i] < ran )
						_node = nodes[i];
					else
						break;
				_ptr = i;
				
				return true;
			}
			
		
	}

}