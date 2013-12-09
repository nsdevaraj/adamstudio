package com.adams.dt.dao.hibernate.finder.impl;

import org.hibernate.type.Type;
import com.adams.dt.dao.hibernate.finder.FinderArgumentTypeFactory;

/**
 * Maps Enums to a custom Hibernate user type
 * implements FinderArgumentTypeFactory
 */
public class SimpleFinderArgumentTypeFactory implements FinderArgumentTypeFactory
{
	
	/**
     * argument type passing.
     *
     * @param arg Object 
     * return type default null    
     */
    public Type getArgumentType(Object arg)
    { 
    		// return type;
            return null;
    } 
}
