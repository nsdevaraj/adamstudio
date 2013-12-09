package com.adams.scrum.models.vo
{
	import com.ericfeminella.sql.ISQLStatementCache;
	import com.ericfeminella.sql.PreparedStatement;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	
	/**
	 * Prepares SQLStatements for executing statements as fast as possible
	 * 
	 * 
	 */
	public class UserSQLStatements implements ISQLStatementCache
	{
		public var createUserTable: SQLStatement;
		public var addUser: SQLStatement;
		public var getAllUsers: SQLStatement;
		public var updateUser: SQLStatement;
		public var deleteUser: SQLStatement;
		public var getUser: SQLStatement;
		public var getSwfFiles: SQLStatement;
		public var getIndFiles: SQLStatement;
		
		public function UserSQLStatements( connection:SQLConnection )
		{
			var sql: String;
			
			sql = "CREATE TABLE IF NOT EXISTS Files  (" 
				+ "FilesId INTEGER PRIMARY KEY AUTOINCREMENT, "   
				+ "FilesName varchar(250), " 
				+ "storedFilesName varchar(250), "
				+ "FilesPath varchar(250), "
				+ "taskId int(11), "
				+ "categoryFK int(11), "
				+ "projectFK int(11), "
				+ "remoteFilesFk int(11),"
				+ "miscelleneous varchar(250)," 
				+ "page int(50))";
			createUserTable = new PreparedStatement( sql, connection );
			
			sql = "INSERT INTO Files "
				+ "VALUES(NULL,?,?,?,?,?,?,?,?,?)";
			addUser = new PreparedStatement( sql, connection, Files );		
			
			sql = "SELECT * FROM Files";
			getAllUsers = new PreparedStatement( sql, connection );
			
			sql = "SELECT * FROM Files where remoteFilesFk=? and storedFilesName=?";
			getUser = new PreparedStatement( sql, connection,Files );
			
			sql = "SELECT * FROM Files where miscelleneous=? and remoteFilesFk!=? order by page";
			getSwfFiles = new PreparedStatement( sql, connection,Files );
			
			sql = "SELECT * FROM Files where miscelleneous=? and remoteFilesFk=? order by page";
			getIndFiles = new PreparedStatement( sql, connection,Files );
			
			sql = "UPDATE users "
				+ "SET FilesName=?,storedFilesName=?,FilesPath=?,taskId=?,categoryFK=?,projectFK=?, remoteFilesFk=?, miscellaneous=?, page=?"
				+ "WHERE FilesId=?";
			updateUser = new PreparedStatement( sql, connection, Files );	
			
			sql = "DELETE FROM Files "
				+ "WHERE FilesId=?";
			deleteUser = new PreparedStatement( sql, connection, Files );		
		}
	}
}
