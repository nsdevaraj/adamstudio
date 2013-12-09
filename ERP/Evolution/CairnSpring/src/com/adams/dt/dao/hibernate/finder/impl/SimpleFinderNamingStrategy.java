package com.adams.dt.dao.hibernate.finder.impl;

import java.lang.reflect.Method;

import com.adams.dt.dao.hibernate.finder.FinderNamingStrategy;
/**
 * Looks up Hibernate named queries based on the simple name of the invoced class and the method name of the invocation
 */
public class SimpleFinderNamingStrategy implements FinderNamingStrategy
{
	/**
     * Method name queryNameFromMethod.
     *
     * @param findTargetType Class 
     * @param finderMethod Method 
     * return type String;   
     */
    public String queryNameFromMethod(Class findTargetType, Method finderMethod)
    {
        return findTargetType.getSimpleName() + "." + finderMethod.getName();
    }
}
