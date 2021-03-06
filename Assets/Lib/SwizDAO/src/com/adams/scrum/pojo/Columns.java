/*
 * This java source file is generated by DAO4J v1.16
 * Generated on Wed May 05 11:29:43 GMT+05:30 2010
 * For more information, please contact b-i-d@163.com
 * Please check http://members.lycos.co.uk/dao4j/ for the latest version.
 */

package com.adams.scrum.pojo;

/*
 * For Table columns
 */
public class Columns implements java.io.Serializable, Cloneable {

    /* Column_ID, PK */
    protected int columnId;

    /* Column_Name */
    protected String columnName;

    /* Column_Field */
    protected String columnField; 
    
    /* Column_Width */
    protected int columnWidth;

    /* Column_Filter */
    protected boolean columnFilter;
 

    /* Column_ID, PK */
    public int getColumnId() {
        return columnId;
    }

    /* Column_ID, PK */
    public void setColumnId(int columnId) {
        this.columnId = columnId;
    }

    /* Column_Name */
    public String getColumnName() {
        return columnName;
    }

    /* Column_Name */
    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    /* Column_Field */
    public String getColumnField() {
        return columnField;
    }

    /* Column_Field */
    public void setColumnField(String columnField) {
        this.columnField = columnField;
    }

    /* Column_Width */
    public int getColumnWidth() {
        return columnWidth;
    }

    /* Column_Width */
    public void setColumnWidth(int columnWidth) {
        this.columnWidth = columnWidth;
    }

    /* Column_Filter */
    public boolean getColumnFilter() {
        return columnFilter;
    }

    /* Column_Filter */
    public void setColumnFilter(boolean columnFilter) {
        this.columnFilter = columnFilter;
    }

    /* Indicates whether some other object is "equal to" this one. */
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || !(obj instanceof Columns))
            return false;

        Columns bean = (Columns) obj;

        if (this.columnId != bean.columnId)
            return false;

        if (this.columnName == null) {
            if (bean.columnName != null)
                return false;
        }
        else if (!this.columnName.equals(bean.columnName)) 
            return false;

        if (this.columnField == null) {
            if (bean.columnField != null)
                return false;
        }
        else if (!this.columnField.equals(bean.columnField)) 
            return false;

        if (this.columnWidth != bean.columnWidth)
            return false;

        if (this.columnFilter != bean.columnFilter)
            return false;

        return true;
    }

    /* Creates and returns a copy of this object. */
    public Object clone()
    {
        Columns bean = new Columns();
        bean.columnId = this.columnId;
        bean.columnName = this.columnName;
        bean.columnField = this.columnField;
        bean.columnWidth = this.columnWidth;
        bean.columnFilter = this.columnFilter;
        return bean;
    }

    /* Returns a string representation of the object. */
    public String toString() {
        String sep = "\r\n";
        StringBuffer sb = new StringBuffer();
        sb.append(this.getClass().getName()).append(sep);
        sb.append("[").append("columnId").append(" = ").append(columnId).append("]").append(sep);
        sb.append("[").append("columnName").append(" = ").append(columnName).append("]").append(sep);
        sb.append("[").append("columnField").append(" = ").append(columnField).append("]").append(sep);
        sb.append("[").append("columnWidth").append(" = ").append(columnWidth).append("]").append(sep);
        sb.append("[").append("columnFilter").append(" = ").append(columnFilter).append("]").append(sep);
        return sb.toString();
    }
}