package com.adams.dt.dao.hibernate.finder.impl;

import java.lang.reflect.Method;

import com.adams.dt.dao.hibernate.finder.FinderNamingStrategy;

/**
 * Looks up Hibernate named queries based on the simple name of the invoced class and the method name of the invocation
 */
public class ExtendedFinderNamingStrategy implements FinderNamingStrategy
{
	/**
     * Method name queryNameFromMethod.
     *
     * @param findTargetType Class 
     * @param finderMethod Method 
     * return type String  
     */
    /*Always look for queries that start with findBy (even if method is iterateBy.. or scrollBy...) */
    public String queryNameFromMethod(Class findTargetType, Method finderMethod)
    {
    	// @private variable methodName 
        String methodName = finderMethod.getName();
        
        // @private variable methodPart 
        String methodPart = methodName;
        
        // condition check to find the method name by findBy 
        if(methodName.startsWith("findBy")) {
            // No-operation
        }
        // condition check to find the method name by listBy
        else if(methodName.startsWith("listBy")) {
            methodPart = "findBy" + methodName.substring("listBy".length());
        }
        // condition check to find the method name by iterateBy
        else if(methodName.startsWith("iterateBy")) {
            methodPart = "findBy" + methodName.substring("iterateBy".length());
        }
        // condition check to find the method name by scrollBy
        else if(methodName.startsWith("scrollBy")) {
            methodPart = "findBy" + methodName.substring("scrollBy".length());
        }
        // return
        return findTargetType.getSimpleName() + "." + methodPart;
    }
}
