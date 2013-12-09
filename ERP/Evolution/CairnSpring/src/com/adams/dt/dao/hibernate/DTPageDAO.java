package com.adams.dt.dao.hibernate;
 
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
 
import org.hibernate.Query;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * DTPageDAO Class 
 * extends HibernateDaoSupport Class
 */
public class DTPageDAO extends HibernateDaoSupport {

	/**
     * Method name getQueryResult.
     *
     * @param query String 
     * @param handle the Exception  
     * return type List  
     */
	public List<?> getQueryResult(String query) throws Exception {
		Query q = getSession().createSQLQuery(query);
		System.out.print(query);
		//Query q = getSession().createQuery(query);
		if (q == null)
			throw new Exception("Order id is null.");

		return q.list();
	} 	
	
	/**
     * Method name paginationListView.
     *
     * @param strQuery String 
     * @param startPoint Integer 
     * @param endPoint Integer 
     * @param handle the Exception  
     * return type List  
     */
	public List<?> paginationListView(String strQuery, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	/**
     * Method name queryListView.
     *
     * @param strQuery String      
     * @param handle the Exception  
     * return type List  
     */
	public List<?> queryListView(String strQuery) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery); 
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
  
		return query.list();
	}
	
	/**
     * Method name paginationListViewId.
     *
     * @param strQuery String 
     * @param prgId Integer 
     * @param startPoint Integer 
     * @param endPoint Integer 
     * @param handle the Exception   
     * return type List  
     */
	public List<?> paginationListViewId(String strQuery, Integer prgId, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setInteger(0, prgId);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	/**
     * Method name paginationListViewIdId.
     *
     * @param strQuery String 
     * @param prgId1 Integer 
     * @param prgId2 Integer 
     * @param startPoint Integer 
     * @param endPoint Integer 
     * @param handle the Exception   
     * return type List  
     */
	public List<?> paginationListViewIdId(String strQuery, Integer prgId1, Integer prgId2, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setInteger(0, prgId1);
			query.setInteger(1, prgId2);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}

	/**
     * Method name paginationListViewIdIdId.
     *
     * @param strQuery String 
     * @param prgId1 Integer 
     * @param prgId2 Integer
     * @param prgId3 Integer 
     * @param startPoint Integer 
     * @param endPoint Integer 
     * @param handle the Exception   
     * return type List  
     */
	public List<?> paginationListViewIdIdId(String strQuery, Integer prgId1, Integer prgId2, Integer prgId3, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setInteger(0, prgId1);
			query.setInteger(1, prgId2);
			query.setInteger(2, prgId3);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}

	/**
     * Method name paginationListViewIdStr.
     *
     * @param strQuery String 
     * @param prgId Integer 
     * @param tempFieldValue String
     * @param startPoint Integer 
     * @param endPoint Integer 
     * @param handle the Exception   
     * return type List  
     */
	public List<?> paginationListViewIdStr(String strQuery, Integer prgId, String tempFieldValue, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setInteger(0, prgId);
			query.setString(1, tempFieldValue);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	/**
     * Method name paginationListViewIdDtDt.
     *
     * @param strQuery String 
     * @param prgId Integer 
     * @param startDate Date
     * @param endDate Date
     * @param startPoint Integer 
     * @param endPoint Integer 
     * @param handle the Exception   
     * return type List  
     */
	public List<?> paginationListViewIdDtDt(String strQuery, Integer prgId, Date startDate, Date endDate, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setInteger(0, prgId);
			query.setDate(1, startDate);
			query.setDate(2, endDate);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	/**
     * Method name paginationListViewStr.
     *
     * @param strQuery String 
     * @param userName String      
     * @param startPoint Integer 
     * @param endPoint Integer 
     * @param handle the Exception   
     * return type List  
     */
	public List<?> paginationListViewStr(String strQuery, String userName, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setString(0, userName);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	/**
     * Method name paginationListViewStrStr.
     *
     * @param strQuery String 
     * @param userName1 String
     * @param userName2 String      
     * @param startPoint Integer 
     * @param endPoint Integer 
     * @param handle the Exception   
     * return type List  
     */
	public List<?> paginationListViewStrStr(String strQuery, String userName1, String userName2, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setString(0, userName1);
			query.setString(1, userName2);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	/**
     * Method name paginationListViewStrStrDtDt.
     *
     * @param strQuery String 
     * @param instiName String
     * @param status String 
     * @param startDate Date
     * @param endDate Date     
     * @param startPoint Integer 
     * @param endPoint Integer 
     * @param handle the Exception   
     * return type List  
     */
	public List paginationListViewStrStrDtDt(String strQuery, String instiName, String status, Date startDate, Date endDate, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setString(0, instiName);
			query.setString(1, status);
			query.setDate(2, startDate);
			query.setDate(3, endDate);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	 
	/**
     * Method name deleteByForeignKey.
     *
     * @param strQuery String    
     * @param handle the Exception   
     * return type void  
     */
	public void deleteByForeignKey(String strQuery) throws Exception {
		
		try {
			Query query =	getSession().createSQLQuery(strQuery);
			query.executeUpdate();
			
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
	}
	
	/**
     * Method name queryPagination.
     *
     * @param strQuery String 
     * @param startPoint Integer 
     * @param endPoint Integer    
     * @param handle the Exception   
     * return type List  
     */
	public List<?> queryPagination(String strQuery, Integer startPoint, Integer endPoint) throws Exception {
		Query query =null;
		try {
			 query =getSession().createQuery(strQuery);
			 query.setFirstResult(startPoint);
			 query.setMaxResults(endPoint);
			
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
}