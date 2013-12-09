package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public interface IResponderAware
	{
	  function set responder(value:IResponder):void;
	}
}