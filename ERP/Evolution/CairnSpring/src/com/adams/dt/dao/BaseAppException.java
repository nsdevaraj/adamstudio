package com.adams.dt.dao;

/**
 * BaseAppException Class 
 * extends Exception
 */
public class BaseAppException extends Exception {

	// @private variable exceptionMessage
    private String exceptionMessage;
    
    /**
     * BaseAppException Class constructor
     * 
     * @param msg String
     */
    public BaseAppException(String msg) {
        this.exceptionMessage = msg;
    }

    /**
     * BaseAppException Class constructor
     * 
     * @param msg String
     * @param e Throwable
     */
    public BaseAppException(String msg, Throwable e) {
        this.exceptionMessage = msg;
        this.initCause(e);
    }

    /**
     * setCause method
     * 
     * @param e Throwable
     * return type void
     */
    public void setCause(Throwable e) {
        this.initCause(e);
    }
    
    /**
     * toString method
     * 
     * convert class in string
     * return type String
     */
    public String toString() {
        String s = getClass().getName();
        return s + ": " + exceptionMessage;
    }

    /**
     * getMessage method
     * 
     * return type String
     */
    public String getMessage() {
        return exceptionMessage;
    }
}