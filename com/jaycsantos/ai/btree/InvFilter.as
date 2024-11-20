package com.jaycsantos.ai.btree 
{
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class InvFilter extends Filter 
	{
		/**
		 * [property:Boolean] pauses the node or not (resets) after filter callback fails
		 */
		public static const SUSPEND:String = "suspend";
		
		public static const RESULT_REF:String = "_result";
		
		
		public function InvFilter() 
		{
			
		}
		
		override public function execute():int 
		{
			var r:int = Math.min( - _result.value, 1 );
			if ( r != 0 ) {
				if ( r < 0 && ! suspend )
					restart();
				return r;
			}
			
			return node.execute();
		}
		
		
	}

}