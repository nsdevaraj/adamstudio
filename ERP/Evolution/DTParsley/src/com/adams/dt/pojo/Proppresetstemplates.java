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
public class Proppresetstemplates implements Serializable {
	 
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	  /* group_ID, PK */
    protected int proppresetstemplatesId;
    protected int propertypresetFK;
    protected int presetstemplatesFk;
    private String fieldLabel;
    private String fieldOptionsValue;
    private String fieldDefaultValue;
    
	public int getProppresetstemplatesId() {
		return proppresetstemplatesId;
	}
	public void setProppresetstemplatesId(int proppresetstemplatesId) {
		this.proppresetstemplatesId = proppresetstemplatesId;
	} 
	public int getPropertypresetFK() {
		return propertypresetFK;
	}
	public void setPropertypresetFK(int propertypresetFK) {
		this.propertypresetFK = propertypresetFK;
	}
	public int getPresetstemplatesFk() {
		return presetstemplatesFk;
	}
	public void setPresetstemplatesFk(int presetstemplatesFk) {
		this.presetstemplatesFk = presetstemplatesFk;
	}
	public String getFieldLabel() {
		return fieldLabel;
	}
	public void setFieldLabel(String fieldLabel) {
		this.fieldLabel = fieldLabel;
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