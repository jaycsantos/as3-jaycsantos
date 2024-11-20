package com.jaycsantos.ai.btree 
{
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class SelectorProbabilityOnce extends SelectorProbability 
	{
		
		public function SelectorProbabilityOnce() 
		{
			
		}
		
		override public function execute():int 
		{
			if ( _node == null ) next();
			
			var r:int;
			while ( true ) {
				r = _node.execute();
				
				if ( r == 0 ) break;
				if ( r > 0 || r < -1 ) {
					restart();
					return r;
					
				} else if ( r == 1 ) {
					if ( ! next() ) {
						restart();
						return -1;
					}
				}
			}
				
			return r;
		}
		
			// -- private --
			
			protected var _cleanNodes:Vector.<BNode> = new Vector.<BNode>();
			
			
			override public function restart():void 
			{
				_cleanNodes = _nodeMap.concat();
				for each( var node:BNode in _nodeMap )
					if ( node is IUniTask )
						IUniTask( node ).restart();
			}
			
			override public function next():Boolean 
			{
				var restarted:Boolean = false;
				if ( ! _cleanNodes.length ) {
					restart();
					restarted = true;
				}
				
				var sum:Number = 0;
				var sumList:Vector.<Array> = new Vector.<Array>();
				for each( var node:BNode in _cleanNodes ) {
					sum += node.weight;
					sumList.push( [sum, node] );
				}
				
				var ran:Number = Math.random() * sum;
				var i:int = _cleanNodes.length;
				while ( i-- )
					if ( sumList[i] < ran )
						_node = _cleanNodes[i];
					else
						break;
				_ptr = i;
				_cleanNodes.splice( i, 1 );
				
				return ! restarted;
			}
			
	}

}