package com.adams.dt.util;

import com.adams.dt.dao.hibernate.DTPageDAO;

public final class BuildConfig {
	
	public static String serverAddress = null;
	public static String serverPort = null;
	public static String db = "MYSQL";
	
	public static String navigationHtmlUrl = null;
	public static String flexUsername = null;
	public static String flexPassword = null;

	public static String smtpMailFromUser = null;
	public static String smtpMailFromPass = null;
	public static String smtpMailHostName = null;
	public static String smtpMailHostPort = null;
	public static boolean smtpMailStarttlsEnable = true;
	public static boolean smtpMailIsSSL = true;
	public static boolean smtpMailAuth = true;
	public static boolean smtpMailDebugging = true;
	public static String smtpMailMailLabel = null;
	
	public static DTPageDAO dtPageDAO = null;
	public static String applicationContext = null;
	public static String rssRootContext = null;
	
}