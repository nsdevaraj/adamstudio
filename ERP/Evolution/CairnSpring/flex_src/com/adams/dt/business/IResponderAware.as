package com.adams.dt.business
{
	import mx.rpc.IResponder;
	
	/**
	 * interface IResponderAware
	 */
	public interface IResponderAware
	{
		/**
		 * interface responder method
		 * responder method to set the IResponder value
		 * return type void	 	 
	 	 */
	  	function set responder(value:IResponder):void;
	}
}