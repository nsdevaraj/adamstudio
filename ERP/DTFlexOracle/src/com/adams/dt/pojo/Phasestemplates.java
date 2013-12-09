package com.adams.dt.pojo;

import java.io.Serializable;

public class Phasestemplates implements Serializable {

    static final long serialVersionUID = 103844514947365244L;
     
    private int phaseTemplateId;  
    private String phaseName;
    private short phaseDurationDays;
    private int workflowId;
      
    public Phasestemplates() {
    	
    }

    
    /* phase_template_ID, PK */
    public int getPhaseTemplateId() {
        return phaseTemplateId;
    }

    /* phase_template_ID, PK */
    public void setPhaseTemplateId(int phaseTemplateId) {
        this.phaseTemplateId = phaseTemplateId;
    } 
    /* phase_name */
    public String getPhaseName() {
        return phaseName;
    }

    /* phase_name */
    public void setPhaseName(String phaseName) {
        this.phaseName = phaseName;
    }

    /* phase_duration_days */
    public short getPhaseDurationDays() {
        return phaseDurationDays;
    }

    /* phase_duration_days */
    public void setPhaseDurationDays(short phaseDurationDays) {
        this.phaseDurationDays = phaseDurationDays;
    }
  

	public int getWorkflowId() {
		return workflowId;
	}


	public void setWorkflowId(int workflowId) {
		this.workflowId = workflowId;
	}

	
}