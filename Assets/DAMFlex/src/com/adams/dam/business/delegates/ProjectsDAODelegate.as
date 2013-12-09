package com.adams.dam.business.delegates
{
	import com.adams.dam.business.Services;
	import com.adams.dam.business.interfaces.IDAODelegate;
	import com.adams.dam.model.vo.Persons;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	
	public final class ProjectsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function ProjectsDAODelegate( handlers:IResponder = null, service:String = '' )
		{
			super( handlers, Services.PROJECT_SERVICE );
		}
		
		override public function findPersonsList( person:IValueObject ):void {
			invoke( "findPersonsList", ( Persons( person ).personId ) );
		} 
	}
}
