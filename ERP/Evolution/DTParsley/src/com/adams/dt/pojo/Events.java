package com.adams.dt.pojo;

import java.io.Serializable;
import java.util.Date; 
  
public class Events implements Serializable {

  	
    /**
	 * 
	 */
	private static final long serialVersionUID = 601516304116481509L;
	private int eventId;
	private Date eventDateStart;
    private int eventType; 
    private String details; 
    private int taskFk;
    private int personFk;
    private int projectFk;
    private String eventName;
    public Events() {
    	
    }

    /* event_ID, PK */
    public int getEventId() {
        return eventId;
    }

    /* event_ID, PK */
    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    /* event_date_start */
    public java.util.Date getEventDateStart() {
        return eventDateStart;
    }

    /* event_date_start */
    public void setEventDateStart(Date eventDateStart) {
        this.eventDateStart = eventDateStart;
    }

    /* event_type */
    public int getEventType() {
        return eventType;
    }

    /* event_type */
    public void setEventType(int eventType) {
        this.eventType = eventType;
    }

	public int getPersonFk() {
		return personFk;
	}

	public void setPersonFk(int personFk) {
		this.personFk = personFk;
	} 	 

	public int getTaskFk() {
		return taskFk;
	}

	public void setTaskFk(int taskFk) {
		this.taskFk = taskFk;
	}
	
	/* details */
    public String getDetails() {
        return details;
    }

    /* details */
    public void setDetails(String details) {
        this.details = details;
    }

	public int getProjectFk() {
		return projectFk;
	}

	public void setProjectFk(int projectFk) {
		this.projectFk = projectFk;
	}
	
    public String getEventName() {
        return eventName;
    }

    
    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

}