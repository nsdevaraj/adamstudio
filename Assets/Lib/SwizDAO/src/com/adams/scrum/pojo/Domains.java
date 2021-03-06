/*
 * This java source file is generated by DAO4J v1.16
 * Generated on Wed May 05 11:29:43 GMT+05:30 2010
 * For more information, please contact b-i-d@163.com
 * Please check http://members.lycos.co.uk/dao4j/ for the latest version.
 */

package com.adams.scrum.pojo;

import java.util.Set;

/*
 * For Table domains
 */
public class Domains implements java.io.Serializable, Cloneable {

    /* Domain_ID, PK */
    protected int domainId;

    /* Domain_Name */
    protected String domainName;

    /* Domain_code */
    protected String domainCode;
    protected Set<Products> productSet;

    public Set<Products> getProductSet() {
		return productSet;
	}

	public void setProductSet(Set<Products> productSet) {
		this.productSet = productSet;
	}

	/* Domain_ID, PK */
    public int getDomainId() {
        return domainId;
    }

    /* Domain_ID, PK */
    public void setDomainId(int domainId) {
        this.domainId = domainId;
    }

    /* Domain_Name */
    public String getDomainName() {
        return domainName;
    }

    /* Domain_Name */
    public void setDomainName(String domainName) {
        this.domainName = domainName;
    }

    /* Domain_code */
    public String getDomainCode() {
        return domainCode;
    }

    /* Domain_code */
    public void setDomainCode(String domainCode) {
        this.domainCode = domainCode;
    }

    /* Indicates whether some other object is "equal to" this one. */
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || !(obj instanceof Domains))
            return false;

        Domains bean = (Domains) obj;

        if (this.domainId != bean.domainId)
            return false;

        if (this.domainName == null) {
            if (bean.domainName != null)
                return false;
        }
        else if (!this.domainName.equals(bean.domainName)) 
            return false;

        if (this.domainCode == null) {
            if (bean.domainCode != null)
                return false;
        }
        else if (!this.domainCode.equals(bean.domainCode)) 
            return false;

        return true;
    }

    /* Creates and returns a copy of this object. */
    public Object clone()
    {
        Domains bean = new Domains();
        bean.domainId = this.domainId;
        bean.domainName = this.domainName;
        bean.domainCode = this.domainCode;
        return bean;
    }

    /* Returns a string representation of the object. */
    public String toString() {
        String sep = "\r\n";
        StringBuffer sb = new StringBuffer();
        sb.append(this.getClass().getName()).append(sep);
        sb.append("[").append("domainId").append(" = ").append(domainId).append("]").append(sep);
        sb.append("[").append("domainName").append(" = ").append(domainName).append("]").append(sep);
        sb.append("[").append("domainCode").append(" = ").append(domainCode).append("]").append(sep);
        return sb.toString();
    }
}