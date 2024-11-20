package com.jaycsantos.game 
{
	import com.jaycsantos.IDisposable;
	import com.jaycsantos.util.ds.LinkEntity;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public interface ICollisionCheck extends IDisposable
	{
		function update( list:LinkEntity ):void;
	}
	
}