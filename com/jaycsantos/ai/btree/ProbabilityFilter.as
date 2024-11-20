package com.jaycsantos.ai.btree 
{
	import com.jaycsantos.util.GameLoop;
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class ProbabilityFilter extends CallbackFilter
	{
		/**
		 * [property:int] The time gap (milliseconds) in which to run the probability again
		 */
		public static const DURATION:String = "duration";
		
		
		// -- internal --
		
		behavior var duration:int = 10000;
		
		
		/**
		 * A decorator filter than execute its child node
		 * depending on chances and duration gap.
		 */
		public function ProbabilityFilter() 
		{
			callback = _runProbability;
		}
		
		
			// -- private --
			
			private var _wait:int = 0;
			private var _last:int = 0;
			
			private function _runProbability():int
			{
				_wait -= GameLoop.deltaTime;
				
				if ( _wait <= 0 ) {
					if ( weight < Math.random() )
						_last = 0;
					else
						_last = -1;
					_wait += duration;
				}
				
				return _last;
			}
			
			
	}

}