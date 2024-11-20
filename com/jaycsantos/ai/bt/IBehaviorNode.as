package com.jaycsantos.ai.bt 
{
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public interface IBehaviorNode 
	{
		function get weight():Number;
		function set weight( value:Number ):void;
		function execute():int;
		function dispose():void;
	}
	
}