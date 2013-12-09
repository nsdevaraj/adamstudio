package com.adams.dt.dao;

import java.io.Serializable;
import java.util.List;

/**
 * The basic IGenericDao interface with CRUD methods
 * Finders are added with interface inheritance and AOP introductions for concrete implementations
 *
 * Extended interfaces may declare methods starting with find... list... iterate... or scroll...
 * They will execute a preconfigured query that is looked up based on the rest of the method name (create,read,update,bulkupdate,delete)
 */
public interface IGenericDAO<T, PK extends Serializable>{
	// Persist the newInstance object into database 
    T create(T newInstance)throws BaseAppException;
    
    // Retrieve an object that was previously persisted to the database using the indicated id as primary key 
    T read(PK id);
    
    // Save changes made to a persistent object.  
    T update(T transientObject);
    
    // Save an object from persistent storage in the database 
    List<?> bulkUpdate(List<?> objList);
    
    // Remove an object from persistent storage in the database 
    void deleteById(T persistentObject) throws BaseAppException;
}
