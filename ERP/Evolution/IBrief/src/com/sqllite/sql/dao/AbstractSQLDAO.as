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
	import com.sqllite.sql.SQLStatementExecutionException;
	import com.sqllite.sql.utils.SQLStatementHelper;
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
