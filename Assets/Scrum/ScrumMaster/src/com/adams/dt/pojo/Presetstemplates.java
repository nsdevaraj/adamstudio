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
public class Presetstemplates implements Serializable {
	  
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected int presetstemplateId; 
    protected String presetTemplateLabel;
    protected int impremiurfk;
    protected Set<Propertiespresets> propertiesPresetSet;
	public int getPresetstemplateId() {
		return presetstemplateId;
	}
	public void setPresetstemplateId(int presetstemplateId) {
		this.presetstemplateId = presetstemplateId;
	}
	public String getPresetTemplateLabel() {
		return presetTemplateLabel;
	}
	public void setPresetTemplateLabel(String presetTemplateLabel) {
		this.presetTemplateLabel = presetTemplateLabel;
	}
	public int getImpremiurfk() {
		return impremiurfk;
	}
	public void setImpremiurfk(int impremiurfk) {
		this.impremiurfk = impremiurfk;
	}
	public Set<Propertiespresets> getPropertiesPresetSet() {
		return propertiesPresetSet;
	}
	public void setPropertiesPresetSet(Set<Propertiespresets> propertiesPresetSet) {
		this.propertiesPresetSet = propertiesPresetSet;
	} 
}