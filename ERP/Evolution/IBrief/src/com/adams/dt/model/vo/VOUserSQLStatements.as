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
	import com.sqllite.sql.ISQLStatementCache;
	import com.sqllite.sql.PreparedStatement;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	
	/**
	 * Prepares SQLStatements for executing statements as fast as possible
	 * 
	 * 
	 */
	public class VOUserSQLStatements implements ISQLStatementCache
	{
		public var createUserTable: SQLStatement;
		public var addUser: SQLStatement;
		public var getAllUsers: SQLStatement;
		public var updateUser: SQLStatement;
		public var deleteUser: SQLStatement;
		public var getUser: SQLStatement;
		public var getSwfFile: SQLStatement;
		
		
		public function VOUserSQLStatements( connection:SQLConnection )
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
            	
		}
	}
}
