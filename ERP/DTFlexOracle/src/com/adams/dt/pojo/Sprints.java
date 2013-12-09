package com.adams.dt.pojo;

import java.io.Serializable;

public class Sprints implements Serializable {

    static final long serialVersionUID = 103844514947365244L; 
    
    private int sprintId; 
    private int domainFK;
    private Tasks sprintTask;
    private String YesterToday;
    private java.util.Date taskDate; 
    private Integer taskTimeSpent;
    private String taskComments;
	public String getTaskComments() {
		return taskComments;
	}
	public void setTaskComments(String taskComments) {
		this.taskComments = taskComments;
	}
	public Sprints() {
    	
    }
	public int getSprintId() {
		return sprintId;
	}
	public void setSprintId(int sprintId) {
		this.sprintId = sprintId;
	}
	public int getDomainFK() {
		return domainFK;
	}
	public void setDomainFK(int domainFK) {
		this.domainFK = domainFK;
	}
	public Tasks getSprintTask() {
		return sprintTask;
	}
	public void setSprintTask(Tasks sprintTask) {
		this.sprintTask = sprintTask;
	}
	public String getYesterToday() {
		return YesterToday;
	}
	public void setYesterToday(String yesterToday) {
		YesterToday = yesterToday;
	}
	public java.util.Date getTaskDate() {
		return taskDate;
	}
	public void setTaskDate(java.util.Date taskDate) {
		this.taskDate = taskDate;
	}
	public Integer getTaskTimeSpent() {
		return taskTimeSpent;
	}
	public void setTaskTimeSpent(Integer taskTimeSpent) {
		this.taskTimeSpent = taskTimeSpent;
	}	
}