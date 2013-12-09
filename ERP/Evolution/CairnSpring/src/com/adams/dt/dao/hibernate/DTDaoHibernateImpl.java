package com.adams.dt.dao.hibernate;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.type.Type;

import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.adams.dt.dao.IGenericDAO;
import com.adams.dt.dao.hibernate.finder.FinderArgumentTypeFactory;
import com.adams.dt.dao.hibernate.finder.FinderExecutor;
import com.adams.dt.dao.hibernate.finder.FinderNamingStrategy;
import com.adams.dt.dao.hibernate.finder.impl.SimpleFinderArgumentTypeFactory;
import com.adams.dt.dao.hibernate.finder.impl.SimpleFinderNamingStrategy;

/**
 * DTDaoHibernateImpl Class 
 * extends HibernateDaoSupport Class
 * implements IGenericDAO Class
 */
public class DTDaoHibernateImpl<T, PK extends Serializable> extends HibernateDaoSupport implements
		IGenericDAO<T, PK>, FinderExecutor {
	
	// @private SessionFactory Object 
	private SessionFactory sessionFactory;
	
	// @private FinderNamingStrategy Object 
	private FinderNamingStrategy namingStrategy = new SimpleFinderNamingStrategy(); // Default. Can override in config
	
	// @private FinderArgumentTypeFactory Object 
	private FinderArgumentTypeFactory argumentTypeFactory = new SimpleFinderArgumentTypeFactory(); // Default. Can override in config
	
	// @private HibernateTemplate Object 
	HibernateTemplate hibernateTemplate;
	
	// @private Class Object 
	private Class<T> type;
	
	// @private cacheKeyValue variable 
	private String cacheKeyValue;

	 /**
     * getCacheKeyValue method
     * 
     * return type String
     */
	public String getCacheKeyValue() {
		return cacheKeyValue;
	}

	 /**
     * DTDaoHibernateImpl Class constructor
     * 
     * @param type Class
     */
	public DTDaoHibernateImpl(Class<T> type) {
		this.type = type;
		this.cacheKeyValue=type.getName();
	}

	 /**
     * create method
     * 
     * @param o T this class object
     * return type T this class
     */
	public T create(T o)  {
 		 try {
 			 getSession().saveOrUpdate(o);
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			return (T) o;
 		}
	}

	/**
     * read method
     * 
     * @param id this class primary key
     * return type T this class
     */
	public T read(PK id) {
  		return (T) getSession().get(type, id);
	}

	/**
     * readWithRefresh method
     * 
     * @param id this class primary key
     * @param o T this class object
     * return type T this class
     */
	public T readWithRefresh(PK id,T o){
		getSession().refresh(o);
		return (T) getSession().get(type, id);
	}
	
	
	/**
     * bulkUpdate method
     * 
     * @param List objList
     * return type List
     */
	public List<?> bulkUpdate(List<?> objList){
		getHibernateTemplate().saveOrUpdateAll(objList);
		return objList;
	}
	
	/**
     * update method
     * 
     * @param o T this class object
     * return type T this class
     */
	public T update(T o) {
		getSession().merge(o);
		return (T) o;
	}

	/**
     * deleteById method
     * 
     * @param o T this class object
     * return type void
     */
	public void deleteById(T o) {
		getSession().delete(o);
	}
	
	/**
     * Method name executeFinder.
     *
     * @param method Method 
     * @param queryArgs Object array 
     * return type List;   
     */
	public List<T> executeFinder(Method method, final Object[] queryArgs) {
		final Query namedQuery = prepareQuery(method, queryArgs);
		return (List<T>) namedQuery.list();
	}

	/**
     * Method name iterateFinder.
     *
     * @param method Method 
     * @param queryArgs Object array 
     * return type Iterator;   
     */
	public Iterator<T> iterateFinder(Method method, final Object[] queryArgs) {
		final Query namedQuery = prepareQuery(method, queryArgs);
		return (Iterator<T>) namedQuery.iterate();
	} 

	/**
     * Method name prepareQuery.
     *
     * @param method Method 
     * @param queryArgs Object array 
     * return type Query;   
     */
	private Query prepareQuery(Method method, Object[] queryArgs) {
		final String queryName = getNamingStrategy().queryNameFromMethod(type,
				method);
		final Query namedQuery = getSession().getNamedQuery(queryName);
		String[] namedParameters = namedQuery.getNamedParameters();
		if (namedParameters.length == 0) {
			setPositionalParams(queryArgs, namedQuery);
		} else {
			setNamedParams(namedParameters, queryArgs, namedQuery);
		}
		return namedQuery;
	}

	/**
     * Method name setPositionalParams.
     *    
     * @param queryArgs Object array 
     * @param namedQuery Query 
     * return type void;   
     */
	private void setPositionalParams(Object[] queryArgs, Query namedQuery) {
		// Set parameter. Use custom Hibernate Type if necessary
		if (queryArgs != null) {
			for (int i = 0; i < queryArgs.length; i++) {
				Object arg = queryArgs[i];
				Type argType = getArgumentTypeFactory().getArgumentType(arg);
				if (argType != null) {
					namedQuery.setParameter(i, arg, argType);
				} else {
					namedQuery.setParameter(i, arg);
				}
			}
		}
	}

	/**
     * Method name setNamedParams.
     *    
     * @param namedParameters String array 
     * @param queryArgs Object array 
     * @param namedQuery Query 
     * return type void;   
     */
	private void setNamedParams(String[] namedParameters, Object[] queryArgs,
			Query namedQuery) {
		// Set parameter. Use custom Hibernate Type if necessary
		if (queryArgs != null) {
			for (int i = 0; i < queryArgs.length; i++) {
				Object arg = queryArgs[i];
				Type argType = getArgumentTypeFactory().getArgumentType(arg);
				if (argType != null) {
					namedQuery.setParameter(namedParameters[i], arg, argType);
				} else {
					if (arg instanceof Collection) {
						namedQuery.setParameterList(namedParameters[i],
								(Collection) arg);
					} else {
						namedQuery.setParameter(namedParameters[i], arg);
					}
				}
			}
		}
	}
 
	/**
     * Method name getNamingStrategy.
     *         
     * return type FinderNamingStrategy;   
     */
	public FinderNamingStrategy getNamingStrategy() {
		return namingStrategy;
	}

	/**
     * Method name setNamingStrategy.
     *    
     * @param namingStrategy FinderNamingStrategy to value set
     * return type void;   
     */
	public void setNamingStrategy(FinderNamingStrategy namingStrategy) {
		this.namingStrategy = namingStrategy;
	}

	/**
     * Method name getArgumentTypeFactory.
     *         
     * return type FinderArgumentTypeFactory;   
     */
	public FinderArgumentTypeFactory getArgumentTypeFactory() {
		return argumentTypeFactory;
	}

	/**
     * Method name setArgumentTypeFactory.
     *    
     * return type void;   
     */
	public void setArgumentTypeFactory(
			FinderArgumentTypeFactory argumentTypeFactory) {
		this.argumentTypeFactory = argumentTypeFactory;
	}
}
