package com.localSQL
{
	/**
	 *
	 * <code>ISQLStatementCache</code> provides a marker interface implementation
	 * which is intended to indicate that implementing classes serve as a repository 
	 * of uniquely defined <code>SQLStatement</code> instances which are to be reused 
	 * throughout the lifetime of an application.
	 * 
	 * <p>
	 * Adobe AIR best practices advocate that any SQL statement which is to be
	 * executed more than once should have a separate <code>SQLStatement</code>
	 * instance defined for each SQL statement. 
	 * </p>
	 * 
	 * <p>
	 * For example, an application that includes various different SQL operations 
	 * which are to be performed multiple times should define seperate instances of
	 * <code>SQLStatement</code>, one for each specific operation. In order to improve 
	 * performance it is recommended to avoid using a single <code>SQLStatement</code> 
	 * instance for all SQL operations by assigning a new value to it's <code>text</code>
	 * property each time before executing the statement. 
	 * 
	 * <p>
	 * <code>ISQLStatementCache</code> is intended to be implemented by classes which 
	 * which define unique <code>SQLStatement</code> or <code>PreparedStatement</code> 
	 * instances, one for each operation which is to be executes more than once.
	 * </p>
	 * 
	 * @example The following example demonstrates a typical <code>ISQLStatementCache</code> 
	 * implementation which defines seperate <code>PreparedStatement</code> instances for 
	 * each statement which will be reused in the application.
	 * 
	 * <listing version="3.0">
	 * 
	 * package
	 * {
	 *     import com.ericfeminella.sql.ISQLStatementCache;
	 *     import com.ericfeminella.sql.PreparedStatement;
	 *     import flash.data.SQLConnection;
	 * 
	 *     public final class FOOStatements implements ISQLStatementCache
	 *     {
	 *         public var INSERT:PreparedStatement;
	 *         public var SELECT:PreparedStatement;
	 *         public var UPDATE:PreparedStatement;
	 *         public var DELETE:PreparedStatement;
	 *          
	 *         public function FOOStatements(connection:SQLConnection)
	 *         {
	 *             INSERT = new PreparedStatement( "INSERT into foo VALUES (?,?)", connection );
	 *             SELECT = new PreparedStatement( "SELECT * FROM foo", connection );
	 *             UPDATE = new PreparedStatement( "UPDATE contacts SET bar=? WHERE id=?)", connection );
	 *             DELETE = new PreparedStatement( "DELETE FROM foo WHERE id=?", connection );
	 *         }
	 *     }
	 * }
	 * 
	 * </listing>
	 * 
	 * @see PreparedStatement
	 * 
	 */	
	public interface ISQLStatementCache {
	}
}
