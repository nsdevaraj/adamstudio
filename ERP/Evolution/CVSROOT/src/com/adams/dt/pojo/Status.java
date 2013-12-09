package com.adams.dt.pojo;


/*
 * For Table status
 */
public class Status implements java.io.Serializable{

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/* status_ID, PK */
    protected int statusId;

    /* type */
    protected String type; 
    /* status_label */
    protected String statusLabel;

    /* status_num_code */
    protected short statusNumCode;

    /* status_ID, PK */
    public int getStatusId() {
        return statusId;
    }

    /* status_ID, PK */
    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    /* type */
    public String getType() {
        return type;
    }

    /* type */
    public void setType(String type) {
        this.type = type;
    }

    /* status_label */
    public String getStatusLabel() {
        return statusLabel;
    }

    /* status_label */
    public void setStatusLabel(String statusLabel) {
        this.statusLabel = statusLabel;
    }

    /* status_num_code */
    public short getStatusNumCode() {
        return statusNumCode;
    }

    /* status_num_code */
    public void setStatusNumCode(short statusNumCode) {
        this.statusNumCode = statusNumCode;
    } 
}