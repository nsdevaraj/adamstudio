package com.adams.dt.dao.hibernate.finder;

import org.hibernate.type.Type;

/**
 * interface FinderArgumentTypeFactory
 */
public interface FinderArgumentTypeFactory
{
	/**
     * Method name getArgumentType.
     *
     * @param arg Object 
     * return Type;   
     */
    Type getArgumentType(Object arg);
}
