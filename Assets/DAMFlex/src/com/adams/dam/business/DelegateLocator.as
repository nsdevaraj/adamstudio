package com.adams.dam.business
{
	import com.adams.dam.business.delegates.AuthenticationDelegate;
	import com.adams.dam.business.delegates.CategoriesDAODelegate;
	import com.adams.dam.business.delegates.FileDetailsDAODelegate;
	import com.adams.dam.business.delegates.FileUploadDownloadDelegate;
	import com.adams.dam.business.delegates.PersonsDAODelegate;
	import com.adams.dam.business.delegates.ProjectsDAODelegate;
	import com.adams.dam.business.interfaces.IDAODelegate;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
    public class DelegateLocator
    {
    	private static var instance:DelegateLocator;
		public static function getInstance():DelegateLocator {
			if( !instance ) {
				instance = new DelegateLocator();
			}
			return instance;
		}
		
		public function DelegateLocator()
		{
			if( instance ) {
				throw new CairngormError( CairngormMessageCodes.SINGLETON_EXCEPTION, "DelegateLocator" );
			}
			else {
				instance = this;
			}
		}
		
		public var authenticationDelegate:IDAODelegate = new AuthenticationDelegate();
		public var fileDetailsDelegate:IDAODelegate = new FileDetailsDAODelegate();
		public var personsDelegate:IDAODelegate = new PersonsDAODelegate();
		public var projectsDelegate:IDAODelegate = new ProjectsDAODelegate();
		public var categoriesDelegate:IDAODelegate = new CategoriesDAODelegate();
		public var fileUpDownDelegate:IDAODelegate = new FileUploadDownloadDelegate();
	}
}