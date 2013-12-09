package com.localSQL.utils
{
    import flash.data.SQLStatement;

    /**
     *
     * <code>SQLStatementHelper</code> is an all static utility class which 
     * provides a mechanism for substituting unnamed tokens specified in a 
     * raw statement with an arbitrary length of values.
     *
     */
    public final class SQLStatementHelper
    {
        /**
         *
         * Provides a mechanism allowing automated substitution of unnamed parameters 
         * specified in a <code>SQLStatement.text</code> value, with an arbitrary list 
         * of parameters.
         *
         * @example The following example demonstrates a typical implementation
         * of <code<SQLStatementHelper</code> by which the  unnamed parameters:  
         * ?, ?, ? are substituted with the values 'foo', 'bar', 100
         *
         * <listing version="3.0">
         * 
         * var statement:SQLStatement = new SQLStatement();
         * statement.text = "INSERT INTO foo VALUES(?, ?) WHERE id = ?";;
         * 
         * SQLStatementHelper.applyUnnamedParameters( statement, "foo","bar", 100 );
         * // INSERT INTO 'foo' VALUES('foo', 'bar') WHERE id=100
         *
         * </listing>
         *
         * @param  <code>SQLStatement</code> from which unnamed parameters are to be replaced
         * @param  arbitrary values to replace unnamed parameters
         *
         */
        public static function applyUnnamedParameters(statement:SQLStatement, ...parameters) : void
        {
        	var n:int = parameters.length;
        	
        	statement.clearParameters();
        	
        	for (var i:int = 0; i < n; i++)
        	{
        		statement.parameters[i] = parameters[i];
        	}
        }
    }
}
