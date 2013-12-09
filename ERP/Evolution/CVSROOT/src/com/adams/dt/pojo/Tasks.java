package com.adams.dt.pojo; 
 
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.Date;
import java.util.Set;

import org.hibernate.Hibernate;
/*
 * For Table tasks
 */
public class Tasks implements java.io.Serializable, Cloneable {

	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
 
    /* task_ID, PK */
    private Integer taskId; 
    /* project_FK */
    private Tasks previousTask;
    private Tasks nextTask;
    private Integer taskStatusFK;
    
    private Integer personFK;
    private int projectFk;
    /* workflow_template_FK */
    private Integer wftFK;
    /* task_comment */
    private byte[] taskComment;
    //private Blob taskCommentBlob;

    /* task_files_path */
    private FileDetails fileObj;
 
    /* t_date_creation */
    private Date tDateCreation;

    /* t_date_inprogress */
    private Date tDateInprogress;

    /* t_date_end */
    private Date tDateEnd;

    /* t_date_end_estimated */
    private Date tDateEndEstimated;

    /* t_date_deadline */
    private Date tDateDeadline;

    /* waiting_time */
    private Integer waitingTime;

    /* onair_time */
    private Integer onairTime;

    /* estimated_time */
    private Integer estimatedTime;

    /* deadline_time */
    private Integer deadlineTime;
 
    /* task_form_code */
    private String taskFormCode;
 
	public Integer getTaskId() {
		return taskId;
	}
	public void setTaskId(Integer taskId) {
		this.taskId = taskId;
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
	public int getProjectFk() {
		return projectFk;
	}
	public void setProjectFk(int projectFk) {
		this.projectFk = projectFk;
	}
	public byte[] getTaskComment() {
		return taskComment;
	}
	public void setTaskComment(byte[] taskComment) {
		this.taskComment = taskComment;
		/*try { 
			if(taskComment!=null) {				
				this.taskCommentBlob = (java.sql.Blob)Hibernate.createBlob(this.taskComment);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}*/
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
	public Blob getTaskCommentBlob() {
		if(this.taskComment!=null) {
			return Hibernate.createBlob(this.taskComment);
		} else { 
			return null;
		}
	}
	public void setTaskCommentBlob(Blob taskCommentBlob) {
		if(taskCommentBlob!=null) {
			this.taskComment = toByteArray(taskCommentBlob);
		}		
	}
	
	private byte[] toByteArray(Blob fromBlob) {
		 ByteArrayOutputStream baos = new ByteArrayOutputStream();
		 try {
			 return toByteArrayImpl(fromBlob, baos);
		 } catch (SQLException e) {
			 throw new RuntimeException(e);
		 } catch (IOException e) {
			 throw new RuntimeException(e);
		 } finally {
			 if (baos != null) {
				 try {
					 baos.close();
				 } catch (IOException ex) {
				 }
		 	}
		 }
	}

	private byte[] toByteArrayImpl(Blob fromBlob, ByteArrayOutputStream baos) throws SQLException, IOException {
	  byte[] buf = new byte[4000];
	  InputStream is = fromBlob.getBinaryStream();
	  try {
		  for (;;) {
			  int dataSize = is.read(buf);

			  if (dataSize == -1)
				  break;
			  baos.write(buf, 0, dataSize);
		  }
	  	} finally {
	  		if (is != null) {
	  			try {
	  				is.close();
	  			} catch (IOException ex) {
	  			}
	  		}
	  	}
	  	return baos.toByteArray();
	}
}
