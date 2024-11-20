package com.jaycsantos.ai.btree 
{
	import flash.utils.getQualifiedClassName;
	
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class BTreeBuilder 
	{
		
		public function BTreeBuilder() 
		{
			
		}
		
		public function composite( task:Class ):BTreeBuilder
		{
			var node:BNode = new task;
			if ( ! node is Composite )
				throw new Error("[com.jaycsantos.ai.btree.BTreeBuilder::composite] argument is not a composite class/subclass");
			
			if ( _node ) {
				if ( ! _node is Composite )
					throw new Error("[com.jaycsantos.ai.btree.BTreeBuilder::composite] parent node is not a composite, cannot add");
				Composite(_node).add( node );
				
			} else
			if ( ! _root )
				_root = node;
			_node = node;
			
			return this;
		}
		
		public function decorator( decor:Class ):BTreeBuilder
		{
			var node:BNode = new decor;
			if ( ! node is Decorator )
				throw new Error("[com.jaycsantos.ai.btree.BTreeBuilder::decorator] argument is not a decorator class/subclass");
			
			if ( _node ) {
				if ( ! _node is Composite )
					throw new Error("[com.jaycsantos.ai.btree.BTreeBuilder::decorator] parent node is not a composite, cannot add");
				Composite(_node).add( node );
				
			} else
			if ( ! _root )
				_root = node;
			_node = node;
			
			return this;
		}
		
		public function leaf( bnode:Class ):BTreeBuilder
		{
			var node:BNode = new bnode;
			if ( ! node is BNode )
				throw new Error("[com.jaycsantos.ai.btree.BTreeBuilder::leaf] argument is not a bnode class/subclass");
			
			if ( _node ) {
				if ( ! _node is Composite )
					throw new Error("[com.jaycsantos.ai.btree.BTreeBuilder::leaf] parent node is not a bnode, cannot add");
				Composite(_node).add( node );
				
			} else
			if ( ! _root )
				_root = node;
			_node = node;
			
			return this;
		}
		
		public function add( node:BNode ):BTreeBuilder
		{
			if ( ! node is BNode )
				throw new Error("[com.jaycsantos.ai.btree.BTreeBuilder::add] argument is not a node instance");
			
			if ( _node ) {
				if ( ! _node is Composite )
					throw new Error("[com.jaycsantos.ai.btree.BTreeBuilder::add] parent node is not a composite, cannot add node");
				Composite(_node).add( node );
				
			} else
			if ( ! _root )
				_root = _node;
			_node = node;
				
			return this;
		}
		
		
		public function weight( value:Number ):BTreeBuilder
		{
			_node.weight = value;
			
			return this;
		}
		
		public function name( value:String ):BTreeBuilder
		{
			_node.name = value;
			
			return this;
		}
		
		public function note( value:String ):BTreeBuilder
		{
			_node.note = value;
			
			return this;
		}
		
		public function setVar( property:String, value:* ):BTreeBuilder
		{
			if ( 1 || _node.hasOwnProperty(property) )
				_node[ property ] = value;
			else
				throw new Error("[com.jaycsantos.ai.btree.BTreeBuilder::setVar] Invalid property '"+ property +"' for node '"+ getQualifiedClassName(_node) +"'");
			
			return this;
		}
		
		public function end():BTreeBuilder
		{
			if ( _root != _node )
				_node = _node.parent;
			
			return this;
		}
		
		public function endGetRoot():BNode
		{
			return _node = _root;
		}
		
		
			// -- private --
			
			protected var _root:BNode;
			protected var _node:BNode;
		
	}

}