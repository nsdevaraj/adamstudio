package com.adams.dam.model
{
	import com.adams.dam.business.utils.StringUtils;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.FileDetails;
	import com.localSQL.ISQLStatementCache;
	import com.localSQL.PreparedStatement;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	
	public class UserSQLStatements implements ISQLStatementCache
	{
		public var createUserTable:SQLStatement;
		public var addUser:SQLStatement;
		public var getAllUsers:SQLStatement;
		public var updateUser:SQLStatement;
		public var deleteUser:SQLStatement;
		public var getUser:SQLStatement;
		public var getSwfFile:SQLStatement;
		public var getIndFile:SQLStatement;
		
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance(); 
		
		public function UserSQLStatements( connection:SQLConnection )
		{
			var sql: String;
			var serverLocation:String = model.serverLocation; 
			serverLocation = StringUtils.getTableNameString( serverLocation );
			
			sql = "CREATE TABLE IF NOT EXISTS " + serverLocation + " (" 
				 + "fileId INTEGER PRIMARY KEY AUTOINCREMENT, "   
				 + "fileName varchar(250), " 
				 + "storedFileName varchar(250), "
				 + "filePath varchar(250), "
				 + "taskId int(11), "
				 + "categoryFK int(11), "
				 + "projectFK int(11), "
				 + "remoteFileFk int(11),"
				 + "miscelleneous varchar(250)," 
				 + "page int(50))";
			
			createUserTable = new PreparedStatement( sql, connection );
			
			sql = "INSERT INTO " + serverLocation + " VALUES(NULL,?,?,?,?,?,?,?,?,?)";
			addUser = new PreparedStatement( sql, connection, FileDetails );	
			
			sql = "SELECT * FROM " + serverLocation;
			getAllUsers = new PreparedStatement( sql, connection );
				
			sql = "SELECT * FROM " + serverLocation + " where remoteFileFk=? and storedFileName=?";
			getUser = new PreparedStatement( sql, connection,FileDetails );
			
			sql = "SELECT * FROM " + serverLocation + " where miscelleneous=? and remoteFileFk!=? order by page";
			getSwfFile = new PreparedStatement( sql, connection,FileDetails );
			
			sql = "SELECT * FROM " + serverLocation + " where miscelleneous=? and remoteFileFk=? order by page";
			getIndFile = new PreparedStatement( sql, connection,FileDetails );
			
			sql = "UPDATE " + serverLocation  
				+ " SET fileName=?,storedFileName=?,filePath=?,taskId=?,categoryFK=?,projectFK=?, remoteFileFk=?, miscellaneous=?, page=?"
				+ "WHERE fileId=?";
			updateUser = new PreparedStatement( sql, connection, FileDetails );	
			
			sql = "DELETE FROM " + serverLocation + " WHERE fileId=?";
			deleteUser = new PreparedStatement( sql, connection, FileDetails );		
		}
	}
}
