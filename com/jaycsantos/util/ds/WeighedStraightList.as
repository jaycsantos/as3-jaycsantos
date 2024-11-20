package com.jaycsantos.util.ds 
{
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class WeighedStraightList implements IList
	{
		use namespace linklist;
		
		public function get item():*
		{
			return _list.item;
		}
		public function set item( value:* ):void
		{
			_list.item = value;
		}
		
		public function get size():uint
		{
			return _list._size;
		}
		
		public function get weight():Number
		{
			return WListNode(_list._current).weight;
		}
		/* TODO setter for weight
		public function set weight( value:Number ):void
		{
			if ( ! _list._current )
				return;
			if ( WListNode(_list._current).weight == value )
				return;
			
		}*/
		
		
		public function WeighedStraightList( ascending:Boolean = false ) 
		{
			_asc = ascending;
			_list = new StraightList;
		}
		
		public function add( item:*, weight:Number ):*
		{
			var n:WListNode = new WListNode( item, weight );
			
			if ( _list._bottom ) {
				var p:WListNode = _list._bottom;
				
				// add before bottom
				if ( (n.weight - WListNode(p).weight) * (_asc ? 1 : -1) < 0 ) {
					n.next = _list._bottom;
					_list._bottom = n;
					
				// do the usual add after
				} else {
					while ( p.next && (WListNode(p.next).weight - n.weight) * (_asc ? 1 : -1) < 0 )
						if ( p.next )
							p = p.next;
						else
							break;
					_list._current = p;
					_list._add( n );
				}
				
			} else {
				_list._bottom = n;
			}
			_list._current = _list._bottom;
			
			return n.item;
		}
		
		public function remove():*
		{
			return _list.remove();
		}
		
		public function dispose():void
		{
			_list.dispose();
			_list = null;
		}
		
		public function first():Boolean
		{
			return _list.first();
		}
		
		public function next():Boolean
		{
			return _list.next();
		}
		
		public function find( item:* ):Boolean
		{
			return _list.find( item );
		}
		
		
			// -- private --
			
			linklist var _asc:Boolean;
			linklist var _list:StraightList;
			
	}

}