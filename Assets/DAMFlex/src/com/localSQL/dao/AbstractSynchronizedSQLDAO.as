package com.localSQL.dao
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.data.SQLConnection;
	
	/**
	 * 
	 * <code>AbstractSynchronizedSQLDAO</code> provides an abstraction of
	 * a synchronized DAO SQL implementation.
	 * 
	 */
	public class AbstractSynchronizedSQLDAO extends AbstractSQLDAO
	{
		/**
		 *
		 * <code>AbstractSynchronizedSQLDAO</code> constructor requires the 
		 * databasePath from which the database connection is to be made.
		 *  
		 * @param path from which the <code>SQLConnection</code> is to be based
		 * 
		 */		
		public function AbstractSynchronizedSQLDAO(connection:SQLConnection, databaseFile:File = null)
		{
		    super( connection );

		    if ( !connection.connected )
		    {
		    	connection.addEventListener( SQLEvent.OPEN, openResult ,false,0,true);
		    	connection.addEventListener( SQLErrorEvent.ERROR, openFault ,false,0,true);
		    	connection.open( databaseFile );
		    }
		}
		
		/**
		 *
		 * Convenience method which executes a prepared SQL statement against a local
		 * SQL Lite database
		 *  
		 * @param <code>SQLStatement</code> instance which is to be executed
		 * @param parameters which are to be applied to the statement
		 * 
		 */
		protected function executeStatement(statement:SQLStatement, ...parameters) : SQLResult
		{
			applyStatementParameters.apply( null, [ statement ].concat( parameters ) );
			
			statement.execute();
            
            return statement.getResult();
		}
	}
}
