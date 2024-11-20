package com.jaycsantos.util 
{
	import com.jaycsantos.util.ns.nsFlag;
	
	/**
	 * ...
	 * @author jaycsantos
	 */
	public class Flags
	{
		public function Flags( defaultValue:uint = 0 )
		{
			_flag = defaultValue;
		}
		
		public function isTrue( theFlag:uint ):Boolean
		{
			return ( _flag & theFlag ) > 0;
		}
		
		public function isFalse( theFlag:uint ):Boolean
		{
			return ( _flag & theFlag ) == 0;
		}
		
		public function setTrue( theFlag:uint ):void
		{
			_flag |= theFlag;
		}
		
		public function setFalse( theFlag:uint ):void
		{
			_flag &= ~theFlag;
		}
		
		
		public function isFlag( theFlag:uint, bool:Boolean ):Boolean
		{
			if ( bool )
				return ( _flag & theFlag ) > 0;
			else
				return ( _flag & theFlag ) == 0;
		}
		
		public function setFlag( theFlag:uint, bool:Boolean ):Boolean
		{
			if ( bool )
				_flag |= theFlag;
			else
				_flag &= ~theFlag;
			return bool;
		}
		
		
		public function toggle( theFlag:uint ):Boolean
		{
			if ( (_flag & theFlag) > 0 ) {
				_flag &= ~theFlag;
				return false;
			}
			_flag |= theFlag;
			
			return true;
		}
		
		
		public function get value():uint
		{
			return _flag;
		}
		
		
		public function toString():String
		{
			return _flag.toString(2);
		}
		
		
			// -- private --
			
			private var _flag:uint = 0;
		
	}

}