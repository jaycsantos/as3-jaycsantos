package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class InvResultNode extends ResultNode 
	{
		public static const RESULT_REF:String = "_result";
		
		
		public function InvResultNode() 
		{
			
		}
		
		override public function execute():int 
		{
			return Math.min( - _result.value, 1 );
		}
		
	}

}