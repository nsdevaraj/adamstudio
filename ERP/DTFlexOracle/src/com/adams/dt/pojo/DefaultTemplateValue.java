/*
 * This java source file is generated by DAO4J v1.16
 * Generated on Fri Mar 20 11:39:50 IST 2009
 * For more information, please contact b-i-d@163.com
 * Please check http://members.lycos.co.uk/dao4j/ for the latest version.
 */

package com.adams.dt.pojo;

import java.io.Serializable; 
import java.util.Set;

/*
 * For Table groups
 */
public class DefaultTemplateValue implements Serializable {
	 
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	  /* group_ID, PK */
    protected int defaultTemplateValueId;  
    protected String defaultTemplateValue;  
    protected int propertiesPresetFK;
    protected int defaultTemplateFK;
	public int getDefaultTemplateValueId() {
		return defaultTemplateValueId;
	}
	public void setDefaultTemplateValueId(int defaultTemplateValueId) {
		this.defaultTemplateValueId = defaultTemplateValueId;
	}
	public String getDefaultTemplateValue() {
		return defaultTemplateValue;
	}
	public void setDefaultTemplateValue(String defaultTemplateValue) {
		this.defaultTemplateValue = defaultTemplateValue;
	}
	public int getPropertiesPresetFK() {
		return propertiesPresetFK;
	}
	public void setPropertiesPresetFK(int propertiesPresetFK) {
		this.propertiesPresetFK = propertiesPresetFK;
	}
	public int getDefaultTemplateFK() {
		return defaultTemplateFK;
	}
	public void setDefaultTemplateFK(int defaultTemplateFK) {
		this.defaultTemplateFK = defaultTemplateFK;
	} 
 
}