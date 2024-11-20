package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class Repeater extends Decorator 
	{
		/**
		 * A decorator that search through its child nodes
		 * until search fail regardless of success
		 */
		public function Repeater()
		{
			
		}
		
		override public function execute():int 
		{
			var r:int = node.execute();
			if ( r < 0 ) {
				restart();
				return r;
			}
			return 0;
		}
		
	}

}