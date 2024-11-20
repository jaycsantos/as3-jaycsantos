package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class CallbackNode extends BNode implements IActionNode 
	{
		
		public static const CALLBACK:String = "callback";
		
		behavior var callback:Function;
		
		
		public function CallbackNode() 
		{
			
		}
		
		override public function execute():int 
		{
			return callback();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			callback = null;
		}
		
		
		
	}

}