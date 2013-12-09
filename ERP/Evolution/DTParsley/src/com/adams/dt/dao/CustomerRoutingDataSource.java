package com.adams.dt.dao;
import java.sql.SQLException;

import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;
public class CustomerRoutingDataSource extends AbstractRoutingDataSource {
   @Override
   protected Object determineCurrentLookupKey() {
      return CustomerContextHolder.getCustomerType();
   }

	@Override
	public boolean isWrapperFor(Class<?> arg0) throws SQLException {
		// TODO Auto-generated method stub
		return false;
	}
	
	@Override
	public <T> T unwrap(Class<T> arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
}
