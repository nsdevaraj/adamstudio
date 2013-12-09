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

package com.ericfeminella.sql.dao
{
	import com.adams.dt.business.util.DecryptionKeyGenerator;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * <code>AbstractSynchronizedSQLDAO</code> provides an abstraction of
	 * a synchronized DAO SQL implementation.
	 * 
	 */
	public class DecryptAbstractSynchronizedSQLDAO extends AbstractSQLDAO
	{
		/**
		 *
		 * <code>AbstractSynchronizedSQLDAO</code> constructor requires the 
		 * databasePath from which the database connection is to be made.
		 *  
		 * @param path from which the <code>SQLConnection</code> is to be based
		 * 
		 */		
		public function DecryptAbstractSynchronizedSQLDAO(connection:SQLConnection, databaseFile:File = null)
		{
		    super( connection );

		    if ( !connection.connected )
		    {
		    	connection.addEventListener( SQLEvent.OPEN, openResult ,false,0,true);
		    	connection.addEventListener( SQLErrorEvent.ERROR, openFault ,false,0,true);
		    	var decryption:DecryptionKeyGenerator = new DecryptionKeyGenerator();
				var decryptionKey:ByteArray = decryption.generateEncryptionKey("awubpwedtmpdbsphbmuthomTobbaautp");
		    	connection.open(databaseFile,SQLMode.UPDATE, false, 1024, decryptionKey );
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
