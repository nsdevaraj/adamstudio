package com.adams.dt.dao.hibernate.finder;

import java.lang.reflect.Method;

/**
 * interface FinderNamingStrategy
 * Used to locate a named query based on the called finder method
 */
public interface FinderNamingStrategy
{
	/**
     * Using for queryNameFromMethod method.
     *
     * @param findTargetType Class
     * @param finderMethod Method 
     * return type String     
     */
    public String queryNameFromMethod(Class findTargetType, Method finderMethod);
}
