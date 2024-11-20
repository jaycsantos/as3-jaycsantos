package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class FailCallbackNode extends CallbackNode 
	{
		public static const CALLBACK:String = "callback";
		
		
		public function FailCallbackNode() 
		{
			
		}
		
		override public function execute():int 
		{
			callback();
			return -1;
		}
		
	}

}