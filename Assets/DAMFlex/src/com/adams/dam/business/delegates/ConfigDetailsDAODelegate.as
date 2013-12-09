package com.adams.dam.business.delegates
{ 
	import com.localSQL.PreparedStatement;
	import com.localSQL.dao.DecryptAbstractSynchronizedSQLDAO;
	import com.localSQL.utils.SQLConnectionHelper;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.filesystem.File;

	public class ConfigDetailsDAODelegate extends DecryptAbstractSynchronizedSQLDAO
	{
		public function ConfigDetailsDAODelegate()
		{
			var configDb:File = File.applicationDirectory.resolvePath( "config.db" ); 
			var databaseFile:File = configDb;
			var connection:SQLConnection = SQLConnectionHelper.getConnection( configDb.nativePath );
			super( connection, databaseFile );
		}
		
		public function getAllConfigDetails():SQLResult {
			return executeStatement( new PreparedStatement( "SELECT * FROM config", connection ) );		
		}  
	}
}