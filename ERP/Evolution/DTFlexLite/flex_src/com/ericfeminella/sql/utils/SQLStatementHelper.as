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

package com.ericfeminella.sql.utils
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
