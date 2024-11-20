package com.jaycsantos.ai.bt 
{
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class ParallelOrNode extends ParallelNode 
	{
		
		public function ParallelOrNode( args:Array = null ) 
		{
			super( args );
		}
		
		
		override public function execute():int 
		{
			var r:Vector.<int> = new Vector.<int>();
			
			for each( var node:IBehaviorNode in _nodeMap )
				r.push( node.update() );
				
			var min:int = 0, max:int = 0;
			for each( var i:int in r )
				if ( i < min )
					min = i;
				else if ( i > max )
					max = i;
			
			return min < 0 ? min : max;
		}
		
	}

}