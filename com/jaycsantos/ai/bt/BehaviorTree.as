package com.jaycsantos.ai.bt 
{
	import com.jaycsantos.ai.bt.decor.*;
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class BehaviorTree
	{
		public static const SEQUENCE_NODE:Class = SequenceNode;
		public static const PARALLEL_NODE:Class = ParallelNode;
		public static const SELECTOR_PRIORITY_NODE:Class = SelectorPriorityNode;
		public static const SELECTOR_PROBABILITY_NODE:Class = SelectorProbability;
		
		public static const DECOR_ERRHANDLING_NODE:Class = ErrHandlingDecor;
		public static const DECOR_REPEATING_NODE:Class = RepeatingDecor;
		
		public static const ACTION_COMPLETE:int = 1;
		public static const ACTION_RUNNING:int = 0;
		public static const ACTION_FAIL:int = -1;
		public static const ACTION_ERROR:int = -2;
		
		
		public class BehaviorTree()
		{
			throw new Error("[com.jaycsantos.ai.BehaviorTree::constructor] Please do not create an instance of this static class");
		}
	}

}