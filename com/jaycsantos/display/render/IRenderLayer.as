package com.jaycsantos.display.render 
{
	import com.jaycsantos.game.IGameObject;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public interface IRenderLayer extends IGameObject
	{
		function addRender( render:AbstractRender ):AbstractRender;
		
		function removeRender( render:AbstractRender ):AbstractRender;
		
	}
	
}