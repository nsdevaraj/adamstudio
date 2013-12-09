package com.adams.dt.pojo;

/*
 * For Table teamlines
 */
public class Teamlines implements java.io.Serializable, Cloneable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/* teamline_ID, PK */
    protected int teamlineId;
 
    /* project_FK */
    protected Integer projectID;

    /* profile_FK */
    protected Integer profileID;

    /* person_FK */
    protected Integer personID;
    
    /* teamline_ID, PK */
    public int getTeamlineId() {
        return teamlineId;
    }

    /* teamline_ID, PK */
    public void setTeamlineId(int teamlineId) {
        this.teamlineId = teamlineId;
    }
 
	public Integer getProjectID() {
		return projectID;
	}

	public void setProjectID(Integer projectID) {
		this.projectID = projectID;
	}

	public Integer getProfileID() {
		return profileID;
	}

	public void setProfileID(Integer profileID) {
		this.profileID = profileID;
	}

	public Integer getPersonID() {
		return personID;
	}

	public void setPersonID(Integer personID) {
		this.personID = personID;
	}
 
}