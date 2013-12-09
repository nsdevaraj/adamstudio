package com.localSQL.dao
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
