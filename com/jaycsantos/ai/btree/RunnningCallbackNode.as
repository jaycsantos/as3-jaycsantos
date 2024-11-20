package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class RunnningCallbackNode extends CallbackNode
	{
		public static const CALLBACK:String = "callback";
		
		
		public function RunnningCallbackNode() 
		{
			
		}
		
		override public function execute():int 
		{
			callback();
			return 0;
		}
		
	}

}