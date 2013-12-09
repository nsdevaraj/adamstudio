package com.adams.dt.pojo;	

import java.io.Serializable; 
import java.util.Date;

public class Categories implements Serializable{

    /**
	 * 
	 */ 
 
	private static final long serialVersionUID = 1L;

	/* Category_ID, PK */
    protected int categoryId;

    /* Category_Name */
    protected String categoryName;

    /* Category_Code */
    protected String categoryCode;
    
    /* categoryFK */
    protected Categories categoryFK;
     
    protected Date categoryStartDate;
    protected Date categoryEndDate;
    public Date getCategoryStartDate() {
		return categoryStartDate;
	}

	public void setCategoryStartDate(Date categoryStartDate) {
		this.categoryStartDate = categoryStartDate;
	}

	public Date getCategoryEndDate() {
		return categoryEndDate;
	}

	public void setCategoryEndDate(Date categoryEndDate) {
		this.categoryEndDate = categoryEndDate;
	}

	/* Category_ID, PK */
    public int getCategoryId() {
        return categoryId;
    }

    /* Category_ID, PK */
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    /* Category_Name */
    public String getCategoryName() {
        return categoryName;
    }

    /* Category_Name */
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    /* Category_Code */
    public String getCategoryCode() {
        return categoryCode;
    }

    /* Category_Code */
    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }
  	public Categories getCategoryFK() {
		return categoryFK;
	}

	public void setCategoryFK(Categories categoryFK) {
		this.categoryFK = categoryFK;
	}
}
