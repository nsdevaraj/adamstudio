package com.localSQL
{
	/**
	 * 
	 * A <code>PreparedStatementException</code> is thrown when an attempt is made
	 * to assign a value to a <code>PreparedStatement.text</code> property
	 * 
	 * @see PreparedStatement
	 * 
	 */	
	public final class PreparedStatementException extends Error
	{
		/**
		 *
		 * @private 
		 *  
		 */		
		private static const MESSAGE:String = "PreparedStatementException: A PreparedStatement may only have a single statement value assigned";
		
		/**
		 * 
		 * <code>PreparedStatementException</code> constructor specifies the error
		 * message of the exception
		 * 
		 */		
		public function PreparedStatementException()
		{
			super( MESSAGE );
		}
	}
}
