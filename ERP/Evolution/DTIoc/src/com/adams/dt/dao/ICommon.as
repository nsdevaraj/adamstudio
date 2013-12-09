package com.adams.dt.dao
{
	import com.adams.dt.model.vo.IValueObject;
	import mx.rpc.AsyncToken;
	
	public interface ICommon 
	{
		function extracreate( vo:IValueObject ): AsyncToken;
	}
}