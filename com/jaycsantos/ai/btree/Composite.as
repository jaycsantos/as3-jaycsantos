package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	internal class Composite extends BNode
	{
		
		public function Composite()
		{
			
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			for each( var node:BNode in _nodeMap )
				node.dispose();
			_nodeMap.splice( 0, _nodeMap.length );
			_nodeMap = null;
		}
		
		
		public function findChildByClass( classname:String ):BNode
		{
			for each( var node:BNode in _nodeMap ) {
				if ( node.name is classname )
					return node;
				if ( node is Composite ) {
					node = Composite( node ).findChildByClass( name );
					if ( node )
						return node;
				}
			}
			return null;
		}
		
		public function findChildByName( name:String ):BNode
		{
			for each( var node:BNode in _nodeMap ) {
				if ( node.name == name )
					return node;
				if ( node is Composite ) {
					node = Composite( node ).findChildByName( name );
					if ( node )
						return node;
				}
			}
			return null;
		}
		
		
			// -- private --
			
			protected var _nodeMap:Vector.<BNode> = new Vector.<BNode>();
			
			
			// -- internal --
			
			behavior function add( node:BNode ):void
			{
				node.parent = this;
				_nodeMap.push( node );
			}
			
			
		
		behavior static function sortAsc( a:BNode, b:BNode ):Number
		{
			return a.weight - b.weight;
		}
		
	}

}