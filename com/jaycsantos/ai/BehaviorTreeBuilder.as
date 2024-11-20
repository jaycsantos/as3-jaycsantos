package com.jaycsantos.ai
{
	import com.jaycsantos.ai.bt.*;
	import com.jaycsantos.ai.bt.decor.*;
	/**
	 * Helper to build a behavior tree design
	 * 
	 * @author jaycsantos.com
	 */
	public class BehaviorTreeBuilder
	{
		
		public function BehaviorTreeBuilder()
		{
			
		}
		
		public function addDecor( deco:Class, task:Class, taskArgs:Array = null ):BehaviorTreeBuilder
		{
			if ( _depth.length && ! _depth[0] is ICompositeNode )
				throw new Error("[com.jaycsantos.ai.BehaviorTreeBuilder::addDecorator] cannot add child to a non composite parent");
			
			var node:AbstractDecorNode = new deco( new task(taskArgs) );
			if ( _depth.length )
				ICompositeNode( _depth[0] ).add( node );
			_depth.unshift( node );
			
			return this;
		}
		
		public function addComposite( task:Class, args:Array = null ):BehaviorTreeBuilder
		{
			if ( ! _depth[0] is ICompositeNode )
				throw new Error("[com.jaycsantos.ai.BehaviorTreeBuilder::addComposite] cannot add child to a non composite parent");
			
			var node:IBehaviorNode = new task( args );
			ICompositeNode( _depth[0] ).add( node );
			_depth.unshift( node );
			
			return this;
		}
		
		public function add( node:IBehaviorNode ):BehaviorTreeBuilder
		{
			if ( ! _depth[0] is ICompositeNode )
				throw new Error("[com.jaycsantos.ai.BehaviorTreeBuilder::addComposite] cannot add child to a non composite parent");
			
			ICompositeNode( _depth[0] ).add( node );
			_depth.unshift( node );
			
			return this;
		}
		
		
		public function weight( value:int ):BehaviorTreeBuilder
		{
			_depth[0].weight = value;
			
			return this;
		}
		
		public function end():BehaviorTreeBuilder
		{
			if ( _depth.length <= 1 )
				throw new Error( "[com.jaycsantos.ai.BehaviorTreeBuilder::end] Can no longer end(), root of tree is reached" );
			
			return this;
		}
		
		public function endBuild():IBehaviorNode
		{
			_depth.splice( 0, _depth.length - 1 );
			return _depth[ 0 ];
		}
		
		
			// -- private --
			
			private var _depth:Vector.<IBehaviorNode> = new Vector.<IBehaviorNode>();
			
	}

}