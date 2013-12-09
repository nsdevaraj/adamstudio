package com.adams.dt.dao;
import java.util.List; 

/**
 * interface FinderArgumentTypeFactory
 * extends IGenericDAO Class 
 */
public interface DTInterface extends IGenericDAO<Object, Integer>{ 
	
	/**
     * findAll method with the no arguments
     * 
     * @param BaseAppException  Exception handle
     * return type List
     */
	List<?> findAll()throws BaseAppException; 
}
