package com.adams.dt.pojo;

import java.io.Serializable;  

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
	}

	public String getEnglishlbl() {
		return englishlbl;
	}

	public void setEnglishlbl(String englishlbl) {
		this.englishlbl = englishlbl;
	}
 
}