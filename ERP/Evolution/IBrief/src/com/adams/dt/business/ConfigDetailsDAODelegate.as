package com.adams.dt.business
{ 
	import com.adams.dt.model.vo.VOUserSQLStatements;
	import com.sqllite.sql.PreparedStatement;
	import com.sqllite.sql.dao.DecryptAbstractSynchronizedSQLDAO;
	import com.sqllite.sql.utils.SQLConnectionHelper;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.filesystem.File;

 
	public class ConfigDetailsDAODelegate extends DecryptAbstractSynchronizedSQLDAO
	{

		protected var statements:VOUserSQLStatements;
		public function ConfigDetailsDAODelegate()
		{
			var configDb:File =File.applicationDirectory.resolvePath("config.db"); 
			var databaseFile:File = configDb;
			var connection:SQLConnection = SQLConnectionHelper.getConnection( configDb.nativePath );
			super( connection, databaseFile );
			
			this.statements = new VOUserSQLStatements( connection );
          	var res: SQLResult = this.executeStatement( statements.createUserTable );

		}

		public function getAllConfigDetails(): SQLResult
		{
			return executeStatement( new PreparedStatement( "SELECT * FROM config", connection ) );		
		}  
	}
}