/*
 * This java source file is generated by DAO4J v1.16
 * Generated on Wed May 05 11:29:43 GMT+05:30 2010
 * For more information, please contact b-i-d@163.com
 * Please check http://members.lycos.co.uk/dao4j/ for the latest version.
 */

package com.adams.scrum.pojo;

/*
 * For Table persons
 */
public class Persons implements java.io.Serializable, Cloneable {

    /* Person_ID, PK */
    protected int personId;

    /* Person_Firstname */
    protected String personFirstname;

    /* Person_Lastname */
    protected String personLastname;

    /* Person_Email */
    protected String personEmail;

    /* Person_Login */
    protected String personLogin;

    /* Person_Password */
    protected String personPassword;

    /* Person_Position */
    protected String personPosition;

    /* Person_Mobile */
    protected String personMobile;

    /* Person_Address */
    protected String personAddress;

    /* Person_Postal_Code */
    protected String personPostalCode;

    /* Person_City */
    protected String personCity;

    /* Person_Country */
    protected String personCountry;

    /* Person_Pict */
    protected byte[] personPict;

    /* Person_DateEntry */
    protected java.util.Date personDateentry;

    /* Activated */
    protected Short activated;
    
    /* Company_FK */
    protected int companyFk;  
 
	/* Person_ID, PK */
    public int getPersonId() {
        return personId;
    }

    /* Person_ID, PK */
    public void setPersonId(int personId) {
        this.personId = personId;
    }

    /* Person_Firstname */
    public String getPersonFirstname() {
        return personFirstname;
    }

    /* Person_Firstname */
    public void setPersonFirstname(String personFirstname) {
        this.personFirstname = personFirstname;
    }

    /* Person_Lastname */
    public String getPersonLastname() {
        return personLastname;
    }

    /* Person_Lastname */
    public void setPersonLastname(String personLastname) {
        this.personLastname = personLastname;
    }

    /* Person_Email */
    public String getPersonEmail() {
        return personEmail;
    }

    /* Person_Email */
    public void setPersonEmail(String personEmail) {
        this.personEmail = personEmail;
    }

    /* Person_Login */
    public String getPersonLogin() {
        return personLogin;
    }

    /* Person_Login */
    public void setPersonLogin(String personLogin) {
        this.personLogin = personLogin;
    }

    /* Person_Password */
    public String getPersonPassword() {
        return personPassword;
    }

    /* Person_Password */
    public void setPersonPassword(String personPassword) {
        this.personPassword = personPassword;
    }

    /* Person_Position */
    public String getPersonPosition() {
        return personPosition;
    }

    /* Person_Position */
    public void setPersonPosition(String personPosition) {
        this.personPosition = personPosition;
    }

    /* Person_Mobile */
    public String getPersonMobile() {
        return personMobile;
    }

    /* Person_Mobile */
    public void setPersonMobile(String personMobile) {
        this.personMobile = personMobile;
    }

    /* Person_Address */
    public String getPersonAddress() {
        return personAddress;
    }

    /* Person_Address */
    public void setPersonAddress(String personAddress) {
        this.personAddress = personAddress;
    }

    /* Person_Postal_Code */
    public String getPersonPostalCode() {
        return personPostalCode;
    }

    /* Person_Postal_Code */
    public void setPersonPostalCode(String personPostalCode) {
        this.personPostalCode = personPostalCode;
    }

    /* Person_City */
    public String getPersonCity() {
        return personCity;
    }

    /* Person_City */
    public void setPersonCity(String personCity) {
        this.personCity = personCity;
    }

    /* Person_Country */
    public String getPersonCountry() {
        return personCountry;
    }

    /* Person_Country */
    public void setPersonCountry(String personCountry) {
        this.personCountry = personCountry;
    }

    /* Person_Pict */
    public byte[] getPersonPict() {
        return personPict;
    }

    /* Person_Pict */
    public void setPersonPict(byte[] personPict) {
        this.personPict = personPict;
    }

    /* Person_DateEntry */
    public java.util.Date getPersonDateentry() {
        return personDateentry;
    }

    /* Person_DateEntry */
    public void setPersonDateentry(java.util.Date personDateentry) {
        this.personDateentry = personDateentry;
    }

    /* Activated */
    public Short getActivated() {
        return activated;
    }

    /* Activated */
    public void setActivated(Short activated) {
        this.activated = activated;
    }
    
    /* Company_FK */
	public int getCompanyFk() {
		return companyFk;
	}

	/* Company_FK */
	public void setCompanyFk(int companyFk) {
		this.companyFk = companyFk;
	}


    /* Indicates whether some other object is "equal to" this one. */
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || !(obj instanceof Persons))
            return false;

        Persons bean = (Persons) obj;

        if (this.personId != bean.personId)
            return false;

        if (this.personFirstname == null) {
            if (bean.personFirstname != null)
                return false;
        }
        else if (!this.personFirstname.equals(bean.personFirstname)) 
            return false;

        if (this.personLastname == null) {
            if (bean.personLastname != null)
                return false;
        }
        else if (!this.personLastname.equals(bean.personLastname)) 
            return false;

        if (this.personEmail == null) {
            if (bean.personEmail != null)
                return false;
        }
        else if (!this.personEmail.equals(bean.personEmail)) 
            return false;

        if (this.personLogin == null) {
            if (bean.personLogin != null)
                return false;
        }
        else if (!this.personLogin.equals(bean.personLogin)) 
            return false;

        if (this.personPassword == null) {
            if (bean.personPassword != null)
                return false;
        }
        else if (!this.personPassword.equals(bean.personPassword)) 
            return false;

        if (this.personPosition == null) {
            if (bean.personPosition != null)
                return false;
        }
        else if (!this.personPosition.equals(bean.personPosition)) 
            return false;

        if (this.personMobile == null) {
            if (bean.personMobile != null)
                return false;
        }
        else if (!this.personMobile.equals(bean.personMobile)) 
            return false;

        if (this.personAddress == null) {
            if (bean.personAddress != null)
                return false;
        }
        else if (!this.personAddress.equals(bean.personAddress)) 
            return false;

        if (this.personPostalCode == null) {
            if (bean.personPostalCode != null)
                return false;
        }
        else if (!this.personPostalCode.equals(bean.personPostalCode)) 
            return false;

        if (this.personCity == null) {
            if (bean.personCity != null)
                return false;
        }
        else if (!this.personCity.equals(bean.personCity)) 
            return false;

        if (this.personCountry == null) {
            if (bean.personCountry != null)
                return false;
        }
        else if (!this.personCountry.equals(bean.personCountry)) 
            return false;

        if (this.personPict == null) {
            if (bean.personPict != null)
                return false;
        }else {
            if (bean.personPict == null)
                return false;
            else {
                if (personPict.length != bean.personPict.length)
                    return false;
                for (int i=0;i<bean.personPict.length;i++) {
                    if (this.personPict[i] != bean.personPict[i])
                        return false;
                }
            }
        }

        if (this.personDateentry == null) {
            if (bean.personDateentry != null)
                return false;
        }
        else if (!this.personDateentry.equals(bean.personDateentry)) 
            return false;

        if (this.activated == null) {
            if (bean.activated != null)
                return false;
        }
        else if (!this.activated.equals(bean.activated)) 
            return false;
        
        if (this.companyFk != bean.companyFk)
            return false;
        
        return true;
    }

    /* Creates and returns a copy of this object. */
    public Object clone()
    {
        Persons bean = new Persons();
        bean.personId = this.personId;
        bean.personFirstname = this.personFirstname;
        bean.personLastname = this.personLastname;
        bean.personEmail = this.personEmail;
        bean.personLogin = this.personLogin;
        bean.personPassword = this.personPassword;
        bean.personPosition = this.personPosition;
        bean.personMobile = this.personMobile;
        bean.personAddress = this.personAddress;
        bean.personPostalCode = this.personPostalCode;
        bean.personCity = this.personCity;
        bean.personCountry = this.personCountry;
        int personPictLength = -1;
        if (this.personPict != null)
            personPictLength = this.personPict.length;
        if (personPictLength > 0)
        {
            byte[] personPictArray = new byte[personPictLength];
            bean.personPict = personPictArray;
            System.arraycopy(this.personPict, 0, personPictArray, 0, personPictLength);
        }
        if (this.personDateentry != null)
            bean.personDateentry = (java.util.Date) this.personDateentry.clone();
        if (this.activated != null)
            bean.activated = new Short(this.activated.shortValue());
        
        bean.companyFk = this.companyFk;
        return bean;
    }

    /* Returns a string representation of the object. */
    public String toString() {
        String sep = "\r\n";
        StringBuffer sb = new StringBuffer();
        sb.append(this.getClass().getName()).append(sep);
        sb.append("[").append("personId").append(" = ").append(personId).append("]").append(sep);
        sb.append("[").append("personFirstname").append(" = ").append(personFirstname).append("]").append(sep);
        sb.append("[").append("personLastname").append(" = ").append(personLastname).append("]").append(sep);
        sb.append("[").append("personEmail").append(" = ").append(personEmail).append("]").append(sep);
        sb.append("[").append("personLogin").append(" = ").append(personLogin).append("]").append(sep);
        sb.append("[").append("personPassword").append(" = ").append(personPassword).append("]").append(sep);
        sb.append("[").append("personPosition").append(" = ").append(personPosition).append("]").append(sep);
        sb.append("[").append("personMobile").append(" = ").append(personMobile).append("]").append(sep);
        sb.append("[").append("personAddress").append(" = ").append(personAddress).append("]").append(sep);
        sb.append("[").append("personPostalCode").append(" = ").append(personPostalCode).append("]").append(sep);
        sb.append("[").append("personCity").append(" = ").append(personCity).append("]").append(sep);
        sb.append("[").append("personCountry").append(" = ").append(personCountry).append("]").append(sep);
        sb.append("[").append("personPict").append(" = ").append(personPict).append("]").append(sep);
        sb.append("[").append("personDateentry").append(" = ").append(personDateentry).append("]").append(sep);
        sb.append("[").append("activated").append(" = ").append(activated).append("]").append(sep);
        sb.append("[").append("companyFk").append(" = ").append(companyFk).append("]").append(sep);
        return sb.toString();
    }
}