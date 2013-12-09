package com.adams.dt.pojo;

import java.io.Serializable; 

public class Workflows implements Serializable {

    static final long serialVersionUID = 103844514947365244L;
     
    
    private int workflowId;
    private String workflowLabel;
    private String workflowCode; 
     
    private Categories domainFk;
    
    public Categories getDomainFk() {
		return domainFk;
	}
	public void setDomainFk(Categories domainFk) {
		this.domainFk = domainFk;
	}
	public Workflows() {    	
    }
      /* workflow_ID, PK */
    public int getWorkflowId() {
        return workflowId;
    }

    /* workflow_ID, PK */
    public void setWorkflowId(int workflowId) {
        this.workflowId = workflowId;
     
    }

    /* workflow_label */
    public String getWorkflowLabel() {
        return workflowLabel;
    }

    /* workflow_label */
    public void setWorkflowLabel(String workflowLabel) {
        this.workflowLabel = workflowLabel;
    }

    /* workflow_code */
    public String getWorkflowCode() {
        return workflowCode;
    }

    /* workflow_code */
    public void setWorkflowCode(String workflowCode) {
        this.workflowCode = workflowCode;
    }
  
}