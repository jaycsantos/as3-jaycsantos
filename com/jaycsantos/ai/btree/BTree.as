package com.jaycsantos.ai.btree 
{
	import com.jaycsantos.entity.Entity;
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class BTree 
	{
		public static function get instance():BTree
		{
			if ( _instance == null ) {
				_allow = true;
				_instance = new BTree;
				_allow = false;
			}
		}
		
		
		public function BTree()
		{
			if ( ! _allow ) 
				throw new Error("[com.jaycsantos.ai.btree.BTree::constructor] Singleton, use static getter instance");
			
		}
		
		public function targetEntity( e:Entity ):void
		{
			entity = e;
		}
		
		public function targetBlackBoard( bb:IBlackBoard ):void
		{
			this.bb = bb;
		}
		
		
		public function dispose():void
		{
			entity = null;
			bb = null;
			_instance = null;
		}
		
		
			// -- private --
			
			private static var _allow:Boolean = false;
			private static var _instance:BTree;
			
			
			behavior var entity:Entity;
			behavior var bb:IBlackBoard;
			
	}

}