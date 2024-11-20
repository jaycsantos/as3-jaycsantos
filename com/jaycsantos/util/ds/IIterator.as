package com.jaycsantos.util.ds 
{
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public interface IIterator 
	{
		function get current():*;
		function start():void;
		function end():void;
		function next():*;
		function hasNext():Boolean;
		function previous():*;
		function hasPrevious():Boolean;
		function remove():Boolean;
	}
	
}