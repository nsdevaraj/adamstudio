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

package com.sqllite.sql
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
