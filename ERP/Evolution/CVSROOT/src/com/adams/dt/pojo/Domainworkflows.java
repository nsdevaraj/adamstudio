package com.adams.dt.pojo;

import java.io.Serializable;

 

public class Domainworkflows implements Serializable {

    static final long serialVersionUID = 103844514947365244L;
    
    private int domainWorkflowId;
    private int domainFk;
    private int workflowFk;
   
    public Domainworkflows() {
    	
    }

    /* domain_workflow_ID, PK */
    public int getDomainWorkflowId() {
        return domainWorkflowId;
    }

    /* domain_workflow_ID, PK */
    public void setDomainWorkflowId(int domainWorkflowId) {
        this.domainWorkflowId = domainWorkflowId;
    }

    /* domain_FK */
    public int getDomainFk() {
        return domainFk;
    }

    /* domain_FK */
    public void setDomainFk(int domainFk) {
        this.domainFk = domainFk;
    }

    /* workflow_FK */
    public int getWorkflowFk() {
        return workflowFk;
    }

    /* workflow_FK */
    public void setWorkflowFk(int workflowFk) {
        this.workflowFk = workflowFk;
    }
	
	 
}