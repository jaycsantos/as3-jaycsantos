package com.jaycsantos.ai.btree 
{
	import com.jaycsantos.IDisposable;
	import flash.utils.getQualifiedClassName;
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class BNode implements IDisposable
	{
		public static const WEIGHT:String = "weight";
		
		behavior var parent:Composite;
		
		behavior var weight:Number = 0;
		
		behavior var name:String = "Node";
		
		behavior var note:String = "";
		
		
		public function BNode()
		{
			
		}
		
		public function execute():int 
		{
			throw new Error("[com.jaycsantos.ai.btree.BNode::execute] override the execute method");
		}
		
		public function dispose():void 
		{
			parent = null;
			name = null;
			note = null;
		}
		
		
		public function toString():String
		{
			return name + _id;
		}
		
		public function pathString():String
		{
			var s:String = toString();
			var p:Composite = parent;
			while ( p ) {
				s = p.toString() +'.'+ s;
				p = p.parent;
			}
			
			return s;
		}
		
		public function getNote():String
		{
			return note;
		}
		
		
		public function findAncestorByClass( classname:Class ):Composite
		{
			var p:Composite = parent;
			while ( p ) {
				if ( p is classname )
					return p;
				p = p.parent;
			}
			return null;
		}
		
		public function findAncestorByName( name:String ):Composite
		{
			var p:Composite = parent;
			while ( p ) {
				if ( p.name === name )
					return p;
				p = p.parent;
			}
			return null;
		}
		
		
			// -- private --
			
			private static var _nextId:uint = 0;
			
			private var _id:int = BNode._nextId++;
			
			
			
	}

}