package com.jaycsantos.display.animation 
{
	import com.jaycsantos.game.IGameObject;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public interface IAnimator extends IGameObject
	{
		function get playing():Boolean
		function set playing( value:Boolean ):void
		function get sequence():Vector.<uint>
		function get setName():String
		function get index():uint
		function get length():uint
		function get frame():uint
		
		function addIndexScript( index:uint, callback:Function, sequenceSet:String = null ):void
		function addSequenceSet( name:String, sequence:Vector.<uint>, framespeed:uint = 0, loop:Boolean = false, onComplete:Function = null, onInterupt:Function = null ):void
		
		function replay():void
		function playAt( index:uint ):void
		function stopAt( index:uint ):void
		function playSet( name:String ):void
		function replaySet( name:String ):void
		function appendSet( name:String ):void
	}
	
}