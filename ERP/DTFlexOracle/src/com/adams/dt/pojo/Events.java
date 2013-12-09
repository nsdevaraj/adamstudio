package com.adams.dt.pojo;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.Date; 

import org.hibernate.Hibernate;
  
public class Events implements Serializable {

  	
    /**
	 * 
	 */
	private static final long serialVersionUID = 601516304116481509L;
	private int eventId;
	private Date eventDateStart;
    private int eventType; 
    private Blob details_blob;  
    private byte[] details;   
    private int taskFk;
    private int personFk;
    private int projectFk;
    private String eventName;
    private int workflowtemplatesFk;
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
    public byte[] getDetails() {
    	return getDetailsAsByteArray() ;
    }

    private String getDetailsAsString() {
    	String details = null;
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			if(this.details_blob!=null) {
				byte[] b =  toByteArrayImpl(this.details_blob, baos);
				details = new String(b);
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
		return details;
    }
    
    private byte[] getDetailsAsByteArray() {
    	byte[] b =  null;
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			if(this.details_blob!=null) {
				b =  toByteArrayImpl(this.details_blob, baos);
				//details = new String(b);
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
		return b;
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
    
    /* details */
    public void setDetails(byte[] details) {
        this.details = details;
        try {
        	if(this.details!=null) {
        		//byte[] b = this.details.getBytes();
        		this.details_blob = Hibernate.createBlob(details);
        	}
        } catch (Exception e) {
        	e.printStackTrace();
        }
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

	public Blob getDetails_blob() {
		return details_blob;
	}

	public void setDetails_blob(Blob details_blob) {
		this.details_blob = details_blob;
	}

	public int getWorkflowtemplatesFk() {
		return workflowtemplatesFk;
	}

	public void setWorkflowtemplatesFk(int workflowtemplatesFk) {
		this.workflowtemplatesFk = workflowtemplatesFk;
	}
 
}