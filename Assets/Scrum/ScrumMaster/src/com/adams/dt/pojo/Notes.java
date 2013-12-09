package com.adams.dt.pojo;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.sql.Date; 
import java.sql.SQLException;

import java.sql.Blob;

import org.hibernate.Hibernate;

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
	protected Blob commentDescriptionBlob;
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
		try {
			if(commentDescription!=null) {
				this.commentDescriptionBlob = Hibernate.createBlob(commentDescription);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
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

	public Blob getCommentDescriptionBlob() {
		return commentDescriptionBlob;
	}

	public void setCommentDescriptionBlob(Blob commentDescriptionBlob) {
		this.commentDescriptionBlob = commentDescriptionBlob;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		  try {
			  if(commentDescriptionBlob!=null) {
				  this.commentDescription =  toByteArrayImpl(commentDescriptionBlob, baos);
			  }
		  } catch (SQLException e) {
			  e.printStackTrace();
		  } catch (IOException e) {
			  e.printStackTrace();
		  } catch (Exception e) {
			  e.printStackTrace();
		  } finally {
			  if (baos != null) {
				  try {
					  baos.close();
				  } catch (IOException ex) {
					  ex.printStackTrace();
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