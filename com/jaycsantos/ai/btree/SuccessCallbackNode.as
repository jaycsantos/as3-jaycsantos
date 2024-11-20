package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class SuccessCallbackNode extends CallbackNode 
	{
		public static const CALLBACK:String = "callback";
		
		
		public function SuccessCallbackNode() 
		{
			
		}
		
		override public function execute():int 
		{
			callback();
			return 1;
		}
		
	}

}