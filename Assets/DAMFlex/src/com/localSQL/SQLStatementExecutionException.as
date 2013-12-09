package com.localSQL
{
	/**
	 * 
	 * A <code>SQLStatementExecutionException</code> is thrown when an attempt
	 * is made to invoke <code>execute</code> on a <code>SQLStatement</code>
	 * which fails or will result in the execution failing due to the state of
	 * the statement.
	 * 
	 */	
	public final class SQLStatementExecutionException extends Error
	{
		/**
		 *
		 * @private
		 *  
		 */		
		private static const MESSAGE:String = "SQLStatementExecutionException: SQLStatement could not be executed due to an invalid state";
		
		/**
		 * 
		 * <code>SQLStatementExecutionException</code> constructor specifies the error
		 * message of the exception
		 * 
		 */		
		public function SQLStatementExecutionException()
		{
			super( MESSAGE );
		}
	}
}
