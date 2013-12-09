package com.adams.dt.pojo;

import java.io.Serializable; 
 

public class Companies implements Serializable {

    static final long serialVersionUID = 103844514947365244L;

    private int companyid;
    private String companyname;
    private String companycode;
    private byte[] companylogo;
    private String companyCategory; 
    private String companyAddress;
    private String companyPostalCode;
    private String companyCity;
    private String companyCountry;
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

	public void setCompanylogo(byte[] companylogo) {
		this.companylogo = companylogo;
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



}