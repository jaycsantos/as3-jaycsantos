package com.jaycsantos.util.ds 
{
	/**
	 * ...
	 * @author ...
	 */
	public class WListNode extends ListNode 
	{
		public var weight:Number = 0;
		
		public function WListNode( theItem:*, weight:Number = 0 )
		{
			super( theItem );
			this.weight = weight;
		}
		
	}

}