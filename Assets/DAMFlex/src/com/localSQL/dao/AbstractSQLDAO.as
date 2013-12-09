package com.localSQL.dao
{
	import com.localSQL.SQLStatementExecutionException;
	import com.localSQL.utils.SQLStatementHelper;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	
	/**
	 * 
	 * <code>AbstractSQLDAO</code> provides default abstract functionality 
	 * which is common amongst all SQLDAO implementations
	 * 
	 */	
	public class AbstractSQLDAO
	{
		/**
		 *
		 * Defines the <code>SQLConnection</code> instance from which all 
		 * <code>SQLStatements</code> are executed against.
		 * 
		 */		
		protected var connection:SQLConnection;
		
		/**
		 *
		 * <code>AbstractSQLDAO</code> constructor requires the databasePath from
		 * which the database connection is made.
		 *  
		 * @param <code>SQLConnection</code> to which this instance is bound
		 * 
		 */		
		public function AbstractSQLDAO(connection:SQLConnection)
		{
		    this.connection = connection;
		}
		
		/**
		 *
		 * Retrieves a reference to the <code>SQLConnection</code> instance
		 * in which the <code>AbstractSQLDAO</code> object is connected.
		 * 
		 * @return <code>SQLConnection</code> instance
		 * 
		 */		
		public function getConnection() : SQLConnection
		{
			return connection;
		}
		
		/**
		 *
		 * Convenience method which executes a prepares SQL statement for execution
		 * against a database
		 *  
		 * @param <code>SQLStatement</code> which is to be executed
		 * @param parameters which are to be added to the statements parameters
		 * 
		 */
		protected function applyStatementParameters(statement:SQLStatement, ...parameters) : void
		{
			if ( !statement.executing )
			{
				if ( statement.text.indexOf("?") > -1 )
				{
					SQLStatementHelper.applyUnnamedParameters.apply( null, [ statement ].concat( parameters ) );	
				}
			}
			else
			{
				throw new SQLStatementExecutionException();
			}
		}
				
		/**
		 * 
		 * Handles a <code>SQLEvent.OPEN</code> event which is dispatched 
		 * when a <code>SQLConnection.open()</code> method call completes 
		 * successfully.
		 * 
		 * @param <code>SQLEvent</code> instance which was dispatched
		 * 
		 */	
		protected function openResult(event:SQLEvent) : void
		{
		}
		
		/**
		 * 
		 * Handles a <code>SQLEvent.OPEN</code> event which is dispatched 
		 * when a <code>SQLConnection.open()</code> method call fails.
		 * 
		 * @param <code>SQLEvent</code> instance which was dispatched
		 * 
		 */	
		protected function openFault(event:SQLEvent) : void
		{
		}
		
		/**
		 * 
		 * Handles a <code>SQLEvent.CLOSE</code> event which is dispatched 
		 * when a <code>SQLConnection.close()</code> method call completes 
		 * successfully
		 * 
		 * @param <code>SQLEvent</code> instance which was dispatched
		 * 
		 */	
		protected function close(event:SQLEvent) : void
		{
		}
	}
}
