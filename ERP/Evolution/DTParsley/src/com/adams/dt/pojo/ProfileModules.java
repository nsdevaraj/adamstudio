package com.adams.dt.pojo;

import java.io.Serializable;  
/*
 * For Table persons
 */
public class ProfileModules implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public ProfileModules() {
    } 
    protected int profileModuleId;  
    protected int profileFk;
    protected int moduleFk;
	public int getProfileModuleId() {
		return profileModuleId;
	}
	public void setProfileModuleId(int profileModuleId) {
		this.profileModuleId = profileModuleId;
	}
	public int getProfileFk() {
		return profileFk;
	}
	public void setProfileFk(int profileFk) {
		this.profileFk = profileFk;
	}
	public int getModuleFk() {
		return moduleFk;
	}
	public void setModuleFk(int moduleFk) {
		this.moduleFk = moduleFk;
	}       
}