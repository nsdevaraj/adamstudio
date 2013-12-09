package com.adams.dt.pojo;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;  
import java.sql.Blob;
import java.sql.SQLException;

import org.hibernate.Hibernate;

/*
 * For Table lang
 */ 
public class Languages implements Serializable{

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;	
    
	protected int id;    
	protected String formid;
	protected byte[] frenchlbl;
	protected String englishlbl;
	protected Blob frenchblob;
    public Languages() {
    }

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFormid() {
		return formid;
	}

	public void setFormid(String formid) {
		this.formid = formid;
	}
	



	public byte[] getFrenchlbl() {
		return frenchlbl;
	}

	public void setFrenchlbl(byte[] frenchlbl) {
		this.frenchlbl = frenchlbl;
		try { 
			if(frenchlbl!=null) {
				frenchblob = Hibernate.createBlob(frenchlbl);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// handled by hibernate 
	public Blob getFrenchblob() {
		return frenchblob;
	}

	public void setFrenchblob(Blob frenchblob) {
		this.frenchblob = frenchblob; 
		/*try {  
			if(frenchblob!=null) {
				int tempInt = (int) frenchblob.length();  
				this.frenchlbl = frenchblob.getBytes(1, tempInt);
			}
		} 
		catch (Exception e) {  
			e.printStackTrace();
		}*/  		
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		  try {
			  this.frenchlbl =  toByteArrayImpl(frenchblob, baos);
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
	
	public String getEnglishlbl() {
		return englishlbl;
	}

	public void setEnglishlbl(String englishlbl) {
		this.englishlbl = englishlbl;
	}
 
}