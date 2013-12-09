package com.adams.dt.pojo;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.Set;

import org.hibernate.Hibernate;

/*
 * For Table projects
 */
public class Projects implements java.io.Serializable, Cloneable {
	
	
	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Set<Phases> phasesSet;
	 private Set<Propertiespj> propertiespjSet;
	 private Set<Teamlines> teamSet;
	 private int workflowFK;
	 protected int categoryFKey;
    /* Project_ID, PK */
    protected int projectId;

    /* Project_Name */
    protected String projectName;
    
    /* Project_Name */
    protected int presetTemplateID;
    

    /* project_status */
    protected int projectStatusFK;

    /* project_quantity */
    protected short projectQuantity;

    /* project_comment */
    protected byte[] projectComment;
    
    /* project_comment */
    protected Blob projectCommentBlob;

    /* project_date_start */
    protected java.util.Date projectDateStart;

    /* project_date_end */
    protected java.util.Date projectDateEnd;

    /* Project_ID, PK */
    public int getProjectId() {
        return projectId;
    }

    /* Project_ID, PK */
    public void setProjectId(int projectId) {
        this.projectId = projectId;
    }

    /* Project_Name */
    public String getProjectName() {
        return projectName;
    }

    /* Project_Name */
    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }  

    /* project_quantity */
    public short getProjectQuantity() {
        return projectQuantity;
    }

    /* project_quantity */
    public void setProjectQuantity(short projectQuantity) {
        this.projectQuantity = projectQuantity;
    }

    /* project_comment */
    public byte[] getProjectComment() {
        return projectComment;
    }

    /* project_comment */
    public void setProjectComment(byte[] projectComment) {
        this.projectComment = projectComment;
        try { 
        	if(projectComment!=null) {
        		projectCommentBlob = Hibernate.createBlob(projectComment);
        	}
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    /* project_date_start */
    public java.util.Date getProjectDateStart() {
        return projectDateStart;
    }

    /* project_date_start */
    public void setProjectDateStart(java.util.Date projectDateStart) {
        this.projectDateStart = projectDateStart;
    }

    /* project_date_end */
    public java.util.Date getProjectDateEnd() {
        return projectDateEnd;
    }

    /* project_date_end */
    public void setProjectDateEnd(java.util.Date projectDateEnd) {
        this.projectDateEnd = projectDateEnd;
    }
 	public Set<Phases> getPhasesSet() {
		return phasesSet;
	}

	public void setPhasesSet(Set<Phases> phasesSet) {
		this.phasesSet = phasesSet;
	} 
 
	public Set<Propertiespj> getPropertiespjSet() {
		return propertiespjSet;
	}

	public void setPropertiespjSet(Set<Propertiespj> propertiespjSet) {
		this.propertiespjSet = propertiespjSet;
	}
   
 
	public int getCategoryFKey() {
		return categoryFKey;
	}

	public void setCategoryFKey(int categoryFKey) {
		this.categoryFKey = categoryFKey;
	}
 

	public int getWorkflowFK() {
		return workflowFK;
	}

	public void setWorkflowFK(int workflowFK) {
		this.workflowFK = workflowFK;
	}

	public int getPresetTemplateID() {
		return presetTemplateID;
	}

	public void setPresetTemplateID(int presetTemplateID) {
		this.presetTemplateID = presetTemplateID;
	}

	public int getProjectStatusFK() {
		return projectStatusFK;
	}

	public void setProjectStatusFK(int projectStatusFK) {
		this.projectStatusFK = projectStatusFK;
	}

	public Blob getProjectCommentBlob() {
		return projectCommentBlob;
	}

	public void setProjectCommentBlob(Blob projectCommentBlob) {
		this.projectCommentBlob = projectCommentBlob;
		/*try {  
			if(projectCommentBlob!=null) {
				int tempInt = (int) projectCommentBlob.length();  
				this.projectComment = projectCommentBlob.getBytes(1, tempInt);
			}
		} 
		catch (Exception e) {  
			e.printStackTrace();
		}*/
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		  try {
			  if(projectCommentBlob!=null) {
				  this.projectComment =  toByteArrayImpl(projectCommentBlob, baos);
			  }
		  } catch (SQLException e) {
			  throw new RuntimeException(e);
		  } catch (IOException e) {
			  throw new RuntimeException(e);
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

	public Set<Teamlines> getTeamSet() {
		return teamSet;
	}

	public void setTeamSet(Set<Teamlines> teamSet) {
		this.teamSet = teamSet;
	}
	

	
}
