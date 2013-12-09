package com.adams.dt.pojo;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable; 
import java.sql.Blob;
import java.sql.SQLException;

import org.hibernate.Hibernate;
 

public class Companies implements Serializable {

    static final long serialVersionUID = 103844514947365244L;

    private int companyid;
    private String companyname;
    private String companycode;
    private Blob companyLogoBlob;
    private byte[] companylogo;
    private String companyCategory; 
    private String companyAddress;
    private String companyPostalCode;
    private String companyCity;
    private String companyCountry;
    private String companyPhone;
    
    public String getCompanyCategory() {
		return companyCategory;
	}

	public void setCompanyCategory(String companyCategory) {
		this.companyCategory = companyCategory;
	}

	public Companies() {

    }

	public int getCompanyid() {
		return companyid;
	}

	public void setCompanyid(int companyid) {
		this.companyid = companyid;
	}

	public String getCompanyname() {
		return companyname;
	}

	public void setCompanyname(String companyname) {
		this.companyname = companyname;
	}
	public String getCompanycode() {
		return companycode;
	}

	public void setCompanycode(String companycode) {
		this.companycode = companycode;
	}

	public byte[] getCompanylogo() {
		return companylogo;
	}

	/*public void setCompanylogo(byte[] companylogo) {
		this.companylogo = companylogo;
	}*/
	
	public void setCompanylogo(byte[] companylogo) {
		this.companylogo = companylogo;
		try { 
			if(companylogo!=null) {
				companyLogoBlob = Hibernate.createBlob(companylogo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// handled by hibernate 
	public Blob getCompanyLogoBlob() {
		return companyLogoBlob;
	}

	public void setCompanyLogoBlob(Blob companyLogoBlob) {
		this.companyLogoBlob = companyLogoBlob; 
		/*try {  
			if(companyLogoBlob!=null) {
				int tempInt = (int) companyLogoBlob.length();  
				this.companylogo = companyLogoBlob.getBytes(1, tempInt);
			}
		} 
		catch (Exception e) {  
			e.printStackTrace();
		}*/  		
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		  try {
			  if(companyLogoBlob!=null) {
				  this.companylogo =  toByteArrayImpl(companyLogoBlob, baos);
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
	
	public String getCompanyAddress() {
		return companyAddress;
	}

	public void setCompanyAddress(String companyAddress) {
		this.companyAddress = companyAddress;
	}

	public String getCompanyPostalCode() {
		return companyPostalCode;
	}

	public void setCompanyPostalCode(String companyPostalCode) {
		this.companyPostalCode = companyPostalCode;
	}

	public String getCompanyCity() {
		return companyCity;
	}

	public void setCompanyCity(String companyCity) {
		this.companyCity = companyCity;
	}

	public String getCompanyCountry() {
		return companyCountry;
	}

	public void setCompanyCountry(String companyCountry) {
		this.companyCountry = companyCountry;
	}

	public String getCompanyPhone() {
		return companyPhone;
	}

	public void setCompanyPhone(String companyPhone) {
		this.companyPhone = companyPhone;
	}
}