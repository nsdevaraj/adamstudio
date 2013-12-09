package com.adams.dt.dao.hibernate.finder.impl;

import org.aopalliance.intercept.MethodInvocation;
import org.springframework.aop.IntroductionInterceptor;

import com.adams.dt.dao.hibernate.finder.FinderExecutor;

/**
 * Connects the Spring AOP magic with the Hibernate DAO magic
 * For any method beginning with "find" this interceptor will use the FinderExecutor to call a Hibernate named query
 */
public class FinderIntroductionInterceptor implements IntroductionInterceptor
{
	/**
     * find and method invocation.
     *
     * @param methodInvocation MethodInvocation 
     * @throws exception throws 
     * return type Object    
     */
    public Object invoke(MethodInvocation methodInvocation) throws Throwable
    {
    	// FinderExecutor instance object and convert the MethodInvocation class value to assign
        FinderExecutor executor = (FinderExecutor) methodInvocation.getThis();

        // @private variable methodName - get a methodName
        String methodName = methodInvocation.getMethod().getName();
        
        // condition check to find the method name by find and list 
        if(methodName.startsWith("find") || methodName.startsWith("list"))
        {
            Object[] arguments = methodInvocation.getArguments();
            return executor.executeFinder(methodInvocation.getMethod(), arguments);
        }
        // condition check to find the method name by iterate 
        else if(methodName.startsWith("iterate"))
        {
            Object[] arguments = methodInvocation.getArguments();
            return executor.iterateFinder(methodInvocation.getMethod(), arguments);
        } 
        // else part
        else
        {
            return methodInvocation.proceed();
        }
    }
    
    /**
     * Using for Class excution.
     *
     * @param intf Class 
     * return type boolean    
     */

    public boolean implementsInterface(Class intf)
    {
        return intf.isInterface() && FinderExecutor.class.isAssignableFrom(intf);
    }
}
