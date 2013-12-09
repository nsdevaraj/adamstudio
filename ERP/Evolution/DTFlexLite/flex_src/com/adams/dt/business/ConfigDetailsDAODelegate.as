package com.adams.dt.business
{ 
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.UserSQLStatements;
	import com.ericfeminella.sql.PreparedStatement;
	import com.ericfeminella.sql.dao.DecryptAbstractSynchronizedSQLDAO;
	import com.ericfeminella.sql.utils.SQLConnectionHelper;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

 
	public class ConfigDetailsDAODelegate extends DecryptAbstractSynchronizedSQLDAO
	{

		public var model : ModelLocator = ModelLocator.getInstance();
		public function ConfigDetailsDAODelegate()
		{
			var configDb:File =File.applicationDirectory.resolvePath("config.db"); 
			var databaseFile:File = configDb;
			var connection:SQLConnection = SQLConnectionHelper.getConnection( configDb.nativePath );
			super( connection, databaseFile );
			//loadSource();
		}
		
		private var _dataLoader:URLLoader;
		private var _dataRequest:URLRequest;
		private function loadSource():void {
			_dataLoader = new URLLoader()
			_dataRequest = new URLRequest("prefix.txt");
			_dataLoader.addEventListener(Event.COMPLETE, onDataLoaded,false,0,true);
			_dataLoader.load(_dataRequest);
		}
		
		private function onDataLoaded(evt:Object):void {
		 	model.prefixProjectName = _dataLoader.data;
		}
		public function getAllConfigDetails(): SQLResult
		{
			return executeStatement( new PreparedStatement( "SELECT * FROM config", connection ) );		
		}  
	}
}