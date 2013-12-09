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

package com.ericfeminella.sql
{
	import flash.data.SQLStatement;
	import flash.data.SQLConnection;

	/**
	 * 
	 * <code>PreparedStatement</code> provides a <code>SQLStatement</code> 
	 * implementation which enforces the <code>text</code> property of a
	 * statement to be sealed, that is it can only be assigned during 
	 * creation of the statement.
	 * 
	 * <p>
	 * Before a <code>SQLStatement</code> is executed, the runtime prepares 
	 * (compiles) the statement in order to determine the steps which are 
	 * to be performed internally to carry out the statement. 
	 * </p>
	 * 
	 * <p>
	 * When a call to <code>SQLStatement.execute</code> is made on a SQLStatement
	 * instance which has not previously been executed, the statement is automatically 
	 * prepared  before it is executed. On subsequent calls to the execute method, 
	 * as long as the <code>SQLStatement.text</code> property has not changed the 
	 * statement is  still prepared thus allowing the statement to execute faster.
	 * </p>
	 * 
	 * <p>
	 * By enforcing the <code>SQLStatement.text</code> property is only assigned 
	 * a value once, a <code>PreparedStatement</code> statement can be utilized to 
	 * improve performance of the statements execution.
	 * </p>
	 * 
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/data/SQLStatement.html
	 * 
	 */
	public class PreparedStatement extends SQLStatement
	{
		/**
		 * 
		 * The <code>PreparedStatement</code> constructor requires the statement 
		 * text which  is assigned to the <code>text</code>
		 * 
		 * @example The following example demonstrates a typical implementation of 
		 * <code></code>
		 * 
		 * <listing version="3.0">
		 * 
		 * const select:String = "SELECT * FROM foo.bar";
		 * var statement:PreparedStatement = new PreparedStatement( select );
		 * 
		 * </listing>
		 * 
		 * @param SQL statement which is to be executed by this <code>PreparedStatement</code>
		 * @param <code>SQLConnection</code> which the statement is to execute against
		 * @param <code>Class</code> which the results of the statement are to be resolved
		 * 
		 */		
		public function PreparedStatement(statementText:String, connection:SQLConnection = null, itemClass:Class = null)
		{
			this.text = statementText;
			this.itemClass = itemClass
			this.sqlConnection = connection;
		}
		
		/**
		 *
		 * By overriding the implicit setter of the <code>text</code> property
		 * a <code>PreparedStatement</code> ensures that the property is only 
		 * assigned a value during object construction.
		 * 
		 * @param SQL statement which is to be executed by this <code>PreparedStatement</code>
		 * @throws com.ericfeminella.sql.PreparedStatementException
		 * @see    PreparedStatementException
		 * 
		 */		
		public override function set text(statement:String) : void
		{
			if ( text != "" )
			{
				throw new PreparedStatementException();
			}
			super.text = statement;
		}
	}
}
