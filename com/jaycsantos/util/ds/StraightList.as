package com.jaycsantos.util.ds 
{
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class StraightList implements IList
	{
		use namespace linklist;
		
		public function get item():*
		{
			return _current ? _current.item : undefined;
		}
		public function set item( value:* ):void
		{
			if ( _current )
				_current.item = value;
		}
		
		public function get size():uint
		{
			return _size;
		}
		
		
		public function StraightList( list:Array = null )
		{
			if ( list && list.length )
				for each( var item:* in list )
					add( item );
		}
		
		public function add( item:* ):*
		{
			_add( new ListNode(item) );
			return item;
		}
		
		public function remove():*
		{
			var n:ListNode = _current;
			if ( ! n ) return undefined;
			var item:* = n.item;
			
			if ( n && n.next )
				_current = n.next;
			else
				_current = null;
			if ( n == _bottom )
				_bottom = _current;
			n.dispose();
			
			_size--;
			
			return item;
		}
		
		public function dispose():void
		{
			var node:ListNode;
			_current = _bottom;
			
			while ( _current ) {
				node = _current;
				_current = node.next;
				node.dispose();
			}
			_size = 0;
			
			_bottom = null;
			_current = null;
		}
		
		public function first():Boolean
		{
			_current = _bottom;
			return _current ? true : false;
		}
		
		public function next():Boolean
		{
			if ( ! _current )
				return false;
			if ( ! _current.next )
				return false;
			
			_current = _current.next;
			return true;
		}
		
		public function find( item:* ):Boolean
		{
			var n:ListNode = _bottom;
			while( n ) {
				if ( n.item === item ) {
					_current = n; break;
				}
				n = n.next;
			}
			
			return Boolean( n );
		}
		
		
			// -- private --
			
			linklist var _bottom:ListNode;
			linklist var _current:ListNode;
			linklist var _size:uint = 0;
			
			linklist function _add( n:ListNode ):void
			{
				if ( ! _bottom )
					_bottom = n;
				else if ( ! _current )
					_current = _bottom;
				
				if ( _current ) {
					if ( _current.next )
						n.next = _current.next;
					_current.next = n;
				}
				_current = n;
				_size++;
			}
			
	}

}