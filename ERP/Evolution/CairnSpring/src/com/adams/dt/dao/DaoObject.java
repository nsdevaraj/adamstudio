package com.adams.dt.dao;

import java.util.Map;


/**
 * DaoObject Class 
 */
public class DaoObject {
	
	Map<String,DTInterface> map;
	
	/**
     * DaoObject Class constructor
     * 
     * @param String
     * @param DTInterface
     */
	DaoObject(Map<String,DTInterface> map){
		 this.map=map;
	}
	/**
     * getObject method with the appropriate arguments
     * 
     * @param objectName String
     * return type DTInterface
     */
	public DTInterface getObject(String objectName){
		 return map.get(objectName);
	 }



}
