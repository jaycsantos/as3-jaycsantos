package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class Sequence extends Composite implements IUniTask 
	{
		/**
		 * A composite that executes nodes by sequence and only after it succeeds 
		 * does the sequence continues. Any failure will break the sequence.
		 */
		public function Sequence() 
		{
			
		}
		
		override public function execute():int 
		{
			if ( _node == null )
				next();
			
			var r:int = _node.execute();
			
			if ( r < 0 ) {
				restart();
				return r;
				
			} else if ( r > 0 ) {
				if ( next() )
					return 0;
			}
			
			return r;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			_node = null;
		}
		
		
		/* INTERFACE com.jaycsantos.ai.btree.IUniTask */
		
		public function restart():void 
		{
			_node = _nodeMap[ _ptr = 0 ];
			for each( var node:BNode in _nodeMap )
				if ( node is IUniTask )
					IUniTask( node ).restart();
		}
		
		public function next():Boolean 
		{
			if ( ++_ptr >= _nodeMap.length ) {
				restart();
				return false;
			}
			
			_node = _nodeMap[ _ptr ];
			
			return true;
		}
		
		
			// -- private --
			
			protected var _node:BNode;
			protected var _ptr:int;
		
	}

}