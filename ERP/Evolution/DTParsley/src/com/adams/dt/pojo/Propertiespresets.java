package com.adams.dt.pojo;

import java.io.Serializable;
import java.util.Set;

public class Propertiespresets implements Serializable {

    static final long serialVersionUID = 103844514947365244L;
    
    private int propertyPresetId; 
    private boolean editablePropertyPreset;
    private String fieldLabel;
    private String fieldName;
    private String fieldType;
    private String fieldOptionsValue;
    private String fieldDefaultValue;  
	public Propertiespresets() {
    	
    }
	/* property_preset_ID, PK */
	
	public boolean getEditablePropertyPreset() {
        return editablePropertyPreset;
    }

    /* property_preset_ID, PK */
    public void setEditablePropertyPreset(boolean editableId) {
        this.editablePropertyPreset = editableId;
    }
	
    
    /* property_preset_ID, PK */
    public int getPropertyPresetId() {
        return propertyPresetId;
    }

    /* property_preset_ID, PK */
    public void setPropertyPresetId(int propertyPresetId) {
        this.propertyPresetId = propertyPresetId;
    }
 
    /* field_label */
    public String getFieldLabel() {
        return fieldLabel;
    }

    /* field_label */
    public void setFieldLabel(String fieldLabel) {
        this.fieldLabel = fieldLabel;
    }

    /* field_name */
    public String getFieldName() {
        return fieldName;
    }

    /* field_name */
    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    /* field_type */
    public String getFieldType() {
        return fieldType;
    }

    /* field_type */
    public void setFieldType(String fieldType) {
        this.fieldType = fieldType;
    }

	public String getFieldOptionsValue() {
		return fieldOptionsValue;
	}

	public void setFieldOptionsValue(String fieldOptionsValue) {
		this.fieldOptionsValue = fieldOptionsValue;
	}

	public String getFieldDefaultValue() {
		return fieldDefaultValue;
	}

	public void setFieldDefaultValue(String fieldDefaultValue) {
		this.fieldDefaultValue = fieldDefaultValue;
	}
 
}