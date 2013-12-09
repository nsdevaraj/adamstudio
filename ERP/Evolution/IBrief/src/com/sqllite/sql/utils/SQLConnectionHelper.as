/*
 Copyright (c) 2006 - 2008 Eric J. Feminella <eric@ericfeminella.com>
 All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 @internal
 */

package com.sqllite.sql.utils
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode
	import flash.filesystem.File;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * <code>SQLConnectionHelper</code> is an all static class which provides 
	 * a centralized location from which all <code>SQLConnection</code> instances
	 * can be managed and retrieved.
	 * 
	 * <p>
	 * <code>SQLConnectionHelper</code> utilizes the <code>nativePath</code> 
	 * property of a <code>File</code> object used to create the connection. 
	 * This is utilized to uniquely identify each cached <code>SQLConnection</code> 
	 * database instance within the connections map.
	 * </p>
	 * 
	 */	
	public class SQLConnectionHelper
	{
		/**
		 *
		 * Contains a mapping of each unique <code>SQLConnection</code> instance
		 *  
		 */		
		protected static const connections:Dictionary = new Dictionary();

		/**
		 *
		 * Retrieves a managed <code>SQLConnection</code> instance based on the
		 * unique name of the database, i.e. <code>File.nativePath</code>.
		 * 
		 * <p>
		 * Typically the unique name of the database is based on the <code>nativePath</code> 
		 * property <code>File</code> of the connections associated <code>File</code> object
		 * </p>
		 * 
		 * @example The following example demonstrates how <code>SQLConnectionHelper</code>
		 * can be utilized to retrieve a reference to a shared <code>SQLConnection</code>
		 * 
		 * <listing version="3.0">
		 * 
		 * var databasePath:String = File.userDirectory.nativePath + File.separator + "foo.db"
		 * var connection:SQLConnection = SQLConnectionHelper.getConnection( databasePath );
		 * 
		 * </listing>
		 * 
		 * @param   unique name of the <code>SQLConnection</code> database
		 * @return  managed <code>SQLConnection</code> instance
		 * 
		 */
		public static function getConnection(name:String) : SQLConnection
		{
			var connection:SQLConnection = connections[ name ];
			
			if ( connection == null )
			{
				connection = new SQLConnection();
				connections[ name ] = connection; 
			}
			return connection;
		}
		
		/**
		 *
		 * Closes the connection to the previously cached <code>SQLConnection</code>
		 * instance.
		 * 
		 * @example The following example demonstrates how <code>SQLConnectionHelper</code>
		 * can be utilized to close a shared <code>SQLConnection</code>
		 * 
		 * <listing version="3.0">
		 * 
		 * var databasePath:String = File.userDirectory.nativePath + File.separator + "foo.db"
		 * SQLConnectionHelper.close( databasePath );
		 * 
		 * </listing>
		 * 
		 * @param   The database path of the <code>SQLConnection</code>
		 * @throws  UnmanagedSQLConnectionException
		 * 
		 */		
		public static function close(databasePath:String) : void
		{
			var connection:SQLConnection = connections[ databasePath ];

			if ( connection != null )
			{
				if ( connection.connected && !connection.inTransaction )
				{
					connection.close();
				}				
			}
			else
			{
				throw new UnmanagedSQLConnectionException( databasePath );
			}
		}
	}
}
