/*
 * This java source file is generated by DAO4J v1.16
 * Generated on Wed May 05 11:29:43 GMT+05:30 2010
 * For more information, please contact b-i-d@163.com
 * Please check http://members.lycos.co.uk/dao4j/ for the latest version.
 */

package com.adams.scrum.pojo;

/*
 * For Table teammembers
 */
public class Teammembers implements java.io.Serializable, Cloneable {

    /* teammember_ID, PK */
    protected int teammemberId;

    /* team_FK */
    protected int teamFk;

    /* profile_FK */
    protected int profileFk;

    /* person_FK */
    protected int personFk;
 

    /* teammember_ID, PK */
    public int getTeammemberId() {
        return teammemberId;
    }

    /* teammember_ID, PK */
    public void setTeammemberId(int teammemberId) {
        this.teammemberId = teammemberId;
    }

    /* team_FK */
    public int getTeamFk() {
        return teamFk;
    }

    /* team_FK */
    public void setTeamFk(int teamFk) {
        this.teamFk = teamFk;
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

    /* Indicates whether some other object is "equal to" this one. */
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || !(obj instanceof Teammembers))
            return false;

        Teammembers bean = (Teammembers) obj;

        if (this.teammemberId != bean.teammemberId)
            return false;

        if (this.teamFk != bean.teamFk)
            return false;

        if (this.profileFk != bean.profileFk)
            return false;

        if (this.personFk != bean.personFk)
            return false;

        return true;
    }

    /* Creates and returns a copy of this object. */
    public Object clone()
    {
        Teammembers bean = new Teammembers();
        bean.teammemberId = this.teammemberId;
        bean.teamFk = this.teamFk;
        bean.profileFk = this.profileFk;
        bean.personFk = this.personFk;
        return bean;
    }

    /* Returns a string representation of the object. */
    public String toString() {
        String sep = "\r\n";
        StringBuffer sb = new StringBuffer();
        sb.append(this.getClass().getName()).append(sep);
        sb.append("[").append("teammemberId").append(" = ").append(teammemberId).append("]").append(sep);
        sb.append("[").append("teamFk").append(" = ").append(teamFk).append("]").append(sep);
        sb.append("[").append("profileFk").append(" = ").append(profileFk).append("]").append(sep);
        sb.append("[").append("personFk").append(" = ").append(personFk).append("]").append(sep);
        return sb.toString();
    }
}