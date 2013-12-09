package com.adams.dt.pojo;

import java.io.Serializable; 
import java.util.Date; 
 

public class FileDetails implements Serializable {

    static final long serialVersionUID = 103844514947365244L;

    protected int fileId;
    protected String fileName;
    protected String filePath;
    protected Date fileDate;
	protected int taskId;
	protected int categoryFK;
	protected String type;
	protected String storedFileName;
	protected int projectFK;
	protected int releaseStatus;
	protected Boolean visible;
	protected String miscelleneous;
	protected String fileCategory;
	protected String page;

    public String getStoredFileName() {
		return storedFileName;
	}

	public void setStoredFileName(String storedFileName) {
		this.storedFileName = storedFileName;
	}

	public FileDetails() {

    }

	public int getFileId() {
		return fileId;
	}

	public void setFileId(int fileId) {
		this.fileId = fileId;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}


	public int getCategoryFK() {
		return categoryFK;
	}

	public void setCategoryFK(int categoryFK) {
		this.categoryFK = categoryFK;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getProjectFK() {
		return projectFK;
	}

	public void setProjectFK(int projectFK) {
		this.projectFK = projectFK;
	}

	public int getReleaseStatus() {
		return releaseStatus;
	}

	public void setReleaseStatus(int releaseStatus) {
		this.releaseStatus = releaseStatus;
	}

	public Boolean getVisible() {
		return visible;
	}

	public void setVisible(Boolean visible) {
		this.visible = visible;
	}

	public String getMiscelleneous() {
		return miscelleneous;
	}

	public void setMiscelleneous(String miscelleneous) {
		this.miscelleneous = miscelleneous;
	}

	public int getTaskId() {
		return taskId;
	}

	public void setTaskId(int taskId) {
		this.taskId = taskId;
	}

	public String getFileCategory() {
		return fileCategory;
	}

	public void setFileCategory(String fileCategory) {
		this.fileCategory = fileCategory;
	}

	public String getPage() {
		return page;
	}

	public void setPage(String page) {
		this.page = page;
	}

	public Date getFileDate() {
		return fileDate;
	}

	public void setFileDate(Date fileDate) {
		this.fileDate = fileDate;
	}

	


}