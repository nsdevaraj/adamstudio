package com.adams.dt.pojo;

/*
 * For Table teamlines_templates
 */
public class Teamlinestemplates implements java.io.Serializable, Cloneable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/* teamline_template_ID, PK */
    protected int teamlineTemplateId;

    /* team_template_FK */
    protected int teamTemplateFk;

    /* profile_FK */
    protected int profileFk;

    /* person_FK */
    protected int personFk;
     

    /* teamline_template_ID, PK */
    public int getTeamlineTemplateId() {
        return teamlineTemplateId;
    }

    /* teamline_template_ID, PK */
    public void setTeamlineTemplateId(int teamlineTemplateId) {
        this.teamlineTemplateId = teamlineTemplateId;
    }

    /* team_template_FK */
    public int getTeamTemplateFk() {
        return teamTemplateFk;
    }

    /* team_template_FK */
    public void setTeamTemplateFk(int teamTemplateFk) {
        this.teamTemplateFk = teamTemplateFk;
    }

    /* profile_FK */
    public int getProfileFk() {
        return profileFk;
    }

    /* profile_FK */
    public void setProfileFk(int profileFk) {
        this.profileFk = profileFk;
    }

    /* person_FK */
    public int getPersonFk() {
        return personFk;
    }

    /* person_FK */
    public void setPersonFk(int personFk) {
        this.personFk = personFk;
    }
}