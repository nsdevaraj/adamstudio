package com.adams.dt.pojo;

import java.io.Serializable;
import java.sql.Date; 

import com.mysql.jdbc.Blob;

public class Notes implements Serializable {

	static final long serialVersionUID = 103844514947365244L;

	protected int commentID;
	protected String commentTitle;
	protected int commentX;
	protected int commentY;
	protected int commentBoxX;
	protected int commentBoxY;
	protected boolean commentMaximize;
	protected String misc;
	protected String commentStatus;
	protected int commentWidth;
	protected int commentHeight;
	protected int commentColor;
	protected byte[] commentDescription;
	protected Date creationDate;
	protected int createdby; 
	protected int filefk;  
	protected int commentType;
	protected Integer history;

	public int getCommentID() {
		return commentID;
	}

	public void setCommentID(int commentID) {
		this.commentID = commentID;
	}

	public String getCommentTitle() {
		return commentTitle;
	}

	public void setCommentTitle(String commentTitle) {
		this.commentTitle = commentTitle;
	}

	public int getCommentX() {
		return commentX;
	}

	public void setCommentX(int commentX) {
		this.commentX = commentX;
	}

	public int getCommentY() {
		return commentY;
	}

	public void setCommentY(int commentY) {
		this.commentY = commentY;
	}
	
	public int getCommentBoxX() {
		return commentBoxX;
	}

	public void setCommentBoxX(int commentBoxX) {
		this.commentBoxX = commentBoxX;
	}
	
	public int getCommentBoxY() {
		return commentBoxY;
	}
	
	public void setCommentMaximize(boolean commentMaximize) {
		this.commentMaximize = commentMaximize;
	}
	
	public String getMisc() {
		return misc;
	}
	
	public void setCommentStatus(String commentStatus) {
		this.commentStatus = commentStatus;
	}
	
	public String getCommentStatus() {
		return commentStatus;
	}
	
	public void setMisc(String misc) {
		this.misc = misc;
	}
	
	public boolean getCommentMaximize() {
		return commentMaximize;
	}

	public void setCommentBoxY(int commentBoxY) {
		this.commentBoxY = commentBoxY;
	}
	
	public int getCommentWidth() {
		return commentWidth;
	}

	public void setCommentWidth(int commentWidth) {
		this.commentWidth = commentWidth;
	}

	public int getCommentHeight() {
		return commentHeight;
	}

	public void setCommentHeight(int commentHeight) {
		this.commentHeight = commentHeight;
	}

	public int getCommentColor() {
		return commentColor;
	}

	public void setCommentColor(int commentColor) {
		this.commentColor = commentColor;
	}

	public byte[] getCommentDescription() {
		return commentDescription;
	}

	public void setCommentDescription(byte[] commentDescription) {
		this.commentDescription = commentDescription;
	}

	public Date getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	} 
	
	public int getCreatedby() {
		return createdby;
	}

	public void setCreatedby(int createdby) {
		this.createdby = createdby;
	}

	public int getCommentType() {
		return commentType;
	}

	public void setCommentType(int commentType) {
		this.commentType = commentType;
	}

	public int getFilefk() {
		return filefk;
	}

	public void setFilefk(int filefk) {
		this.filefk = filefk;
	}

	public Integer getHistory() {
		return history;
	}

	public void setHistory(Integer history) {
		this.history = history;
	} 
	

}