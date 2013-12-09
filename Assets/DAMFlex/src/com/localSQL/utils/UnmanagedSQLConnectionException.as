package com.localSQL.utils
{
	/**
	 * 
	 * An <code>UnmanagedSQLConnectionException</code> is thrown when an attempt 
	 * is made to close a <code>SQLConnection</code> which is not being managed 
	 * by the <code>SQLStatementHelper</code>
	 * 
	 * @see SQLStatementHelper
	 * 
	 */	
	public class UnmanagedSQLConnectionException extends Error
	{
		/**
		 *
		 * @private 
		 *  
		 */		
		private static const MESSAGE:String = "UnmanagedSQLConnectionException: SQLStatementHelper not managing a SQLConnection for the specified databasePath";
		
		/**
		 * 
		 * <code>UnmanagedSQLConnectionException</code> constructor specifies the
		 * unmanaged database path
		 * 
		 */		
		public function UnmanagedSQLConnectionException(databasePath:String)
		{
			super( MESSAGE + " " + databasePath );
		}
	}
}
