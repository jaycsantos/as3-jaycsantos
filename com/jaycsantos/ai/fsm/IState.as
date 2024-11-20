package com.jaycsantos.ai.fsm
{
	import com.jaycsantos.entity.IDisposable;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public interface IState extends IDisposable
	{
		
		function get owner():*;
		function set owner( theOwner:* ):void;
		
		function enter():void;
		function update():void;
		function exit():void;
		
	}

}