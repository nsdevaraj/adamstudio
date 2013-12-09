package com.adams.dt.pojo; 
 
import java.util.Set; 
import java.util.Date;
/*
 * For Table tasks
 */
public class Tasks implements java.io.Serializable, Cloneable {

	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Set<Events> eventSet;
	
    /* task_ID, PK */
    protected Integer taskId;
    protected Projects projectObject; 
    /* project_FK */
    protected Tasks previousTask;
    protected Tasks nextTask;
    protected Integer taskStatusFK;
    
    protected Integer personFK;
    protected Integer projectFk;
    /* workflow_template_FK */
    protected Integer wftFK;
    /* task_comment */
    protected byte[] taskComment;

    /* task_files_path */
    protected FileDetails fileObj;
 
    /* t_date_creation */
    protected Date tDateCreation;

    /* t_date_inprogress */
    protected Date tDateInprogress;

    /* t_date_end */
    protected Date tDateEnd;

    /* t_date_end_estimated */
    protected Date tDateEndEstimated;

    /* t_date_deadline */
    protected Date tDateDeadline;

    /* waiting_time */
    protected Integer waitingTime;

    /* onair_time */
    protected Integer onairTime;

    /* estimated_time */
    protected Integer estimatedTime;

    /* deadline_time */
    protected Integer deadlineTime;
 
    /* task_form_code */
    protected String taskFormCode;
 
	public Integer getTaskId() {
		return taskId;
	}
	public void setTaskId(Integer taskId) {
		this.taskId = taskId;
	}
	public Projects getProjectObject() {
		return projectObject;
	}
	public void setProjectObject(Projects projectObject) {
		this.projectObject = projectObject;
	}
	public Tasks getPreviousTask() {
		return previousTask;
	}
	public void setPreviousTask(Tasks previousTask) {
		this.previousTask = previousTask;
	}
	public Tasks getNextTask() {
		return nextTask;
	}
	public void setNextTask(Tasks nextTask) {
		this.nextTask = nextTask;
	} 
	public Integer getTaskStatusFK() {
		return taskStatusFK;
	}
	public void setTaskStatusFK(Integer taskStatusFK) {
		this.taskStatusFK = taskStatusFK;
	}
	public Integer getPersonFK() {
		return personFK;
	}
	public void setPersonFK(Integer personFK) {
		this.personFK = personFK;
	}
	public Integer getProjectFk() {
		return projectFk;
	}
	public void setProjectFk(Integer projectFk) {
		this.projectFk = projectFk;
	} 
	public byte[] getTaskComment() {
		return taskComment;
	}
	public void setTaskComment(byte[] taskComment) {
		this.taskComment = taskComment;
	}
	public Date gettDateCreation() {
		return tDateCreation;
	}
	public void settDateCreation(Date dateCreation) {
		tDateCreation = dateCreation;
	}
	public Date gettDateInprogress() {
		return tDateInprogress;
	}
	public void settDateInprogress(Date dateInprogress) {
		tDateInprogress = dateInprogress;
	}
	public Date gettDateEnd() {
		return tDateEnd;
	}
	public void settDateEnd(Date dateEnd) {
		tDateEnd = dateEnd;
	}
	public Date gettDateEndEstimated() {
		return tDateEndEstimated;
	}
	public void settDateEndEstimated(Date dateEndEstimated) {
		tDateEndEstimated = dateEndEstimated;
	}
	public Date gettDateDeadline() {
		return tDateDeadline;
	}
	public void settDateDeadline(Date dateDeadline) {
		tDateDeadline = dateDeadline;
	}
	public Integer getWaitingTime() {
		return waitingTime;
	}
	public void setWaitingTime(Integer waitingTime) {
		this.waitingTime = waitingTime;
	}
	public Integer getOnairTime() {
		return onairTime;
	}
	public void setOnairTime(Integer onairTime) {
		this.onairTime = onairTime;
	}
	public Integer getEstimatedTime() {
		return estimatedTime;
	}
	public void setEstimatedTime(Integer estimatedTime) {
		this.estimatedTime = estimatedTime;
	}
	public Integer getDeadlineTime() {
		return deadlineTime;
	}
	public void setDeadlineTime(Integer deadlineTime) {
		this.deadlineTime = deadlineTime;
	}
	public String getTaskFormCode() {
		return taskFormCode;
	}
	public void setTaskFormCode(String taskFormCode) {
		this.taskFormCode = taskFormCode;
	}
   
	public FileDetails getFileObj() {
		return fileObj;
	}
	public void setFileObj(FileDetails fileObj) {
		this.fileObj = fileObj;
	}
	public Integer getWftFK() {
		return wftFK;
	}
	public void setWftFK(Integer wftFK) {
		this.wftFK = wftFK;
	}
}
