package com.adams.dt.pojo;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.sql.Blob;
import java.sql.SQLException;

import org.hibernate.Hibernate;

/*
 * For Table profiles
 */
public class Profiles implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/* Profile_ID, PK */
    protected int profileId;  
    /* Profile_label */
    protected String profileLabel;

    /* Profile_code */
    protected String profileCode;

    /* Profile_bckgd_image */
    protected byte[] profileBckgdImage;
    protected Blob profileBckgdImageBlob;
    
    /* Profile_ID, PK */
    public int getProfileId() {
        return profileId;
    }

    /* Profile_ID, PK */
    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    /* Profile_label */
    public String getProfileLabel() {
        return profileLabel;
    }

    /* Profile_label */
    public void setProfileLabel(String profileLabel) {
        this.profileLabel = profileLabel;
    }

    /* Profile_code */
    public String getProfileCode() {
        return profileCode;
    }

    /* Profile_code */
    public void setProfileCode(String profileCode) {
        this.profileCode = profileCode;
    }

    /* Profile_bckgd_image */
    public byte[] getProfileBckgdImage() {
        return profileBckgdImage;
    }

    /* Profile_bckgd_image */
    public void setProfileBckgdImage(byte[] profileBckgdImage) {
        this.profileBckgdImage = profileBckgdImage;
        try {
        	if(profileBckgdImage!=null) {
        		this.profileBckgdImageBlob = Hibernate.createBlob(profileBckgdImage);
        	}
        } catch (Exception e) {
			e.printStackTrace();
		}
    }

	public Blob getProfileBckgdImageBlob() {
		return profileBckgdImageBlob;
	}

	public void setProfileBckgdImageBlob(Blob profileBckgdImageBlob) {
		this.profileBckgdImageBlob = profileBckgdImageBlob;
		/*try {
			if(profileBckgdImageBlob!=null) {
				int len = (int)profileBckgdImageBlob.length();
				this.profileBckgdImage = profileBckgdImageBlob.getBytes(1, len);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		  try {
			  if(profileBckgdImageBlob!=null) {
				  this.profileBckgdImage =  toByteArrayImpl(profileBckgdImageBlob, baos);
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
 
}