/*
 * This java source file is generated by DAO4J v1.16
 * Generated on Wed May 05 11:29:43 GMT+05:30 2010
 * For more information, please contact b-i-d@163.com
 * Please check http://members.lycos.co.uk/dao4j/ for the latest version.
 */

package com.adams.scrum.pojo;

/*
 * For Table themes
 */
public class Themes implements java.io.Serializable, Cloneable {

    /* theme_ID, PK */
    protected int themeId;

    /* theme_lbl */
    protected String themeLbl;

    /* product_FK */
    protected int productFk;
 

    /* theme_ID, PK */
    public int getThemeId() {
        return themeId;
    }

    /* theme_ID, PK */
    public void setThemeId(int themeId) {
        this.themeId = themeId;
    }

    /* theme_lbl */
    public String getThemeLbl() {
        return themeLbl;
    }

    /* theme_lbl */
    public void setThemeLbl(String themeLbl) {
        this.themeLbl = themeLbl;
    }

    /* product_FK */
    public int getProductFk() {
        return productFk;
    }

    /* product_FK */
    public void setProductFk(int productFk) {
        this.productFk = productFk;
    }

    /* Indicates whether some other object is "equal to" this one. */
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || !(obj instanceof Themes))
            return false;

        Themes bean = (Themes) obj;

        if (this.themeId != bean.themeId)
            return false;

        if (this.themeLbl == null) {
            if (bean.themeLbl != null)
                return false;
        }
        else if (!this.themeLbl.equals(bean.themeLbl)) 
            return false;

        if (this.productFk != bean.productFk)
            return false;

        return true;
    }

    /* Creates and returns a copy of this object. */
    public Object clone()
    {
        Themes bean = new Themes();
        bean.themeId = this.themeId;
        bean.themeLbl = this.themeLbl;
        bean.productFk = this.productFk;
        return bean;
    }

    /* Returns a string representation of the object. */
    public String toString() {
        String sep = "\r\n";
        StringBuffer sb = new StringBuffer();
        sb.append(this.getClass().getName()).append(sep);
        sb.append("[").append("themeId").append(" = ").append(themeId).append("]").append(sep);
        sb.append("[").append("themeLbl").append(" = ").append(themeLbl).append("]").append(sep);
        sb.append("[").append("productFk").append(" = ").append(productFk).append("]").append(sep);
        return sb.toString();
    }
}