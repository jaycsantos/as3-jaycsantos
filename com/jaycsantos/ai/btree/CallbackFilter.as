package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class CallbackFilter extends Decorator
	{
		/**
		 * [property:Boolean] pauses the node or not (resets) after filter callback fails
		 */
		public static const SUSPEND:String = "suspend";
		
		/**
		 * [property] A function to decide if child node must be executed or not.
		 * Must return an integer: 0 to continue, -1 or less to bail out.
		 */
		public static const CALLBACK:String = "callback";
		
		
		// -- internal --
		
		behavior var suspend:Boolean = false;
		
		behavior var callback:Function;
		
		
		/**
		 * A decorator that can uses an external function to 
		 * determine the conditions to execute the child node.
		 */
		public function CallbackFilter()
		{
			callback = function():int { return 0; };
		}
		
		override public function execute():int 
		{
			var r:int = callback();
			if ( r != 0 ) {
				if ( r < 0 && ! suspend )
					restart();
				return r;
			}
			
			return node.execute();
		}
		
	}

}