package com.adams.dt.servlets;

import java.util.Calendar;
import java.util.Timer;

import javax.servlet.http.HttpServlet;

public class EmailSchedular extends HttpServlet{
	
	//expressed in milliseconds
	private final static long fONCE_PER_DAY = 1000*60*60*24;
	  
	public void init() {
		
		//testCategoriesList();
		
		com.adams.dt.util.email.EmailSchedular emailSchedule = new com.adams.dt.util.email.EmailSchedular();
		System.out.println( getServletName() + ": initialised" );
		Timer timer = new Timer();
		timer.scheduleAtFixedRate(emailSchedule, Calendar.getInstance().getTime(), fONCE_PER_DAY);		
	}

	/*private void testCategoriesList() {
		try {
			List<?> categoriesList = BuilsConfig.dtPageDAO.queryListView("Categories.SelectALLCategories");
			System.out.println("categoriesList.size:"+categoriesList.size());
			for(Object obj: categoriesList) {
				Object[] recordList = (Object[])obj;
				Categories cat = (Categories)recordList[0];
				Domainworkflows dw = (Domainworkflows)recordList[1];
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}*/
	
}
