/*
 * This java source file is generated by DAO4J v1.16
 * Generated on Fri Mar 20 11:39:57 IST 2009
 * For more information, please contact b-i-d@163.com
 * Please check http://members.lycos.co.uk/dao4j/ for the latest version.
 */

package com.adams.dt.pojo;

import java.io.Serializable;
import java.util.Set;

public class Tags implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	protected int tagId;
	protected int fileFK;
	protected String tagLabel;

	private Set<FileDetails> filesetObject;

	public Tags() {

	}

	/**
	 * @return the tagId
	 */
	public int getTagId() {
		return tagId;
	}

	/**
	 * @param tagId the tagId to set
	 */
	public void setTagId(int tagId) {
		this.tagId = tagId;
	}

	/**
	 * @return the fileFK
	 */
	public int getFileFK() {
		return fileFK;
	}

	/**
	 * @param fileFK the fileFK to set
	 */
	public void setFileFK(int fileFK) {
		this.fileFK = fileFK;
	}

	/**
	 * @return the tagLabel
	 */
	public String getTagLabel() {
		return tagLabel;
	}

	/**
	 * @param tagLabel the tagLabel to set
	 */
	public void setTagLabel(String tagLabel) {
		this.tagLabel = tagLabel;
	}

	/**
	 * @return the filesetObject
	 */
	public Set<FileDetails> getFilesetObject() {
		return filesetObject;
	}

	/**
	 * @param filesetObject the filesetObject to set
	 */
	public void setFilesetObject(Set<FileDetails> filesetObject) {
		this.filesetObject = filesetObject;
	}
 


}