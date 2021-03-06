package com.adams.dt.dao;

import java.io.Serializable;
import java.util.List;

public interface IGenericDAO<T, PK extends Serializable>{
    T create(T newInstance)throws BaseAppException;
    T read(PK id);
    T update(T transientObject);
    List<?> bulkUpdate(List<?> objList);
    List<?> getList();
    Long count();
    void deleteAll();
    void deleteById(T persistentObject) throws BaseAppException;
}
