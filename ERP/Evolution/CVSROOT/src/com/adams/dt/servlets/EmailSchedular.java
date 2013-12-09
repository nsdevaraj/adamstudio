package com.adams.dt.servlets;

import java.util.Calendar;
import java.util.Timer;

import javax.servlet.http.HttpServlet;

public class EmailSchedular extends HttpServlet{
	
	//expressed in milliseconds
	private final static long fONCE_PER_DAY = 1000*60*60*24;
	  
	public void init() {		
		com.adams.dt.util.email.EmailSchedular emailSchedule = new com.adams.dt.util.email.EmailSchedular();
		System.out.println( getServletName() + ": initialised" );
		Timer timer = new Timer();
		timer.scheduleAtFixedRate(emailSchedule, Calendar.getInstance().getTime(), fONCE_PER_DAY);		
	}
}
