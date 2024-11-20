package com.jaycsantos.util.ds 
{
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public interface IList 
	{
		function get item():*
		function set item( value:* ):void
		function get size():uint;
		
		function remove():*
		function dispose():void
		function first():Boolean
		function next():Boolean
		function find( item:* ):Boolean
	}
	
}