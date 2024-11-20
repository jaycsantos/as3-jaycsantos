package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class RepeaterInf extends Repeater 
	{
		
		public function RepeaterInf() 
		{
			
		}
		
		override public function execute():int 
		{
			var r:int = node.execute();
			if ( r < 0 )
				restart();
			
			return 0;
		}
		
	}

}