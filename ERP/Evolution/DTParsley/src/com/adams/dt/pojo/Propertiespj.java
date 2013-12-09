package com.adams.dt.pojo;

import java.io.Serializable;

public class Propertiespj implements Serializable {

    static final long serialVersionUID = 103844514947365244L;
    
    private int propertyPjId;
    private Propertiespresets propertyPreset; 
    private int projectFk;
    private String fieldValue;  
	public Propertiespj() {
    	
    }
    
    /* property_pj_ID, PK */
    public int getPropertyPjId() {
        return propertyPjId;
    }

    /* property_pj_ID, PK */
    public void setPropertyPjId(int propertyPjId) {
        this.propertyPjId = propertyPjId;
    }
 
    /* field_value */
    public String getFieldValue() {
        return fieldValue;
    }

    /* field_value */
    public void setFieldValue(String fieldValue) {
        this.fieldValue = fieldValue;
    }
 
	public Propertiespresets getPropertyPreset() {
		return propertyPreset;
	}

	public void setPropertyPreset(Propertiespresets propertyPreset) {
		this.propertyPreset = propertyPreset;
	}

	public int getProjectFk() {
		return projectFk;
	}

	public void setProjectFk(int projectFk) {
		this.projectFk = projectFk;
	}
 
}