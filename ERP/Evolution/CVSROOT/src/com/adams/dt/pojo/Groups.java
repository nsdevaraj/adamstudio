/*
 * This java source file is generated by DAO4J v1.16
 * Generated on Fri Mar 20 11:39:50 IST 2009
 * For more information, please contact b-i-d@163.com
 * Please check http://members.lycos.co.uk/dao4j/ for the latest version.
 */

package com.adams.dt.pojo;

import java.io.Serializable; 

/*
 * For Table groups
 */
public class Groups implements Serializable {
	 
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	  /* group_ID, PK */
    protected int groupId;

    /* group_label */
    protected String groupLabel;
    protected String authLevel;

    public String getAuthLevel() {
		return authLevel;
	}

	public void setAuthLevel(String authLevel) {
		this.authLevel = authLevel;
	}

	/* group_ID, PK */
    public int getGroupId() {
        return groupId;
    }

    /* group_ID, PK */
    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    /* group_label */
    public String getGroupLabel() {
        return groupLabel;
    }

    /* group_label */
    public void setGroupLabel(String groupLabel) {
        this.groupLabel = groupLabel;
    }
 
 
}