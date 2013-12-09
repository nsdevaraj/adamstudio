package com.localSQL.dao
{
	
	import com.localSQL.utils.DecryptionKeyGenerator;
	
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
