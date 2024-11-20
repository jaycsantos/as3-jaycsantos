package com.jaycsantos.util 
{
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class FlagsAndDispatch extends Flags 
	{
		
		public function FlagsAndDispatch() 
		{
			
		}
		
		public function addCallback( flag:uint, callback:Function ):void
		{
			
		}
		
		
			// -- private --
			
			protected var _callbacks:Vector.<Vector.<Function>> = new Vector.<Vector.<Function>>();
	}

}