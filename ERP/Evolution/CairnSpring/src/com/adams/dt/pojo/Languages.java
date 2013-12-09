package com.adams.dt.pojo;

import java.io.Serializable;  

/*
 * For Table lang
 */ 
public class Languages implements Serializable{

   	/* id, PK */
	protected int id;    
	/* formid */
	protected String formid;
	/* frenchlbl */
	protected byte[] frenchlbl;
	/* englishlbl */
	protected String englishlbl;
 
	/** 
    * Class constructor.
    */
    public Languages() {
    }

    /**
	 * @return the id to get
	 */
	public int getId() {
		return id;
	}
	/**
	 * @param id 	the id to set
	 */
	public void setId(int id) {
		this.id = id;
	}
	/**
	 * @return the formid to get
	 */
	public String getFormid() {
		return formid;
	}
	/**
	 * @param formid   the formid to set
	 */
	public void setFormid(String formid) {
		this.formid = formid;
	}
	/**
	 * @return the frenchlbl to get
	 */
	public byte[] getFrenchlbl() {
		return frenchlbl;
	}
	/**
	 * @param frenchlbl 	the frenchlbl to set
	 */
	public void setFrenchlbl(byte[] frenchlbl) {
		this.frenchlbl = frenchlbl;
	}
	/**
	 * @return the englishlbl to get
	 */
	public String getEnglishlbl() {
		return englishlbl;
	}
	/**
	 * @param englishlbl 	the englishlbl to set
	 */
	public void setEnglishlbl(String englishlbl) {
		this.englishlbl = englishlbl;
	}
 
}