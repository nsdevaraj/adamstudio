/*
 * This java source file is generated by DAO4J v1.16
 * Generated on Fri Mar 20 11:39:57 IST 2009
 * For more information, please contact b-i-d@163.com
 * Please check http://members.lycos.co.uk/dao4j/ for the latest version.
 */

package com.adams.dt.pojo;

import java.io.Serializable;   
/*
 * For Table chat
 */
public class ReportColumns implements Serializable{

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;	
    
	protected int reportColumnId;
	protected int reportfk;     
	protected int columnfk; 
	
    public ReportColumns() {
    }

	public int getReportColumnId() {
		return reportColumnId;
	}

	public void setReportColumnId(int reportColumnId) {
		this.reportColumnId = reportColumnId;
	}

	public int getReportfk() {
		return reportfk;
	}

	public void setReportfk(int reportfk) {
		this.reportfk = reportfk;
	}

	public int getColumnfk() {
		return columnfk;
	}

	public void setColumnfk(int columnfk) {
		this.columnfk = columnfk;
	}

}