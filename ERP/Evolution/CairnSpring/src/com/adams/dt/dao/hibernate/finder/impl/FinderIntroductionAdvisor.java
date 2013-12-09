package com.adams.dt.dao.hibernate.finder.impl;

import org.springframework.aop.support.DefaultIntroductionAdvisor;

/**
 * Looks up spring based class extends FinderIntroductionAdvisor
 */
public class FinderIntroductionAdvisor extends DefaultIntroductionAdvisor
{
	/* @FinderIntroductionAdvisor Class constructor*/
    public FinderIntroductionAdvisor()
    {
    	// @super class
        super(new FinderIntroductionInterceptor());
    }
}
