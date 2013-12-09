package com.adams.dt.dao.hibernate.finder;

import java.lang.reflect.Method;
import java.util.List;
import java.util.Iterator;
 
/**
 * interface FinderExecutor
 */
public interface FinderExecutor<T>
{
    /**
     * Execute a finder method with the appropriate arguments
     * 
     * @param method Method 
     * @param queryArgs Object Array 
     */
    List<T> executeFinder(Method method, Object[] queryArgs);
    
    /**
     * Iterator a finder method with the appropriate arguments
     * 
     * @param method Method 
     * @param queryArgs Object Array     
     */
    Iterator<T> iterateFinder(Method method, Object[] queryArgs);

}
