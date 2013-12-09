/**
 * 
 * Swiz example based on Adobe AIR and SQLite
 * 
 * @author 		Jens Krause [www.websector.de]    
 * @date  		01/07/09
 * @see   		http://www.websector.de/blog/     
 * 
 * 
*/
package com.adams.dt.model.vo
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
		public var getSwfFile: SQLStatement;
		public var getIndFile: SQLStatement;
		
		public function UserSQLStatements( connection:SQLConnection )
		{
			var sql: String;
			
			sql = "CREATE TABLE IF NOT EXISTS file  (" 
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
            
			sql = "INSERT INTO file "
				+ "VALUES(NULL,?,?,?,?,?,?,?,?,?)";
			addUser = new PreparedStatement( sql, connection, FileDetails );		
			
			sql = "SELECT * FROM file";
			getAllUsers = new PreparedStatement( sql, connection );
				
			sql = "SELECT * FROM file where remoteFileFk=? and storedFileName=?";
			getUser = new PreparedStatement( sql, connection,FileDetails );
			
			sql = "SELECT * FROM file where miscelleneous=? and remoteFileFk!=? order by page";
			getSwfFile = new PreparedStatement( sql, connection,FileDetails );
			
			sql = "SELECT * FROM file where miscelleneous=? and remoteFileFk=? order by page";
			getIndFile = new PreparedStatement( sql, connection,FileDetails );
			
			sql = "UPDATE users "
				+ "SET fileName=?,storedFileName=?,filePath=?,taskId=?,categoryFK=?,projectFK=?, remoteFileFk=?, miscellaneous=?, page=?"
				+ "WHERE fileId=?";
			updateUser = new PreparedStatement( sql, connection, FileDetails );	
			
			sql = "DELETE FROM file "
				+ "WHERE fileId=?";
			deleteUser = new PreparedStatement( sql, connection, FileDetails );		
		}
	}
}
