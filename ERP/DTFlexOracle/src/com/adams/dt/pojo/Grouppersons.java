package com.adams.dt.pojo;

import java.io.Serializable;



public class Grouppersons implements Serializable {

    static final long serialVersionUID = 103844514947365244L;

    private int groupPersonId;
    private int groupFk;
    private int personFk;

    public Grouppersons() {

    }

    /* group_person_ID, PK */
    public int getGroupPersonId() {
        return groupPersonId;
    }

    /* group_person_ID, PK */
    public void setGroupPersonId(int groupPersonId) {
        this.groupPersonId = groupPersonId;

    }

    /* group_FK */
    public int getGroupFk() {
        return groupFk;
    }

    /* group_FK */
    public void setGroupFk(int groupFk) {
        this.groupFk = groupFk;
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