package com.jaycsantos.ai.btree 
{
	use namespace behavior;
	
	/**
	 * ...
	 * @author jaycsantos.com
	 */
	public class Parallel extends Composite 
	{
		public static const SUCCEED_QUOTA:String = "succeedQuota";
		public static const FAIL_QUOTA:String = "failQuota";
		
		// -- internal --
		
		behavior var succeedQuota:uint = 1;
		
		behavior var failQuota:uint = 1;
		
		
		/**
		 * A composite that executes its child nodes at the same time.
		 * Failures and success is determined by its quota.
		 */
		public function Parallel() 
		{
			
		}
		
		
		override public function execute():int 
		{
			var s:uint = 0, f:uint = 0;
			var r:int = 0, fr:int = 0, sr:int = 0;
			
			for each( var node:BNode in _nodeMap ) {
				r = node.execute();
				
				// fail
				if ( r < 0 ) {
					f++;
					if ( r < fr ) fr = r;
					
				// succeess
				} else if ( r > 0 ) {
					s++;
					if ( r > sr ) sr = r;
				}
			}
			
			// meet the quota
			if ( f >= failQuota ) return fr;
			else if ( s >= succeedQuota ) return sr;
			
			// pending
			return 0;
		}
		
		
	}

}