package com.jaycsantos.util.ds
{
	import com.jaycsantos.util.ns.ns_linkedlist;
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class LinkedList
	{
		use namespace ns_linkedlist;
		
		public function get size():uint
		{
			return _size;
		}
		
		public function get first():LinkedNode
		{
			if ( _first ) return _first;
			return null;
		}
		
		public function get last():LinkedNode
		{
			if ( _last ) return _last;
			return null;
		}
		
		
		public function LinkedList()
		{
			
		}
		
		public function add( item:* ):void
		{
			addLast( item );
		}
		
		public function addFirst( item:* ):void
		{
			_addNodeFirst( new LinkedNode(item) );
		}
		
		public function addLast( item:* ):void
		{
			_addNodeLast( new LinkedNode(item) );
		}
		
		public function removeFirst( item:* ):*
		{
			if ( ! _first ) return undefined;
			var node:LinkedNode = _first;
			__removeNode( _first );
			return node;
		}
		
		public function removeLast( item:* ):*
		{
			if ( ! _last ) return undefined;
			var node:LinkedNode = _last;
			__removeNode( _last );
			return node;
		}
		
		public function has( item:* ):Boolean
		{
			return _firstNodeOf( item ) != null;
		}
		
		public function remove( item:* ):Boolean
		{
			var node:LinkedNode = _firstNodeOf( item );
			if ( ! node ) return false;
			__removeNode( node );
			return true;
		}
		
		public function emptyList():void
		{
			_first = _last = null;
			_size = 0;
		}
		
		
		public function reverse():Boolean
		{
			if ( _size < 2 ) return false;
			
			var node:LinkedNode = _last;
			var left:LinkedNode;
			var right:LinkedNode;
			
			while ( node ) {
				left = node.left;
				if ( ! node.right ) {
					node.right = node.left;
					node.left = null;
					_first = node;
					
				} else if ( ! node.left ) {
					node.left = node.right;
					node.right = null;
					_last = node;
					
				} else {
					right = node.right;
					node.right = node.left;
					node.left = right;
				}
				node = left;
			}
			
			return true;
		}
		
		public function sort( heuristic:IComparator, algorithm:String = "mergeSort" ):Boolean
		{
			if ( _size < 2 ) return false;
			
			_mergeSort( heuristic );
			
			return true;
		}
		
		
			// -- private --
			
			protected var _size:uint = 0;
			protected var _first:LinkedNode;
			protected var _last:LinkedNode;
			
			
			protected function _firstNodeOf( item:* ):LinkedNode
			{
				var node:LinkedNode = _first;
				while( node )
					if ( item === node.item ) return node;
					else node = node.right;
				return null;
			}
			
			protected function _addNodeFirst( node:LinkedNode ):void
			{
				if ( ! _first ) {
					_first = _last = node;
					_size = 1;
					
				} else {
					_first.left = node;
					node.right = _first;
					_first = node;
					++_size;
				}
			}
			
			protected function _addNodeLast( node:LinkedNode ):void
			{
				if ( ! _first ) {
					_first = _last = node;
					_size = 1;
					
				} else {
					_last.right = node;
					node.left = _last;
					_last = node;
					++_size;
				}
			}
			
			ns_linkedlist function __addNodeBefore( node:LinkedNode, next:LinkedNode = null ):void
			{
				if ( ! next )
					return _addNodeLast( node );
				
				// is the first
				if ( ! next.left ) _first = node;	
				
				node.left = next.left;
				node.right = next;
				if ( next.left ) next.left.right = node;
				next.left = node;
				
				++_size;
			}
			
			ns_linkedlist function __addNodeAfter( node:LinkedNode, previous:LinkedNode = null ):void
			{
				if ( ! previous )
					return _addNodeFirst( node );
				
				// is the last
				if ( ! previous.right ) _last = node;
				
				node.left = previous;
				node.right = previous.right;
				if ( previous.right ) previous.right.left = node;
				previous.right = node;
				
				++_size;
			}
			
			ns_linkedlist function __removeNode( node:LinkedNode ):void
			{
				if ( node.left )
					node.left.right = node.right;
				else
					_first = node.right;
				
				if ( node.right )
					node.right.left = node.left;
				else
					_last = node.left;
				
				--_size;
			}
			
			
			protected function _mergeSort( heuristic:IComparator ):void
			{
				var h:LinkedNode = _first;
				var p:LinkedNode, q:LinkedNode, e:LinkedNode, tail:LinkedNode;
				var insize:int = 1, nmerges:int, psize:int, qsize:int, i:int;

				while( true ) {
					p = h;
					h = tail = null;
					nmerges = 0;
					
					while( p ) {
						nmerges++;
						for ( i = 0, psize = 0, q = p; i < insize; i++ ) {
							psize++;
							q = q.right;
							if (!q) break;
						}
						qsize = insize;

						while( psize > 0 || (qsize > 0 && q) ) {
							if ( psize == 0 ) {
								e = q; q = q.right; qsize--;
							} else if ( qsize == 0 || !q ) {
								e = p; p = p.right; psize--;
							} else if ( heuristic.compare(p.item, q.item) <= 0 ) {
								e = p; p = p.right; psize--;
							} else {
								e = q; q = q.right; qsize--;
							}
							
							if ( tail ) tail.right = e;
							else h = e;
							
							e.left = tail;
							tail = e;
						}
						p = q;
					}
					
					_first.left = tail;
					tail.right = null;
					if ( nmerges <= 1 ) break;
					
					insize <<= 1;
				}
				_last = tail;
				_first = h;
			}
			
			
	}

}