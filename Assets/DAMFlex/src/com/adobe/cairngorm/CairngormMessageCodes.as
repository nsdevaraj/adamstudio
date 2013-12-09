package com.adobe.cairngorm
{
	/**
	 * Stores Cairngorm message codes.
	 * 
	 * <p>All messages/error codes must match the regular expression:
	 *
	 * C\d{4}[EWI]
	 *
	 * 1. The application prefix e.g. 'C'.
	 * 
	 * 2. A four-digit error code that must be unique.
	 * 
	 * 3. A single character severity indicator
	 *    (E: error, W: warning, I: informational).</p>
	 */
	public class CairngormMessageCodes
	{
	   public static const SINGLETON_EXCEPTION : String = "C0001E";
	   public static const SERVICE_NOT_FOUND : String = "C0002E";
	   public static const COMMAND_ALREADY_REGISTERED : String = "C0003E";
	   public static const COMMAND_NOT_FOUND : String = "C0004E";
	   public static const VIEW_ALREADY_REGISTERED : String = "C0005E";
	   public static const VIEW_NOT_FOUND : String = "C0006E";
	   public static const REMOTE_OBJECT_NOT_FOUND : String = "C0007E";	
	   public static const HTTP_SERVICE_NOT_FOUND : String = "C0008E";
	   public static const WEB_SERVICE_NOT_FOUND : String = "C0009E";
	   public static const CONSUMER_NOT_FOUND : String = "C0010E";
	   public static const PRODUCER_NOT_FOUND : String = "C0012E";
	   public static const DATA_SERVICE_NOT_FOUND : String = "C0013E";
	   public static const ABSTRACT_METHOD_CALLED : String = "C0014E";
	   public static const COMMAND_NOT_REGISTERED : String = "C0015E";
	}
}