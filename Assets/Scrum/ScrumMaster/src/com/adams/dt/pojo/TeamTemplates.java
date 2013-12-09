package com.adams.dt.pojo;

/*
 * For Table team_templates
 */
public class TeamTemplates implements java.io.Serializable, Cloneable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/* team_template_ID, PK */
    protected int teamTemplateId;
    protected int workflowFk; 

    /* team_template_label */
    protected String teamTemplateLabel;

    /* team_template_ID, PK */
    public int getTeamTemplateId() {
        return teamTemplateId;
    }

    /* team_template_ID, PK */
    public void setTeamTemplateId(int teamTemplateId) {
        this.teamTemplateId = teamTemplateId;
    }
 
	/* team_template_label */
    public String getTeamTemplateLabel() {
        return teamTemplateLabel;
    }

    /* team_template_label */
    public void setTeamTemplateLabel(String teamTemplateLabel) {
        this.teamTemplateLabel = teamTemplateLabel;
    }

   	public int getWorkflowFk() {
		return workflowFk;
	}

	public void setWorkflowFk(int workflowFk) {
		this.workflowFk = workflowFk;
	}
}