package com.adams.dt.pojo;

import java.io.Serializable;

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
    }
 
 
}