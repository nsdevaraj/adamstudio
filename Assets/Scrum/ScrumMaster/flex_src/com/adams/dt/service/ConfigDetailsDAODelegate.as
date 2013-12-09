package com.adams.dt.service
{ 
	import com.adams.dt.model.vo.UserSQLStatements;
	import com.ericfeminella.sql.PreparedStatement;
	import com.ericfeminella.sql.dao.DecryptAbstractSynchronizedSQLDAO;
	import com.ericfeminella.sql.utils.SQLConnectionHelper;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.filesystem.File;
	public class ConfigDetailsDAODelegate extends DecryptAbstractSynchronizedSQLDAO
	{

		protected var statements:UserSQLStatements;
		public function ConfigDetailsDAODelegate()
		{
			var configDb:File =File.applicationDirectory.resolvePath("config.db"); 
			var databaseFile:File = configDb;
			var connection:SQLConnection = SQLConnectionHelper.getConnection( configDb.nativePath );
			super( connection, databaseFile );
			
			this.statements = new UserSQLStatements( connection );
          	var res: SQLResult = this.executeStatement( statements.createUserTable );

		}

		public function getAllConfigDetails(): SQLResult
		{
			return executeStatement( new PreparedStatement( "SELECT * FROM config", connection ) );		
		}  
	}
}