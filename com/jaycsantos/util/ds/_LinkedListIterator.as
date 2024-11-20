package com.jaycsantos.util.ds 
{
	import com.jaycsantos.entity.IDisposable;
	import com.jaycsantos.util.ds.IIterator;
	import com.jaycsantos.util.ns.ns_linkedlist;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class LinkedListIterator implements IDisposable, IIterator
	{
		public function get current():*
		{
			if ( _current )
				return _current.item;
			return undefined;
		}
		
		public function get list():LinkedList
		{
			return _list;
		}
		public function set list( value:LinkedList ):void
		{
			if ( _list === value ) return;
			
			_list = value;
			_current = value.first;
			_indexCount = 0;
		}
		
		public function get index():uint
		{
			return _indexCount;
		}
		
		
		public function LinkedListIterator( list:LinkedList = null )
		{
			if ( list )
				this.list = list;
		}
		
		public function start():void
		{
			_current = _list.first;
			_indexCount = 0;
		}
		
		public function end():void
		{
			_current = _list.last;
			if ( _current )
				_indexCount = _list.size - 1;
		}
		
		public function next():*
		{
			if ( ! _current || ! _current.right ) return undefined;
			
			_current = _current.right;
			_indexCount++;
			
			return _current.item;
		}
		
		public function previous():*
		{
			if ( ! _current || ! _current.left ) return undefined;
			
			_current = _current.left;
			_indexCount--;
			
			return _current.item;
		}
		
		public function hasNext():Boolean
		{
			return _current && _current.right != null;
		}
		
		public function hasPrevious():Boolean
		{
			return _current && _current.left != null;
		}
		
		public function remove():Boolean
		{
			if ( ! _current ) return false;
			
			_current = _current.left;
			_list.ns_linkedlist::__removeNode( _current.right );
			
			return true;
		}
		
		public function replace( item:* ):Boolean
		{
			if ( ! _current || _current.item === item ) return false;
			
			_current.item = item;
			return true;
		}
		
		
		public function dispose():void
		{
			_list = null;
			_current = null;
		}
		
		
			// -- private --
			
			protected var _list:LinkedList;
			protected var _current:LinkedNode;
			protected var _indexCount:uint;
			
	}

}