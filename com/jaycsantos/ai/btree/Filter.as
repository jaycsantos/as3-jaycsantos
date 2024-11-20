package com.jaycsantos.ai.btree 
{
	import com.jaycsantos.util.ds.IntRef;
	use namespace behavior
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class Filter extends Decorator 
	{
		/**
		 * [property:Boolean] pauses the node or not (resets) after filter callback fails
		 */
		public static const SUSPEND:String = "suspend";
		
		public static const RESULT_REF:String = "_result";
		
		
		// -- internal --
		
		behavior var suspend:Boolean = false;
		
		
		public function Filter() 
		{
			
		}
		
		override public function execute():int 
		{
			var r:int = _result.value;
			if ( r != 0 ) {
				if ( r < 0 && ! suspend )
					restart();
				return r;
			}
			
			return node.execute();
		}
		
		
		public function success( ...args ):void
		{
			_result.value = 1;
		}
		
		public function fail( ...args ):void
		{
			_result.value = -1;
		}
		
		public function running( ...args ):void
		{
			_result.value = 0;
		}
		
		
			// -- private --
			
			behavior var _result:IntRef = new IntRef;
			
	}

}