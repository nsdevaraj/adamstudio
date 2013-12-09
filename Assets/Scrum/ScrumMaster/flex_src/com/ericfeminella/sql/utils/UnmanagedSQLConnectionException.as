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
