package com.jaycsantos.ai.btree 
{
	import com.jaycsantos.util.ds.IntRef;
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class ResultNode extends BNode implements IActionNode 
	{
		
		public static const RESULT_REF:String = "_result";
		
		
		public function ResultNode()
		{
			
		}
		
		override public function execute():int 
		{
			return _result.value;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			_result = null;
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
			
			behavior var _result:IntRef = new IntRef(-1);
		
	}

}