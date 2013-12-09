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

package com.sqllite.sql.dao
{
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.net.Responder;
	import flash.data.SQLConnection;
	
	/**
	 * 
	 * <code>AbstractAsynchronousSQLDAO</code> provides an abstraction of
	 * an asynchronous SQL DAO implementation.
	 * 
	 */
	public class AbstractAsynchronousSQLDAO extends AbstractSQLDAO
	{
		/**
		 *
		 * Defines the <code>Responder</code> instance which handles 
		 * <code>AbstractAsynchronousSQLDAO</code> SQL operation responses.
		 * 
		 * @see flash.net.Responder
		 * 
		 */		
		protected var _responder:Responder;

		/**
		 *
		 * <code>AbstractAsynchronousSQLDAO</code> constructor requires the 
		 * databasePath from which the database connection is made as well as 
		 * an optional <code>ISQLConnectionResponder</code> for handling the 
		 * connection response.
		 *  
		 * @param the path from which the database connection is made
		 * 
		 */		
		public function AbstractAsynchronousSQLDAO(connection:SQLConnection, databaseFile:File = null)
		{
		    super( connection );
		    
		    if ( !connection.connected )
		    {
		    	connection.openAsync( databaseFile, SQLMode.CREATE, new Responder( openResult, openFault ) );
		    }
		}
		
		/**
		 *
		 * Assigns a reference to the <code>Responder</code> instance which 
		 * handles SQL operation responses.
		 * 
		 * @see flash.net.Responder
		 * 
		 */		
		public function set responder(responder:Responder) : void
		{
			_responder = responder;
		}
		
		/**
		 *
		 * Retrieves a reference to the <code>Responder</code> instance which 
		 * handles SQL operation responses.
		 * 
		 * @return flash.net.Responder
		 * 
		 */			
		public function get responder() : Responder
		{
			return _responder;
		}
		
		/**
		 *
		 * Convenience method which executes a prepared SQL statement against a local
		 * SQL Lite database
		 *  
		 * @param SQL
		 * @param args
		 * 
		 */
		public function execute(statement:SQLStatement, ...parameters) : void
		{
			applyStatementParameters.apply( null, [ statement ].concat( parameters ) );

			statement.execute( 1, responder );
		}
	}
}
