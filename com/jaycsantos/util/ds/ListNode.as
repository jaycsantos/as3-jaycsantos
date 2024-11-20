package com.jaycsantos.util.ds 
{
	import com.jaycsantos.IDisposable;
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class ListNode implements IDisposable
	{
		public var item:*;
		public var next:ListNode;
		public var prev:ListNode;
		
		public function ListNode( theItem:* )
		{
			item = theItem;
		}
		
		public function insert( theItem:* ):ListNode
		{
			var list:ListNode = new ListNode( theItem );
			
			if ( next ) {
				next.prev = list;
				list.next = next;
			}
			
			next = list;
			list.prev = this;
			
			return list;
		}
		
		public function dispose():void
		{
			if ( next )
				next.prev = prev;
			if ( prev )
				prev.next = next;
			
			item = null;
			next = null;
			prev = null;
		}
		
	}

}