package com.adams.dt.pojo;

import java.io.Serializable;

public class Phases implements Serializable {

    static final long serialVersionUID = 103844514947365244L; 
    
    private int phaseId; 
    private String phaseCode;
    private String phaseName;
    private short phaseStatus;
    private java.util.Date phaseStart;
    private java.util.Date phaseEndPlanified;
    private java.util.Date phaseEnd;
    private int phaseDuration;
    private int phaseDelay;
    private int projectFk; 
    private Integer phaseTemplateFK;
	public Phases() {
    	
    }
    /* phase_ID, PK */
    public int getPhaseId() {
        return phaseId;
    }

    /* phase_ID, PK */
    public void setPhaseId(int phaseId) {
        this.phaseId = phaseId;
       
    }
 
 
    public String getPhaseCode() {
        return phaseCode;
    }

    /* phase_code */
    public void setPhaseCode(String phaseCode) {
        this.phaseCode = phaseCode;
    }

    /* phase_name */
    public String getPhaseName() {
        return phaseName;
    }

    /* phase_name */
    public void setPhaseName(String phaseName) {
        this.phaseName = phaseName;
    }

    /* phase_status */
    public short getPhaseStatus() {
        return phaseStatus;
    }

    /* phase_status */
    public void setPhaseStatus(short phaseStatus) {
        this.phaseStatus = phaseStatus;
    }
 
    /* phase_start */
    public java.util.Date getPhaseStart() {
        return phaseStart;
    }

    /* phase_start */
    public void setPhaseStart(java.util.Date phaseStart) {
        this.phaseStart = phaseStart;
    }

    /* phase_end_planified */
    public java.util.Date getPhaseEndPlanified() {
        return phaseEndPlanified;
    }

    /* phase_end_planified */
    public void setPhaseEndPlanified(java.util.Date phaseEndPlanified) {
        this.phaseEndPlanified = phaseEndPlanified;
    }

    /* phase_end */
    public java.util.Date getPhaseEnd() {
        return phaseEnd;
    }

    /* phase_end */
    public void setPhaseEnd(java.util.Date phaseEnd) {
        this.phaseEnd = phaseEnd;
    }

    /* phase_duration */
    public int getPhaseDuration() {
        return phaseDuration;
    }

    /* phase_duration */
    public void setPhaseDuration(int phaseDuration) {
        this.phaseDuration = phaseDuration;
    }

    /* phase_delay */
    public int getPhaseDelay() {
        return phaseDelay;
    }

    /* phase_delay */
    public void setPhaseDelay(int phaseDelay) {
        this.phaseDelay = phaseDelay;
    }  
	public Integer getProjectFk() {
		return projectFk;
	}
	public void setProjectFk(Integer projectFk) {
		this.projectFk = projectFk;
	}
	public Integer getPhaseTemplateFK() {
		return phaseTemplateFK;
	}
	public void setPhaseTemplateFK(Integer phaseTemplateFK) {
		this.phaseTemplateFK = phaseTemplateFK;
	} 
	
}