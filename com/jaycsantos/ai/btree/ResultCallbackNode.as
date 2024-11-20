package com.jaycsantos.ai.btree 
{
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class ResultCallbackNode extends ResultNode 
	{
		public static const CALLBACK:String = "_callback";
		public static const RESULT_REF:String = "_result";
		
		
		public function ResultCallbackNode() 
		{
			
		}
		
		override public function execute():int 
		{
			_callback();
			return _result.value;
		}
		
		behavior var _callback:Function;
		
	}

}