package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class LessFailFilter extends Decorator 
	{
		public static const FAIL_BASE_VALUE:String = "failBaseValue";
		public static const REDUCE_BY:String = "reduceBy";
		
		// -- internal --
		
		behavior var failBaseValue:int;
		
		behavior var reduceBy:uint;
		
		
		/**
		 * A decorator that returns a lessen search fail value. Can also be 
		 * used to disregard child node failures (failBaseValue = 0, reduceBy = 10++)
		 */
		public function LessFailFilter()
		{
			
		}
		
		override public function execute():int 
		{
			var r:int = node.execute();
			if ( r < failBaseValue )
				r = Math.min( failBaseValue, r - reduceBy );
			
			return r;
		}
		
		
	}

}