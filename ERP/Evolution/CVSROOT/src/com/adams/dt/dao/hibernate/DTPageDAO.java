package com.adams.dt.dao.hibernate;
 
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.ArrayList; 
import java.util.StringTokenizer;
import java.sql.*;

import oracle.jdbc.driver.OracleCallableStatement;
import oracle.jdbc.driver.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.BLOB;
import oracle.sql.Datum;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.adams.dt.util.BuildConfig;
import com.adams.dt.util.FileUtil;
import com.adams.dt.util.MailUtil;

import com.adams.dt.pojo.Categories;
import com.adams.dt.pojo.Column;
import com.adams.dt.pojo.Companies;
import com.adams.dt.pojo.DefaultTemplate;
import com.adams.dt.pojo.Domainworkflows;
import com.adams.dt.pojo.Groups;
import com.adams.dt.pojo.Modules;
import com.adams.dt.pojo.Phases;
import com.adams.dt.pojo.Phasestemplates;
import com.adams.dt.pojo.Profiles;
import com.adams.dt.pojo.Projects;
import com.adams.dt.pojo.Propertiespj;
import com.adams.dt.pojo.Propertiespresets;
import com.adams.dt.pojo.Proppresetstemplates;
import com.adams.dt.pojo.Report;
import com.adams.dt.pojo.Status;
import com.adams.dt.pojo.Tasks;
import com.adams.dt.pojo.Teamlines;
import com.adams.dt.pojo.Workflows;
import com.adams.dt.pojo.Workflowstemplates;
import com.mysql.jdbc.Blob;
import com.mysql.jdbc.ResultSetMetaData;

public class DTPageDAO extends HibernateDaoSupport {

	public List<?> getQueryResult(String query) throws Exception {
		Query q = getSession().createSQLQuery(query);
		if (q == null)
			throw new Exception("Order id is null.");

		return q.list();
	} 	 	
	
	public Object save(Object o)  {
		 try {
			getHibernateTemplate().save(o);
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		return o;
	}
	
	public List<?> bulkUpdate(List<?> objList){		
		getHibernateTemplate().saveOrUpdateAll(objList);
		return objList;
	}
	
	public List<?> paginationListView(String strQuery, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	public List<?> queryListView(String strQuery) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery); 
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	public List<?> paginationListViewId(String strQuery, Integer prgId, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
 			System.out.println(strQuery);
			query = getSession().getNamedQuery(strQuery);
		
			query.setInteger(0, prgId);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		
			return query.list();
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("SQL server db exception.");
		}
	}
	
	public List<?> paginationListViewIdId(String strQuery, Integer prgId1, Integer prgId2, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setInteger(0, prgId1);
			query.setInteger(1, prgId2);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}

	public List<?> paginationListViewIdIdId(String strQuery, Integer prgId1, Integer prgId2, Integer prgId3, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setInteger(0, prgId1);
			query.setInteger(1, prgId2);
			query.setInteger(2, prgId3);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}

	public List<?> paginationListViewIdStr(String strQuery, Integer prgId, String tempFieldValue, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setInteger(0, prgId);
			query.setString(1, tempFieldValue);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	public List<?> paginationListViewIdDtDt(String strQuery, Integer prgId, Date startDate, Date endDate, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setInteger(0, prgId);
			query.setDate(1, startDate);
			query.setDate(2, endDate);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
		
	public List<?> paginationListViewStr(String strQuery, String userName, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setString(0, userName);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	public List<?> paginationListViewStrStr(String strQuery, String userName1, String userName2, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setString(0, userName1);
			query.setString(1, userName2);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	public List paginationListViewStrStrDtDt(String strQuery, String instiName, String status, Date startDate, Date endDate, Integer startPoint, Integer endPoint) throws Exception {
		Query query = null;
		try {
			query = getSession().getNamedQuery(strQuery);
			query.setString(0, instiName);
			query.setString(1, status);
			query.setDate(2, startDate);
			query.setDate(3, endDate);
			query.setFirstResult(startPoint);
			query.setMaxResults(endPoint);
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	 	
	public void deleteByForeignKey(String strQuery) throws Exception {
		
		try {
			Query query =	getSession().createSQLQuery(strQuery);
			query.executeUpdate();
			
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
	}
	
	public List<?> queryPagination(String strQuery, Integer startPoint, Integer endPoint) throws Exception {
		Query query =null;
		try {
			 query =getSession().createQuery(strQuery);
			 query.setFirstResult(startPoint);
			 query.setMaxResults(endPoint);
			
		} catch (Exception e) {
			throw new Exception("SQL server db exception.");
		}
		return query.list();
	}
	
	public void SmtpSSLMail(String msgTo, String msgSubject, String msgBody) throws Exception {
		try {
			MailUtil mailutil = new MailUtil();
			mailutil.setDtPageDao( this ); 
			mailutil.SmtpSSLMail(msgTo, msgSubject, msgBody);
			
		} catch (Exception e) {
			throw new Exception("SMTP exception.");
		}		
	}
	public List<?> getLoginListResult(int personId, int defaultprofile) throws Exception {
		List list = null;
		HibernateTemplate template = null;
	    try{
	    	System.out.println("LOGIN PERSON ID: ************** "+personId);
	  
	    	template = getHibernateTemplate();
	    	List<Companies> companiesList = (template.find("from Companies x"));
	    	List<Phasestemplates> phaesesTmeplatesList = (template.find("from Phasestemplates x"));
	    	List<Status> statusList = (template.find("from Status x"));
	    	List<Profiles> profilesList = (template.find("from Profiles x"));
	    	List<Workflowstemplates> workflowTemplatesList = (template.find("from Workflowstemplates x"));
	    	List<Categories> categoriesList = (template.find("from Categories x"));
	    	List<Profiles> personProfilesList = (template.find("select u from Profiles u where u.profileId in (select distinct p.profileId from Profiles p,Teamlines t where t.profileID = p.profileId and t.personID = "+personId+")"));
	    	List<Groups> groupsList = (template.find("from Groups x"));
	    	List<Domainworkflows> domainworkflowsList = (template.find("from Domainworkflows"));
	    	
	    	//List<DefaultTemplate> defaultTemplateList = (template.find("from DefaultTemplate"));
	    	
	    	System.out.println("LOGIN personProfilesList:"+personProfilesList.size());
	    	
	    	List<Profiles> tempProfileList = new ArrayList<Profiles>(); 
	    	if(personProfilesList.size() == 0){
				System.out.println("profilesList:"+profilesList.size());
				for(Profiles profile : profilesList) {
					System.out.println("profile.getProfileId():"+profile.getProfileId());
					if(profile.getProfileId() == defaultprofile){
						tempProfileList.add( profile );
						personProfilesList = tempProfileList;
					}
				}
				System.out.println("LOGIN tempProfileList:"+tempProfileList.size());
				personProfilesList = tempProfileList;
				System.out.println("LOGIN after personProfilesList:"+personProfilesList.size());
			}
	    	
	    	List<Modules> modulesList = new ArrayList<Modules>(); 
	    	for(Profiles profile : personProfilesList) {
	    		System.out.println("LOGIN profile:"+profile.getProfileId());
	    		modulesList.addAll(template.find("select u from Modules u, Profiles p, ProfileModules m where m.profileFk = p.profileId and u.moduleId = m.moduleFk and p.profileId = "+profile.getProfileId()));
	    	}
	    		    	
	    	list = new ArrayList();
	    	list.add(companiesList);
	    	list.add(phaesesTmeplatesList);
	    	list.add(statusList);
	    	list.add(profilesList);
	    	list.add(workflowTemplatesList);
	    	list.add(categoriesList);
	    	list.add(personProfilesList);
	    	list.add(groupsList);
	    	list.add(domainworkflowsList);
	    	list.add(modulesList); 
	    	
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    finally {  
	    		try {  
		    		if (template != null) {  
		    			template.flush(); 
		    			template.clear();
		    		} 
		    	}  
		        catch (Exception e) {  
		           System.out.println(e.getClass().getName() +  " getLoginListResult: " + e.toString());  
		        }  
    	}	    
	    return list;
	}
	public List<?> getTaskList(int personId) throws Exception {
		List list = null;
		HibernateTemplate template = null;
	    try{
	    	System.out.println("HomePage PERSON ID:"+personId );
	      		    	
	    	template = getHibernateTemplate();
	    	list = new ArrayList();	
	    	   	
 	    	List<Tasks> getTasksList = (template.find("select u from Tasks u where u.taskId in (select distinct t.taskId from Tasks t, Workflowstemplates w, Status s, Grouppersons go, Grouppersons gu, Teamlines tl, Groups g where t.taskStatusFK = s.statusId and s.type = 'task_status' and (s.statusLabel='waiting' or s.statusLabel='in_progress' or s.statusLabel='stand_by') and t.wftFK =w.workflowTemplateId  and go.groupFk !=g.groupId and go.groupFk = gu.groupFk and g.authLevel='ROLE_COM' and tl.personID = go.personFk and tl.projectID = t.projectFk and tl.profileID = w.profileFK and gu.personFk = "+personId+")"));
	    	List<Tasks> getTaskMaxIdList = (template.find("select  t.taskId, t.projectFk, t.tDateCreation, t.tDateEnd from Tasks t where t.taskId = (select max(t1.taskId) from Tasks t1 where t1.personFK="+personId+" and t1.taskStatusFK=10)"));
	    	List<Categories> categoriesList = (template.find("from Categories x"));
	    	List<Workflowstemplates> workflowTemplatesList = (template.find("from Workflowstemplates x"));
	    	
	    	list.add( getTasksList );
	    	list.add(categoriesList);
	    	list.add(workflowTemplatesList);
	    	list.add( getTaskMaxIdList );
	    		    	 
	    	System.out.println("HomePage getTasksList:"+getTasksList.size());
	    	System.out.println("HomePage getTaskMaxIdList:"+getTaskMaxIdList.size());
	    	
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    return list;
	} 
	
	public List<?> getHomeList(int personId,String profileCode,int domainFk,String allReports, int profilesFk) throws Exception {
		List list = null;
		HibernateTemplate template = null;
	    try{
	    	System.out.println("HomePage PERSON ID:"+personId+" , profileCode :"+profileCode+" , domainFk :"+domainFk+" , allReports :"+allReports+" , profilesFk :"+profilesFk);
	      		    	
	    	template = getHibernateTemplate();
	    	list = new ArrayList();		    	 
	    	
	    	List<Propertiespresets> getAllPropertyList = (template.find("from Propertiespresets x"));
	    	List<Proppresetstemplates> getAllPresetTemplateList = (template.find("from Proppresetstemplates x"));

	    	list.add( getAllPropertyList );	    	
	    	System.out.println("HomePage getAllPropertyList:"+getAllPropertyList.size());
	    	list.add( getAllPresetTemplateList );
	    	System.out.println("HomePage getAllPresetTemplateList:"+getAllPresetTemplateList.size());
	    	 
	    	if( !(profileCode.compareTo("CLT")< 0) ){ 
	    		System.out.println("HomePage profileCode if:"+profileCode);
	    		List<Workflows> getWorkflowList = (template.find("select u from Workflows u where u.workflowId in (select distinct w.workflowId from Categories c, Workflows w, Domainworkflows d where d.workflowFk=w.workflowId and d.domainFk = "+domainFk+")"));
	    		list.add( getWorkflowList );
	    		System.out.println("HomePage Workflows IF :"+getWorkflowList.size()+" , profileCode :"+profileCode);
	    	}else if(!(profileCode.compareTo("TRA")< 0) || !(profileCode.compareTo("FAB")< 0) ){
	    		System.out.println("HomePage profileCode else:"+profileCode);
		    	List<Workflows> getAllWorkflowsList = (template.find("from Workflows x"));
		    	list.addAll( getAllWorkflowsList );
		    	System.out.println("HomePage Workflows Else :"+getAllWorkflowsList.size()+" , profileCode :"+profileCode);
	    	} 
	    	
	    		//EVENT_GET_PROJECT_COUNT BELOW
	    		//List<Projects> getProjectCountList = (template.find("select count(*) from projects p, tasks t where t.task_Id = (select max(t0.task_Id) from tasks t0, group_persons g1, group_persons g2, teamlines tl, workflow_templates w where t0.project_Fk= p.project_Id and tl.project_fk = p.project_Id and tl.person_fk = g2.person_Fk and w.workflow_template_ID = t0.workflow_template_FK and g1.group_Fk = g2.group_Fk and w.task_code not like 'pdf%' and w.task_code not like 'm0%' and g1.person_Fk = "+personId+")"));
	    		//Page missing --> PagingEvent.EVENT_GET_PROJECT_PAGED	    	
	    	List<Projects> getProjectPageList = (template.find("select p,t from Projects p, Tasks t where t.taskId = (select max(t0.taskId) from Tasks t0, Grouppersons g1, Grouppersons g2, Workflowstemplates w, Teamlines tl where t0.projectFk= p.projectId and tl.projectID = p.projectId and tl.personID = g2.personFk and g1.groupFk = g2.groupFk and w.workflowTemplateId = t0.wftFK and not (w.taskCode ='pdf01B' or  w.taskCode ='pdf01A' or  w.taskCode ='m01'or  w.taskCode ='pdf02A' or  w.taskCode ='pdf02b') and g1.personFk = "+personId+")"));
	    	List<Tasks> getTasksList = (template.find("select u from Tasks u where u.taskId in (select distinct t.taskId from Tasks t, Workflowstemplates w, Status s, Grouppersons go, Grouppersons gu, Teamlines tl, Groups g where t.taskStatusFK = s.statusId and s.type = 'task_status' and (s.statusLabel='waiting' or s.statusLabel='in_progress' or s.statusLabel='stand_by') and t.wftFK =w.workflowTemplateId  and go.groupFk !=g.groupId and go.groupFk = gu.groupFk and g.authLevel='ROLE_COM' and tl.personID = go.personFk and tl.projectID = t.projectFk and tl.profileID = w.profileFK and gu.personFk = "+personId+")"));
	    	List<Tasks> getTaskMaxIdList = (template.find("select  t.taskId, t.projectFk, t.tDateCreation, t.tDateEnd from Tasks t where t.taskId = (select max(t1.taskId) from Tasks t1 where t1.personFK="+personId+" and t1.taskStatusFK=10)"));
	    		    	
	    	list.add( getProjectPageList );
	    	list.add( getTasksList );
	    	list.add( getTaskMaxIdList );
	    		    	
	    	System.out.println("HomePage getProjectPageList:"+getProjectPageList.size());
	    	System.out.println("HomePage getTasksList:"+getTasksList.size());
	    	System.out.println("HomePage getTaskMaxIdList:"+getTaskMaxIdList.size());
	    	
	    	if( allReports == "true" ){ //allReports -- true
	    		List<Report> getReportList = (template.find("from Report"));
	    		list.add( getReportList );
	    		System.out.println("HomePage Report IF :"+getReportList.size()+" , allReports :"+allReports);
	    	}else{
	    		List<Report> getProfileReportList = (template.find("select u from Report u where u.profileFk = "+profilesFk+")"));
	    		list.add( getProfileReportList );
		    	System.out.println("HomePage Report Else :"+getProfileReportList.size()+" , allReports :"+allReports);
	    	}
	    	
	    	List<Column> getColumnList = (template.find("from Column"));
	    	list.add( getColumnList );
	    	System.out.println("HomePage getColumnList:"+getColumnList.size());	    	
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    finally {  
    		try {  
	    		if (template != null) {  
	    			template.flush(); 
	    			template.clear();
	    		} 
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " getHomeList: " + e.toString());  
	        }  
	    }
	    return list;
	} 	
	
	public List<?> oracleUpdateTeamline(String teamprojectId , String teamprofileId ,String teampersonId,String propertiesprojectId , String propertiesPresetId ,String propertiespropValues) throws Exception {
    	System.out.println("oracleUpdateTeamline teamprojectId :"+teamprojectId+" , teamprofileId :"+teamprofileId+" , teampersonId :"+teampersonId+" , propertiesprojectId :"+propertiesprojectId+" , propertiesPresetId :"+propertiesPresetId+" , propertiespropValues :"+propertiespropValues);

		Connection conn = null;
		CallableStatement cs = null;
		Session session = getSession();
		ResultSet rs = null; 
		List list = new ArrayList();	
		HibernateTemplate template = null;
		try {
	        conn = session.connection();
	        System.out.println("Connection = "+conn);
	        if (cs == null)
	         {
	        	cs = conn.prepareCall("{call P_BULK_TEAMLINES(?,?,?,?,?,?,?,?,?)}");
	        	cs.setString("p_projectFkArray", teamprojectId); 
	        		System.out.println("p_projectFkArray :"+teamprojectId);
	        	cs.setString("p_profileFkArray", teamprofileId);
	        		System.out.println("p_profileFkArray :"+teamprofileId);
	        	cs.setString("p_personFkArray", teampersonId);
	        		System.out.println("p_personFkArray :"+teampersonId);
	        	
	        	cs.setString("p_propprojectFkArray", propertiesprojectId); 
	        		System.out.println("p_propprojectFkArray :"+propertiesprojectId);
	        	cs.setString("p_propPresetFkArray", propertiesPresetId);
	        		System.out.println("p_propPresetFkArray :"+propertiesPresetId);
	        	cs.setString("p_propfieldValueArray", propertiespropValues);
	        		System.out.println("p_propfieldValueArray :"+propertiespropValues);
	        	cs.registerOutParameter("p_fieldArrValue",OracleTypes.ARRAY,"PJ_ARR_FIELD");
	        	cs.registerOutParameter("p_presetArrID",OracleTypes.ARRAY,"PJ_ARR_PRESETFK");
	        	cs.registerOutParameter("PropertiesIDArray",OracleTypes.ARRAY,"PJ_ARR_PROPERTYPJID");
	        }
	        rs = cs.executeQuery();
	        System.out.println("p_fieldArrValue :"+cs);
	        Array simpleArray = cs.getArray("p_presetArrID");
	        Array valuesArray = cs.getArray("p_fieldArrValue");
	        Array PjIDArray = cs.getArray("PropertiesIDArray");
	        BigDecimal[] values = (BigDecimal[]) simpleArray.getArray();
	        System.out.println("Pj Values "+valuesArray.getArray()+" ---- "+simpleArray.getArray());

	        String [] outValues = (String [])valuesArray.getArray();
	        BigDecimal [] PjValues = (BigDecimal [])PjIDArray.getArray();
	       	        
	        list.add(outValues);
	        list.add(values);
	        list.add(PjValues);
	        
	         try{
	        	 System.out.println("teamprojectId :::::"+teamprojectId);
	        	template = getHibernateTemplate();
	        	List<Teamlines> selectTeamlines = (template.find("select u from Teamlines u where u.projectID = "+teamprojectId));
	        	list.add(selectTeamlines);
	         }
	         catch(Exception e) {
	 		   	e.printStackTrace();
	         }       
		}	        
		catch(Exception e) {
		   	e.printStackTrace();
		}
		finally {  
    		try {  
	    		if (rs != null) {  
	    	        rs.close();  
	    		}       
	    		if (cs != null) {  
	    	         cs.close();  
	    	    }  
	    	    if (conn != null) { 
	    	         conn.close();  
	    	    }
	    	    session.flush();
	            session.clear();
	            session.close();  
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " line 59: " + e.toString());  
	        }  
	    }
		return list;
	} 
	public List<?> oracleCreateDefaultTemp(DefaultTemplate defTempObj, String default_template_value ,String property_preset_fk) throws Exception {
    	System.out.println("oracleCreateDefaultTemp defTempObj :"+defTempObj+" , default_template_value :"+default_template_value+" , property_preset_fk :"+property_preset_fk);

		Connection conn = null;
		CallableStatement cs = null;
		Session session = getSession();
		ResultSet rs = null; 
		List lists = new ArrayList();	
		HibernateTemplate template = null;
		try {
	        conn = session.connection();
	        System.out.println("Connection = "+conn);
	        if (cs == null)
	         {
	        	DefaultTemplate deftemp = defTempObj; 
	        	cs = conn.prepareCall("{call P_SET_BULK_DEFAULTTEMPVALUE(?,?,?,?,?)}");
	        	cs.setString("p_default_template_label", deftemp.getDefaultTemplateLabel()); 
	        		System.out.println("p_default_template_label :"+deftemp.getDefaultTemplateLabel());
	        	cs.setInt("p_default_company_fk", deftemp.getCompanyFK());
	        		System.out.println("p_default_company_fk :"+deftemp.getCompanyFK());
	        	cs.setString("p_propPresetFkArray", property_preset_fk); 
	        		System.out.println("p_propPresetFkArray :"+property_preset_fk);
	        	cs.setString("p_deftemplateValueArray", default_template_value);
	        		System.out.println("p_deftemplateValueArray :"+default_template_value);
	        		cs.registerOutParameter("PJ_Array",OracleTypes.ARRAY);
	         }
	        rs = cs.executeQuery();
	        System.out.println("oracleCreateDefaultTemp ResultSet:"+rs);
	        //rs=(ResultSet)((NewProxyCallableStatement)cs).getObject("PJ_Array");
	        rs=(ResultSet)cs.getObject("PJ_Array");
	        int index = 1;
	        System.out.println("Prepare call is done;"+rs);
	        
			lists = new ArrayList();
			return lists;
		  }catch(Exception e) {
		   	e.printStackTrace();
		  }
		  finally {  
    		try {  
	    		if (rs != null) {  
	    	        rs.close();  
	    		}       
	    		if (cs != null) {  
	    	         cs.close();  
	    	    }  
	    	    if (conn != null) { 
	    	         conn.close();  
	    	    } 
	    	    session.flush();
	            session.clear();
	            session.close();			    	     
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " line 59: " + e.toString());  
	        }  
	    }
		return null;
	} 	
	public List<?> projectStatusChangeTask( int projectId , int workflowFk , int projectStatus,
											String taskMessage,int personFk ) throws Exception {
		
		Connection conn = null;
		CallableStatement cs = null;
		Session session = getSession();
		ResultSet rs = null; 
		List lists = new ArrayList();	
		HibernateTemplate template = null;
		try {
			conn = session.connection();
			System.out.println("projectStatusChangeTask Connection = "+conn);
			if( cs == null )
			{
				System.out.println("projectStatusChangeTask :"+projectId+" ---- "+workflowFk+" ---- "+projectStatus+" ---- "+taskMessage+" ---- "+personFk); 
				cs = conn.prepareCall("{call P_INPROG_STAND_PROJECT(?,?,?,?,?,?,?,?)}");
				cs.setInt("p_projectId", projectId);
				cs.setInt("p_workflowFk", workflowFk);
				cs.setInt("p_projectStatus", projectStatus);
				cs.setString("p_taskMessage", taskMessage);
				cs.setInt("p_personFk", personFk);
				cs.registerOutParameter("p_outTaskClosed",OracleTypes.NUMBER );
				cs.registerOutParameter("p_outTaskCreated",OracleTypes.NUMBER );
				cs.registerOutParameter("p_outMessages",OracleTypes.ARRAY,"PJ_ARR_PROPERTYPJID");		      
			}
			rs = cs.executeQuery();
			int outTaskClosed = cs.getInt("p_outTaskClosed");
			int outTaskCreated = cs.getInt("p_outTaskCreated");
			Array outMessagesArray = cs.getArray("p_outMessages");
			
			BigDecimal[] outMessages = (BigDecimal[]) outMessagesArray.getArray();
			
	        System.out.println("projectStatusChangeTask outTaskCreated : "+outTaskCreated);
	        
	        String bulkArraymessage = "";
			for (int i=0; i<outMessages.length; i++) 
	        {
	           BigDecimal outMessagesvalue = (BigDecimal) outMessages[i];	          
	           System.out.println(">> projectStatusChangeTask index : " + i + " = " + outMessagesvalue.toString());
	           if( bulkArraymessage == "" ) {
	        	   bulkArraymessage = outMessagesvalue.toString();
				}	
				else {
					bulkArraymessage += "," + outMessagesvalue.toString();
				}	
	        }
	        System.out.println("final projectStatusChangeTask index : "+ outMessages.toString());
	        
	        try{
		        template = getHibernateTemplate();
		        List<Tasks> updatetasks = (template.find("select u from Tasks u where u.taskId = "+outTaskClosed));
        			Tasks updatetask = (Tasks)updatetasks.get(0);
        			System.out.println("projectStatusChangeTask updatetask :"+updatetask.getTaskId());
        		
        		lists.add(updatetasks);
		        List<Tasks> createdtasks = (template.find("select u from Tasks u where u.taskId = "+outTaskCreated));
	        		Tasks task = (Tasks)createdtasks.get(0);
	        		System.out.println("projectStatusChangeTask Task :"+task.getTaskId());
	        		
	        	lists.add(createdtasks);
	        	
	        	if(bulkArraymessage.length()!=0){	
		        	List<Tasks> createdMessagetasks = (template.find("select u from Tasks u where u.taskId in ("+bulkArraymessage+")"));
		        		System.out.println("projectStatusChangeTask createdMessagetasks :"+createdMessagetasks.size());
		        		
		        	lists.add(createdMessagetasks);
	        	}	        		
			}catch(Exception e){	
				e.printStackTrace(); 
			}			
			return lists;
		}catch(Exception e) {
		   	e.printStackTrace();
		}
		finally {  
			try {  
	    		if (rs != null) {  
	    	        rs.close();  
	    		}       
	    		if (cs != null) {  
	    	         cs.close();  
	    	    }  
	    	    if (conn != null) { 
	    	         conn.close();  
	    	    } 
	    	    session.flush();
	            session.clear();
	            session.close();			    	     
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " line 59: " + e.toString());  
	        }  
		}
		return null;		
	}
	public List<?> createInitialPhase(String phaseTemp , String phaseCode ,String phaseName ,String phaseStart ,String phaseEndPlanified
									,String phaseDuration,String ProjectID ,String phaseStatus) throws Exception {
		Connection conn = null;
		CallableStatement cs = null;
		Session session = getSession();
		ResultSet rs = null; 
		List lists = new ArrayList();	
		HibernateTemplate template = null;
		try {
	        conn = session.connection();
	        System.out.println("Connection = "+conn);
	        if (cs == null)
	        {
	        	cs = conn.prepareCall("{call P_CREATE_INITIALPHASE(?,?,?,?,?,?,?,?)}");
	        	cs.setString("p_phaseTempArr", phaseTemp);
	        	cs.setString("p_phaseCodeArr", phaseCode); 
	        	cs.setString("p_phasesNameArr", phaseName); 
	        	cs.setString("p_phaseStartArr", phaseStart); 
	        	cs.setString("p_phaseEndPlanifiedArr", phaseEndPlanified); 
	        	cs.setString("p_phaseDurationArr", phaseDuration); 
	        	cs.setString("p_projectId", ProjectID); 
	        	cs.setString("p_phaseStatus", phaseStatus); 
	        		
	         }
	        rs = cs.executeQuery();
	        return lists;
		  }catch(Exception e) {
		   	e.printStackTrace();
		  }
		  finally {  
			  try {  
	    		if (rs != null) {  
	    	        rs.close();  
	    		}       
	    		if (cs != null) {  
	    	         cs.close();  
	    	    }  
	    	    if (conn != null) { 
	    	         conn.close();  
	    	    } 
	    	    session.flush();
	            session.clear();
	            session.close();
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " line 59: " + e.toString());  
	        }  
	    }
		return null;
	}
	
	public List<?> createProjectProperties(String projectID , String propertiesPresetID ,String propValues) throws Exception {
		Connection conn = null;
		CallableStatement cs = null;
		Session session = getSession();
		ResultSet rs = null; 
		List lists = new ArrayList();	
		HibernateTemplate template = null;
		try {
	        conn = session.connection();
	        System.out.println("Connection = "+conn);
	        if (cs == null)
	         {
	        	cs = conn.prepareCall("{call P_SET_BULK_PROPERTIES(?,?,?,?,?,?) }");
	        	cs.setString("p_projectFkArray", projectID); 
	        		System.out.println("projectID :"+projectID);
	        	cs.setString("p_propPresetFkArray", propertiesPresetID);
	        		System.out.println("p_propPresetFkArray :"+propertiesPresetID);
	        	cs.setString("p_fieldValueArray", propValues);
	        		System.out.println("p_fieldValueArray :"+propValues);
	        	cs.registerOutParameter("PJ_Array",OracleTypes.ARRAY,"PJ_ARR_FIELD");
		        cs.registerOutParameter("Preset_Array",OracleTypes.ARRAY,"PJ_ARR_PRESETFK");
		        cs.registerOutParameter("PropertiesIDArray",OracleTypes.ARRAY,"PJ_ARR_PROPERTYPJID");
	        		
	        }
	        rs = cs.executeQuery();
	        System.out.println("createProjectProperties ResultSet:"+rs);
	        Array presetArray = cs.getArray("Preset_Array");
	        Array valuesArray = cs.getArray("PJ_Array");
	        Array pjIdArray = cs.getArray("PropertiesIDArray");
	        BigDecimal[] values = (BigDecimal[]) presetArray.getArray();
	        String [] outValues = (String [])valuesArray.getArray();
	        BigDecimal [] pjIdValues = (BigDecimal [])pjIdArray.getArray();
	        System.out.println("Pj Values "+valuesArray.getArray()+" ---- "+presetArray.getArray());
	       
	        lists.add(outValues);
	        lists.add(values);
	        lists.add(pjIdValues);
			
			return lists;
		  }catch(Exception e) {
		   	e.printStackTrace();
		  }
		  finally {  
    		try {  
		    		if (rs != null) {  
		    	        rs.close();  
		    		}       
		    		if (cs != null) {  
		    	         cs.close();  
		    	    }  
		    	    if (conn != null) { 
		    	         conn.close();  
		    	    } 
		    	    session.flush();
		            session.clear();
		            session.close();
    	    	}  
    	        catch (Exception e) {  
    	           System.out.println(e.getClass().getName() +  " line 59: " + e.toString());  
    	        }  
		  }
		 return null;
	} 
	public List<?> createOracleNewProject(String projectConfigCode,String projectName,String projectComments,int categoryId, 
										  int personId,String parentFolderName,Categories categorydomain,Categories category1,
										  Categories category2,int p_workflowfk,String codeEAN,String codeGEST,String codeIMPRE,int codeIMPID,
										  String phaseTemp , String phaseCode ,String phaseName ,String phaseStart ,String phaseEndPlanified,
			String phaseDuration,int phaseStatus,int workflowTemplatesId, String endTaskCode) throws Exception {
		
		System.out.println("projectName ----------------------------: "+projectName);
		System.out.println("categoryId ----------------------------: "+categoryId);
		System.out.println("personId :---------------------------:"+personId);
		System.out.println("p_workflowfk :---------------------------:"+p_workflowfk);
		System.out.println("projectComments :---------------------------:"+projectComments);
		System.out.println("p_codeEan :---------------------------:"+codeEAN);
		System.out.println("p_codeGestionSap :---------------------------:"+codeGEST);
		System.out.println("p_impremiourName :---------------------------:"+codeIMPRE);
		System.out.println("p_incrementPcode :---------------------------:"+projectConfigCode);
		System.out.println("p_imprimeurId :---------------------------:"+codeIMPID);
		System.out.println("p_workflowtemplatesId :---------------------------:"+workflowTemplatesId);
		System.out.println("v_end_task_code :---------------------------:"+endTaskCode);
		System.out.println("-----------------------------------------------");	
		
		System.out.println("phaseTemp-----------------------------"+phaseTemp);
		System.out.println("phaseCode-----------------------------"+phaseCode);
		System.out.println("phaseName-----------------------------"+phaseName);
		System.out.println("phaseStart-----------------------------"+phaseStart);
		System.out.println("phaseEndPlanified-----------------------------"+phaseEndPlanified);
		System.out.println("phaseDuration-----------------------------"+phaseDuration);
		System.out.println("phaseStatus-----------------------------"+phaseStatus);
				    	
	    Connection conn = null;
	    CallableStatement cs = null;
	    ResultSet rs = null; 
	    Session session = getSession();
	    List lists = null;	
	    HibernateTemplate template = null;
	    
	    String codeEANs = "";
		String codeGESTs = "";
		String codeIMPREs = "  ";
	    try{
	    	 folderCreation(projectName,parentFolderName,categorydomain,category1,category2);
	         conn = session.connection();
	         System.out.println("Connection = "+conn);
	         if (cs == null)
	         { 
	        	cs = conn.prepareCall("{call P_CREATE_PROJECT_ROW(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	            cs.setString("p_projectName", projectName); 
	 				System.out.println("p_projectName :"+projectName);
		 		cs.setInt("p_categoryId", categoryId);   //82 or 2 == categoryId
		 			System.out.println("p_categoryId :"+categoryId);
	 			cs.setInt("p_personfk", personId);  
	 				System.out.println("personId :"+personId);	
	 			cs.setInt("p_workflowfk", p_workflowfk);  //1 == p_workflowfk
	 				System.out.println("p_workflowfk :"+p_workflowfk);
	 			byte[] projectCommentsBytes = projectComments.getBytes();	
	 			cs.setObject("p_projectComment", projectCommentsBytes);
	 				System.out.println("projectComments :"+projectComments);
	 			
	 			if((codeEAN!="") || (codeEAN!="null"))
	 				codeEANs = codeEAN;
	 			if((codeGEST!="") || (codeGEST!="null"))
	 				codeGESTs = codeGEST;
	 			if((codeIMPRE!="") || (codeIMPRE!=null))
	 				codeIMPREs = codeIMPRE;
	 			
	 			cs.setString("p_codeEan", codeEANs); 
	 				System.out.println("p_codeEan :"+codeEANs);
 				cs.setString("p_codeGestionSap", codeGESTs);
 					System.out.println("p_codeGestionSap :"+codeGESTs);
 				cs.setString("p_impremiourName", codeIMPREs); 
 					System.out.println("p_impremiourName :"+codeIMPREs);
 				cs.setString("p_incrementPcode", projectConfigCode); 
	 				System.out.println("p_incrementPcode :"+projectConfigCode);
 				cs.setInt("p_imprimeurId", codeIMPID);   //new ImpremiurId
 					System.out.println("p_imprimeurId :"+codeIMPID);
 				cs.setString("p_phaseTempArr", phaseTemp);
 		        cs.setString("p_phaseCodeArr", phaseCode); 
 		        cs.setString("p_phasesNameArr", phaseName); 
 		        cs.setString("p_phaseStartArr", phaseStart); 
 		        cs.setString("p_phaseEndPlanifiedArr", phaseEndPlanified); 
 		        cs.setString("p_phaseDurationArr", phaseDuration); 
 		        cs.setInt("p_phaseStatus", phaseStatus); 
 		        cs.setInt("p_workflowtemplatesId", workflowTemplatesId); 
 		       	cs.setString("v_end_task_code", endTaskCode); 
	 			cs.registerOutParameter("cursor_project",OracleTypes.CURSOR);
	 			
	         }
	         System.out.println("Prepare call is done;");
	         rs = cs.executeQuery();
	         System.out.println("ResultSet:"+rs);
	         rs=(ResultSet)cs.getObject("cursor_project");
	         System.out.println("Prepare call is done;"+rs);
	         lists = new ArrayList();
	         
	         while(rs.next()) {
		         try{
		        	 int tempProjectId = rs.getInt(1);
		        	 System.out.println("projectId2 :::::"+rs.getInt(1));
		        	template = getHibernateTemplate();
		        	List<Projects> selectprojects = (template.find("select u from Projects u where u.projectId = "+tempProjectId));
		        	Projects project = (Projects)selectprojects.get(0);
			    	System.out.println("project :"+project.getProjectId()+" -- "+project.getProjectName());
			    	
			    	String fromfolderpath = modelcurDirWithoutProj+"/"+projectName;
			    	String tofolderpath = modelcurDirWithoutProj+"/"+project.getProjectName();
			    	System.out.println("modelcurDirWithoutProj :"+modelcurDirWithoutProj);
			    	if(modelcurDirWithoutProj!=null){	
				    	System.out.println("fromfolderpath :"+fromfolderpath+" ----- "+tofolderpath);
			    		moveDirectStructure(fromfolderpath, tofolderpath);
			    		System.out.println("folder created......... ");
			    	}
			    	
			    	System.out.println("project.getCategoryFKey() : "+project.getCategoryFKey());
			    	List<Categories> selectCategoriesdomain = (template.find("select u from Categories u where u.categoryId = "+project.getCategoryFKey()));
		        	Categories domaincategory1 = (Categories)selectCategoriesdomain.get(0);
		        	lists.add( selectCategoriesdomain );
		        	
			    	System.out.println("domaincategory1.getCategoryId() : "+domaincategory1.getCategoryId()+" -- "+domaincategory1.getCategoryFK().getCategoryId());
		        	List<Categories> selectCategories1 = (template.find("select u from Categories u where u.categoryId = "+domaincategory1.getCategoryFK().getCategoryId()));
		        	Categories rootcategory1 = (Categories)selectCategories1.get(0);
		        	lists.add( selectCategories1 );
		        	
			    	System.out.println("rootcategory1.getCategoryId() : "+rootcategory1.getCategoryId()+" -- "+rootcategory1.getCategoryFK().getCategoryId());
		        	List<Categories> selectCategories2 = (template.find("select u from Categories u where u.categoryId = "+rootcategory1.getCategoryFK().getCategoryId()));
		        	Categories rootcategory2 = (Categories)selectCategories2.get(0);
		        	lists.add( selectCategories2 );
		        	
		        	//*******************************
		        	/*String fromfolderpath = modelcurDirWithoutProj+"/"+projectName;
			    	String tofolderpath = modelcurDirWithoutProj+"/"+project.getProjectName();
			    	System.out.println("modelcurDirWithoutProj :"+modelcurDirWithoutProj);
			    	if(modelcurDirWithoutProj!=null){	
				    	System.out.println("fromfolderpath :"+fromfolderpath+" ----- "+tofolderpath);
			    		moveDirectStructure(fromfolderpath, tofolderpath);
			    		System.out.println("folder created......... ");
			    	}*/
			    	//*******************************
			    	lists.add( selectprojects );	
		        	System.out.println("selectprojects :"+selectprojects.size());
		        	
			    	List<Teamlines> teamlinelist = (template.find("select u from Teamlines u where u.projectID = "+project.getProjectId()));
			    	lists.add( teamlinelist );
			    	System.out.println("TEAMLINE teamlinelist :"+teamlinelist.size());
			    	List<Phases> phaseslist = (template.find("select u from Phases u where u.projectFk = "+project.getProjectId()));
			    	lists.add( phaseslist );
			    	System.out.println("PHASES phaseslist :"+phaseslist.size());
			    	List<Tasks> taskslist = (template.find("select u from Tasks u where u.projectFk = "+project.getProjectId()));
			    	lists.add( taskslist );
			    	System.out.println("TASKS taskslist :"+taskslist.size());
			    	List<Propertiespj> propertieslist = (template.find("select u from Propertiespj u where u.projectFk = "+project.getProjectId()));
			    	lists.add( propertieslist );
			    	System.out.println("PROPERTIESPJ propertieslist :"+propertieslist.size());

		         }catch(Exception e){e.printStackTrace();}
	         } 	       
			return lists;
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    finally {  
	    	try {  
	    		if (rs != null) {  
	    	        rs.close();  
	    		}       
	    		if (cs != null) {  
	    	         cs.close();  
	    	    }  
	    	    if (conn != null) { 
	    	         conn.close();  
	    	    }
	    	    session.flush();
	            session.clear();
	            session.close();			    	      
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " createOracleNewProject: " + e.toString());  
	        }  
	    }
	    return null;
	}
	public Projects modelnewproject = new Projects();
	public Categories modelcategroies1 = new Categories();
	public Categories modelcategroies2 = new Categories();
	public String modelcurrentDir = "";
	public String modelcurDirWithoutProj = null;
	
	public void folderCreation(String projectName,String parentRootName,Categories categorydomain,Categories category1,Categories category2) throws Exception {
		// C:/temp/CASINO/2010/Nov/DIA1001_KUMAR/ inner (Basic,Tasks)
		// parameter - parentFolderName
		// parameter - domain
		// parameter - cateories1,cateories2 - here work
		String parentFolderName = parentRootName;
		Categories domainparameter = new Categories();
		domainparameter = categorydomain;
		System.out.println("folderCreation domainparameter.getCategoryName() :"+domainparameter.getCategoryName());
		Categories localcategroies1 = new Categories();
		Categories localcategroies2 = new Categories();		
		Categories resultcategroies = new Categories();
		
		modelcategroies1 = category1;
		modelcategroies2 = category2;
		
		List returnlist = null;
		HibernateTemplate template = null;
	    try{	      		    	
	    	template = getHibernateTemplate();
	    	returnlist = new ArrayList();	
	    	
	    	localcategroies1 = modelcategroies1;	
	    	localcategroies2 = modelcategroies2;	
	    	System.out.println("folderCreation localcategroies1.getCategoryName() :"+localcategroies1.getCategoryName());
	    	String categoryName = localcategroies1.getCategoryName().toString();
	    	List<Categories> findByNameCategories = (template.find("select u from Categories u where u.categoryName = '"+categoryName+"'"));
	    	System.out.println("folderCreation findByNameCategories :"+findByNameCategories.size());
	    	if(findByNameCategories!=null&&findByNameCategories.size()>0){ 
	    		resultcategroies = getCategroies(findByNameCategories,domainparameter);
			}
	    	if(resultcategroies!=null){ 
		    	System.out.println("folderCreation resultcategroies :"+resultcategroies.getCategoryId());
	    		modelcategroies1 = resultcategroies;
	    		
    			System.out.println("folderCreation modelcategroies1.getCategoryName() :"+modelcategroies1.getCategoryName()+" ---- "+modelcategroies1.getCategoryFK().getCategoryId());

	    		if(localcategroies2 == null){ 
	    			
	    		}else{
	    			localcategroies2.setCategoryFK(resultcategroies);
	    			System.out.println("folderCreation localcategroies2.getCategoryName() :"+localcategroies2.getCategoryName()+" ---- "+localcategroies2.getCategoryFK().getCategoryId());

	    			modelcategroies2 = localcategroies2;
	    			System.out.println("folderCreation modelcategroies2.getCategoryName() :"+modelcategroies2.getCategoryName()+" ---- "+modelcategroies2.getCategoryFK().getCategoryId());

	    			localcategroies2 = modelcategroies2;
	    			modelcategroies2.setCategoryFK(modelcategroies1);
	    			//localcategroies1 = modelcategroies1;
	    			
	    			System.out.println("folderCreation modelcategroies2.getCategoryName() :"+modelcategroies2.getCategoryId()+" ---- "+modelcategroies2.getCategoryName()+" ---- "+modelcategroies2.getCategoryFK().getCategoryId());
	    			List<Categories> findByNameIdCategories;
	    			//findByNameIdCategories = (template.find("select u from Categories u where u.categoryName ='"+modelcategroies2.getCategoryName()+"' and u.categoryFK.categoryId = "+modelcategroies2.getCategoryFK().getCategoryId()+")"));
	    			findByNameIdCategories = (template.find("select u from Categories u where u.categoryName ='"+modelcategroies2.getCategoryName()+"' and u.categoryFK.categoryId = "+modelcategroies2.getCategoryFK().getCategoryId()+")"));
	    	    	System.out.println("folderCreation findByNameIdCategories :"+findByNameIdCategories.size());
	    	    	
	    	    	if(findByNameIdCategories.size() == 0){
	    	    		findByNameIdCategories = (template.find("select u from Categories u where u.categoryName ='"+modelcategroies2.getCategoryName()+"' and u.categoryFK.categoryId = "+modelcategroies2.getCategoryFK().getCategoryId()+")"));
		    	    	System.out.println("findByNameIdCategories :"+findByNameIdCategories.size());
	    	    	}
	    	    	if(findByNameIdCategories.size()>0){
	    	    		modelcategroies2 = (Categories)findByNameIdCategories.get(0);
	    	    		//modelnewproject.categories = modelcategroies2;
	    	    		System.out.println("folderCreation modelcategroies2 :"+modelcategroies2.getCategoryName());
	    	    		
	    	    		//------ createprojectfolder start -----
	    	    		modelcategroies2.setCategoryFK(modelcategroies1);
	    	    		localcategroies2 = modelcategroies2;
	    	    				//model.domain.categoryName - domainparameter.
		    			System.out.println("folderCreation parentFolderName :"+parentFolderName+domainparameter.getCategoryName());

	    	    		String domainyearmonth = parentFolderName+domainparameter.getCategoryName()+"/"+localcategroies2.getCategoryFK().getCategoryName()+"/"+localcategroies2.getCategoryName();
	    	    		String proj = projectName; //modelnewproject.getProjectName();
	    	    		String domainyearmonthproject = domainyearmonth+"/"+proj;
	    	    		modelcurrentDir = domainyearmonthproject;
	    	    		modelcurDirWithoutProj = null;
	    	    		modelcurDirWithoutProj = domainyearmonth;
	    	    		System.out.println("folderCreation modelcurrentDir :"+modelcurrentDir);
	    	    		String folderCreate = createDirectStructure(domainyearmonth, proj); // createDirectStructure -- directoryCreation.createSubDir
	    	    		System.out.println("folderCreation folderCreate :"+folderCreate);
	    	    		//------ createprojectfolder end -----
	    	    		//------ createbasicfolderevent start -----
	    	    		localcategroies2 = modelcategroies2;
	    	    		String basicfolderCreate = createDirectStructure(modelcurrentDir,"Basic");
	    	    		System.out.println("folderCreation basicfolderCreate :"+basicfolderCreate);
	    	    		//------ createbasicfolderevent end -----
	    	    		//------ createtasksfolderevent start -----
	    	    		localcategroies2 = modelcategroies2;
	    	    		String tasksfolderCreate = createDirectStructure(modelcurrentDir,"Tasks");
	    	    		System.out.println("folderCreation tasksfolderCreate :"+tasksfolderCreate);
	    	    		//------ createtasksfolderevent end -----  	    	    		
	    			} 
	    		}
	    	}
	    	if(findByNameCategories.size()>0){
	    		
	    	}else{
	    	}
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    finally {  
    		try {  
	    		if (template != null) {  
	    			template.flush(); 
	    			template.clear();
	    		} 
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " folderCreation: " + e.toString());  
	        }  
	    }	    
	}
	public List<?> createNavigationTasks(int currenttaskId,int workflowId, int workflownexttempId,int projId, int personId,String wftcode,String tasksComments) throws Exception {
    	System.out.println("createNavigationTasks :"+currenttaskId+" , workflowId "+workflowId+" , workflownexttempId :"+workflownexttempId+" , projId :"+projId+" , personId :"+personId+" , projectName :"+wftcode+" , tasksComments :"+tasksComments);
	    Connection conn = null;
	    CallableStatement cs = null;
	    ResultSet rs = null; 
	    Session session = getSession();	  
	    List lists = null;	
	    HibernateTemplate template = null;
	    
	    try{
	         conn = session.connection();
	         System.out.println("Connection = "+conn);
	         if (cs == null)
	         { 
	        	 System.out.println("Prepare before ");
	        	 cs = conn.prepareCall("{call P_CREATE_NAVIGATION_TASKS(?,?,?,?,?,?,?,?)}");
	             System.out.println("Prepare after ");
	            cs.setInt("P_CURRENT_TASK_ID", currenttaskId);  //1
	            System.out.println("currenttaskId :"+currenttaskId);
	             cs.setInt("P_WORKFLOW_FK", workflowId);  //1
	 			System.out.println("workflowId :"+workflowId);
	 			cs.setInt("P_NEXT_WORKFLOW_TEMPLATE_ID", workflownexttempId); //3
	 			System.out.println("workflownexttempId :"+workflownexttempId);
	 			cs.setInt("P_PROJECT_FK", projId);  //25
	 			System.out.println("projId :"+projId);
	 			cs.setInt("P_PERSON_FK", personId);  //2
	 			System.out.println("personId :"+personId);
	 			cs.setString("P_TASK_CODE", wftcode); //P3T01A
	 			System.out.println("projectName :"+wftcode);
	 			byte[] tasksCommentsBytes = tasksComments.getBytes();	
	 			cs.setObject("P_TASKCOMMENTS", tasksCommentsBytes);
	 			System.out.println("tasksComments :"+tasksComments);
	 			
	 			cs.registerOutParameter("cursor_tasks",OracleTypes.CURSOR);
	         }
	         System.out.println("Prepare call is done;");
	         rs = cs.executeQuery();
	         System.out.println("ResultSet:"+rs);
	         //rs=(ResultSet)((NewProxyCallableStatement)cs).getObject("cursor_tasks");
	         rs=(ResultSet)cs.getObject("cursor_tasks");
	         int index = 1;
	         System.out.println("Prepare call is done;"+rs);
	         
	         lists = new ArrayList();
	         
	         while(rs.next()) {
		         try{
		        	int tempTaskId = rs.getInt(1);
		        	System.out.println("tempTaskId :::::"+tempTaskId);
		        	template = getHibernateTemplate();
		        	List<Tasks> selecttasks = (template.find("select u from Tasks u where u.taskId = "+tempTaskId));
		        	Tasks task = (Tasks)selecttasks.get(0);
			    	System.out.println("task :"+task.getTaskId());
			    	lists.add(selecttasks);
			    	return lists;
		        }catch(Exception e) {
		 	    	e.printStackTrace();
		 	    }
	         }
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    finally {  
	    	try {  
	    		if (rs != null) {  
	    	        rs.close();  
	    		}       
	    		if (cs != null) {  
	    	      cs.close();  
	    	    }  
	    	    if (conn != null) { 
	    	       conn.close();  
	    	    }  
	    	    session.flush();
	            session.clear();
	            session.close(); 
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " createNavigationTasks: " + e.toString());  
	        }  
	    }
	    return null;		
	}
	public Categories getCategroies(List arrc,Categories paradomainCategory ) throws Exception {
		for(int i=0;i<arrc.size();i++){
			Categories item = (Categories)arrc.get(i);
			if(item.getCategoryFK().getCategoryId() == paradomainCategory.getCategoryId()){
				return item;
			}
		}
		return null;
	}
	public String createDirectStructure(String parentfolderPath,String newfolderpath) throws Exception {
		String creatfolder = null;
		FileUtil directoryCreation = new FileUtil();
		creatfolder = directoryCreation.createSubDir(parentfolderPath,newfolderpath);		
		return creatfolder;
	}
	public void moveDirectStructure(String fromfolderPath,String tofolderpath) throws Exception {
		FileUtil directoryCreation = new FileUtil();
		directoryCreation.copyDirectory(fromfolderPath,tofolderpath);		
	}
	public Categories getDomains(Categories categories ) throws Exception { 
		Categories tempCategories = new Categories(); 
		if(categories.getCategoryFK() != null)
		{
			tempCategories = getDomains(categories.getCategoryFK());
		}else
		{
			return categories;
		}
		return tempCategories;
	}
	public List<?> bulkDeleteId(int deftempvalueId) throws Exception {
		Connection conn = null;
	    CallableStatement cs = null;
	    Session session = getSession();
	    ResultSet rs = null;
	    List returnlist = null;
	    
	    try{	    	
	         conn = session.connection();
	         System.out.println("Connection = "+conn);
	         if (cs == null)
	         { 
	        	cs = conn.prepareCall("{call P_BULK_DELETE_DEF_TEMPVALUE(?)}");
	            cs.setInt("P_DEFTEMPFK", deftempvalueId);  
	            System.out.println("P_DEFTEMPFK :"+deftempvalueId);
	         }
	         System.out.println("Prepare call is done;");
	         rs = cs.executeQuery();
	         System.out.println("ResultSet:"+rs);
	         returnlist = new ArrayList();
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    return returnlist;
	} 
	public List<?> closeProjects(int p_projectId, int p_previousTask, int p_workflowfk, String p_tasksComment, 
			String p_propPresetFkArray, String p_fieldValueArray, String p_closingMode, int p_personFk) throws Exception {
		    
		Connection conn = null;
	    CallableStatement cs = null;
	    ResultSet rs = null; 
	    ResultSet rsObj = null;
	    Session session = getSession();
	    List lists = null;	
	    HibernateTemplate template = null;		
	    try{
	         conn = session.connection();
	         System.out.println("closeProjects Connection = "+conn);
	         if (cs == null)
	         { 
	        	cs = conn.prepareCall("{call P_CLOSE_PROJECT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	            cs.setInt("p_projectId", p_projectId); 
	 				System.out.println("p_projectId :"+p_projectId);
		 		cs.setInt("p_previousTask", p_previousTask);   
		 			System.out.println("p_previousTask :"+p_previousTask);
	 			cs.setInt("p_workflowfk", p_workflowfk);  
	 				System.out.println("p_workflowfk :"+p_workflowfk);	
	 			byte[] tasksCommentsBytes = p_tasksComment.getBytes();	
	 			cs.setObject("p_tasksComment", tasksCommentsBytes);
	 				System.out.println("p_tasksComment :"+p_tasksComment);
	 			
	        	cs.setString("p_propPresetFkArray", p_propPresetFkArray);
	        		System.out.println("p_propPresetFkArray :"+p_propPresetFkArray);
	        	cs.setString("p_fieldValueArray", p_fieldValueArray);
	        		System.out.println("p_fieldValueArray :"+p_fieldValueArray);
	        	cs.setString("p_closingMode", p_closingMode); 
	 				System.out.println("p_closingMode :"+p_closingMode);
	 			cs.setInt("p_personFk", p_personFk);   
		 			System.out.println("p_personFk :"+p_personFk);	
		 			
		 		cs.registerOutParameter("o_project",OracleTypes.CURSOR);
		 			
	        	cs.registerOutParameter("o_array_propValues",OracleTypes.ARRAY,"PJ_ARR_FIELD");
		        cs.registerOutParameter("o_array_propPresets",OracleTypes.ARRAY,"PJ_ARR_PRESETFK");
		        cs.registerOutParameter("o_array_propIds",OracleTypes.ARRAY,"PJ_ARR_PROPERTYPJID");		        
		        cs.registerOutParameter("o_array_phases",OracleTypes.ARRAY,"T_ARR_PHASES");
		        cs.registerOutParameter("o_array_tasks",OracleTypes.ARRAY,"T_ARR_TASKS");
		        cs.registerOutParameter("o_array_wf_templates",OracleTypes.ARRAY,"T_ARR_WF_TEMPLATES");
	 			
	         }
	         System.out.println("closeProjects Prepare call is done;");
	         rs = cs.executeQuery();
	         System.out.println("closeProjects ResultSet:"+rs);
	         rs = (ResultSet)cs.getObject("o_project");
	         System.out.println("closeProjects o_project ResultSet :"+rs);
	         lists = new ArrayList();
	         
	         Array simpleArray = cs.getArray("o_array_propPresets");
	         Array valuesArray = cs.getArray("o_array_propValues");
	         Array PjIDArray = cs.getArray("o_array_propIds");	         
	         BigDecimal[] values = (BigDecimal[]) simpleArray.getArray();
	         String [] outValues = (String [])valuesArray.getArray();
	         BigDecimal [] PjValues = (BigDecimal [])PjIDArray.getArray();
	         System.out.println("closeProjects filedValues "+valuesArray.getArray()+" ---- "+simpleArray.getArray());
	         
	         Array phasesArray = cs.getArray("o_array_phases");
	         Array tasksArray = cs.getArray("o_array_tasks");
	         Array wfArray = cs.getArray("o_array_wf_templates");
	         
	         System.out.println("closeProjects phasesArray :"+phasesArray.getArray());
	         System.out.println("closeProjects tasksvalues :"+tasksArray.getArray());
	         System.out.println("closeProjects wfvalues :"+wfArray.getArray());	         
	         System.out.println("closeProjects phasesArray :"+phasesArray.getClass().getName());
	         	        
	         while(rs.next()) {
		         try{		        	 
		        	 int returnprojectId = rs.getInt(1);
		        	 	System.out.println("closeProjects returnprojectId :"+rs.getInt(1));
		        	 template = getHibernateTemplate();
		        	 List<Projects> selectprojects = (template.find("select u from Projects u where u.projectId = "+returnprojectId));
		        	 Projects project = (Projects)selectprojects.get(0);
		        	 	System.out.println("closeProjects project :"+project.getProjectId()+" -- "+project.getProjectName());
		        	 
		        	 lists.add( selectprojects );	//1
		        	 	System.out.println("closeProjects selectprojects :"+selectprojects.size());
		        	 
		        	 lists.add(outValues);	//2
		        	 	System.out.println("closeProjects outValues :"+outValues.length);
		   	         lists.add(values);		//3
		        	 	System.out.println("closeProjects values :"+values.length);
		   	         lists.add(PjValues); 	//4
		        	 	System.out.println("closeProjects PjValues :"+PjValues.length);

		        	 List<Phases> selectphases = (template.find("select u from Phases u where u.projectFk = "+returnprojectId));
		        	 lists.add(selectphases); 	//5
		        	 	System.out.println("closeProjects selectphases :"+selectphases.size());

		        	 List<Tasks> selecttasks = (template.find("select u from Tasks u, Status s where u.taskStatusFK = s.statusId and s.type = 'task_status' and (s.statusLabel='waiting' or s.statusLabel='in_progress' or s.statusLabel='stand_by') and u.projectFk = "+returnprojectId+")"));
		        	 lists.add(selecttasks); 	//6
		        	 	System.out.println("closeProjects selecttasks :"+selecttasks.size());
		        	
		        	 List<Workflowstemplates> selectworkflowtemplates = (template.find("select w from Tasks u, Status s, Workflowstemplates w where u.taskStatusFK = s.statusId and s.type = 'task_status' and (s.statusLabel='waiting' or s.statusLabel='in_progress' or s.statusLabel='stand_by') and u.wftFK = w.workflowTemplateId and u.projectFk = "+returnprojectId+")"));
		        	 lists.add(selectworkflowtemplates); 	//7
		        	 	System.out.println("closeProjects selectworkflowtemplates :"+selectworkflowtemplates.size());
		        	 				    	
		         }catch(Exception e){e.printStackTrace();}
	         } 
			return lists;
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    finally {  
	    	try {  
	    		if (rs != null) {  
	    	        rs.close();  
	    		}       
	    		if (cs != null) {  
	    	         cs.close();  
	    	    }  
	    	    if (conn != null) { 
	    	         conn.close();  
	    	    }
	    	    session.flush();
	            session.clear();
	            session.close();			    	      
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " closeProjects: " + e.toString());  
	        }  
	    }
	    return null;
	}
	
	public List<?> createReferenceFiles(int ref_projectId,int current_projectId, int current_taskId,String refTypeName,String refCategoryName, int txtInputImpLength, int clientTeamlineId, String propertiesprojectId , String propertiesPresetId ,String propertiespropValues) throws Exception {
    	System.out.println("createReferenceFiles :"+ref_projectId+" , current_projectId "+current_projectId+" , current_taskId :"+current_taskId+" , refTypeName :"+refTypeName+" , refCategoryName :"+refCategoryName+" , txtInputImpLength :"+txtInputImpLength+" , clientTeamlineId :"+clientTeamlineId+" , propertiesprojectId :"+propertiesprojectId+" , propertiesPresetId :"+propertiesPresetId+" , propertiespropValues :"+propertiespropValues);
	    Connection conn = null;
	    CallableStatement cs = null;
	    ResultSet rs = null; 
	    Session session = getSession();	  
	    List lists = new ArrayList();	
	    HibernateTemplate template = null;
	    
	    try{
	         conn = session.connection();
	         System.out.println("createReferenceFiles Connection = "+conn);
	         if (cs == null)
	         { 	             
	        	 System.out.println("Prepare before ");
	        	cs = conn.prepareCall("{call P_REF_UPDATE_FILE_TEAMLINE(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	        	 //cs = conn.prepareCall("{call P_REF_UPDATE_FILE_TEAMLINE(?,?,?,?,?,?,?)}");
	             	System.out.println("Prepare after ");
	             cs.setInt("p_ref_projectId", ref_projectId);
	             	System.out.println("p_ref_projectId :"+ref_projectId);
	             cs.setInt("p_current_projectId", current_projectId); 
	 			 	System.out.println("p_current_projectId :"+current_projectId);
	 			 cs.setInt("p_current_taskId", current_taskId); 
	 			 	System.out.println("p_current_taskId :"+current_taskId);
	 			 cs.setString("p_refTypeName", refTypeName);  
	 			 	System.out.println("p_refTypeName :"+refTypeName);
	 			 cs.setString("p_refCategoryName", refCategoryName);  
	 			 	System.out.println("p_refCategoryName :"+refCategoryName);
	 			 cs.setInt("p_txtInputImpLength", txtInputImpLength);
	             	System.out.println("p_txtInputImpLength :"+txtInputImpLength);
	             cs.setInt("p_clientTeamlineId", clientTeamlineId); 
	 			 	System.out.println("p_clientTeamlineId :"+clientTeamlineId);	
	 			 	
	 			 cs.setString("p_propprojectFkArray", propertiesprojectId); 
	        		System.out.println("p_propprojectFkArray :"+propertiesprojectId);
	        	 cs.setString("p_propPresetFkArray", propertiesPresetId);
	        		System.out.println("p_propPresetFkArray :"+propertiesPresetId);
	        	 cs.setString("p_propfieldValueArray", propertiespropValues);
	        		System.out.println("p_propfieldValueArray :"+propertiespropValues);
	        		
	        	 cs.registerOutParameter("p_fieldArrValue",OracleTypes.ARRAY,"PJ_ARR_FIELD");
	        	 cs.registerOutParameter("p_presetArrID",OracleTypes.ARRAY,"PJ_ARR_PRESETFK");
	        	 cs.registerOutParameter("PropertiesIDArray",OracleTypes.ARRAY,"PJ_ARR_PROPERTYPJID");
	         }
	         System.out.println("createReferenceFiles Prepare call is done;");
	         rs = cs.executeQuery();
	         System.out.println("createReferenceFiles ResultSet:"+rs);
	         System.out.println("createReferenceFiles p_fieldArrValue :"+cs);
	         Array simpleArray = cs.getArray("p_presetArrID");
			 Array valuesArray = cs.getArray("p_fieldArrValue");
			 Array PjIDArray = cs.getArray("PropertiesIDArray");
			 BigDecimal[] values = (BigDecimal[]) simpleArray.getArray();
			 System.out.println("createReferenceFiles Pj Values :"+valuesArray.getArray()+" ---- "+simpleArray.getArray());
			
			 String [] outValues = (String [])valuesArray.getArray();
			 BigDecimal [] PjValues = (BigDecimal [])PjIDArray.getArray();
			 
			 lists.add(outValues);
			 lists.add(values);
			 lists.add(PjValues);
			 
			 try{
				 System.out.println("current_projectId :::::"+current_projectId);
				 template = getHibernateTemplate();
				 List<Teamlines> selectTeamlines = (template.find("select u from Teamlines u where u.projectID = "+current_projectId));
				 lists.add(selectTeamlines);
			 }
			 catch(Exception e) {
			   	e.printStackTrace();
			 } 
			 
	         return lists;		        
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    finally {  
	    	try {  
	    		if (rs != null) {  
	    	        rs.close();  
	    		}       
	    		if (cs != null) {  
	    	      cs.close();  
	    	    }  
	    	    if (conn != null) { 
	    	       conn.close();  
	    	    }  
	    	    session.flush();
	            session.clear();
	            session.close(); 
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " createReferenceFiles: " + e.toString());  
	        }  
	    }
	    return null;		
	}
	
	public List<?> findByDate(String dateandTimes,int personId) throws Exception {
		List list = null;
		HibernateTemplate template = null;
	    try{
	    	System.out.println("findByDate dateandTimes:"+dateandTimes+" , personId :"+personId);
	      		    	
	    	template = getHibernateTemplate();
	    	list = new ArrayList();	
	    	
	    	List<Projects> getRefreshList = (template.find("select prj,task from Projects prj, Tasks task where prj.projectId = (select distinct ev.projectFk from Events ev where ev.projectFk =  prj.projectId and ev.eventDateStart >=  to_date('"+dateandTimes+"', 'dd-mon-yyyy hh:mi:ss am') and prj.projectId = task.projectFk and task.taskId in (select max(t.taskId) from Teamlines tl, Tasks t, Grouppersons gp1, Grouppersons gp2 where gp1.personFk = "+personId+" and gp2.groupFk = gp1.groupFk and tl.personID = gp2.personFk and t.projectFk = tl.projectID group by t.projectFk))"));
	    	list.add( getRefreshList );	    
	    	
	    	System.out.println("findByDate getRefreshList:"+getRefreshList.size());
	    	  	
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    finally {  
    		try {  
	    		if (template != null) {  
	    			template.flush(); 
	    			template.clear();
	    		} 
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " findByDate: " + e.toString());  
	        }  
	    }
	    return list;
	} 	
	
	
  
	/*public List<?> createReferenceFiles(int ref_projectId,int current_projectId, int current_taskId,String refTypeName,String refCategoryName, int txtInputImpLength, int clientTeamlineId, String propertiesprojectId , String propertiesPresetId ,String propertiespropValues) throws Exception {
    	System.out.println("createReferenceFiles :"+ref_projectId+" , current_projectId "+current_projectId+" , current_taskId :"+current_taskId+" , refTypeName :"+refTypeName+" , refCategoryName :"+refCategoryName+" , txtInputImpLength :"+txtInputImpLength+" , clientTeamlineId :"+clientTeamlineId+" , propertiesprojectId :"+propertiesprojectId+" , propertiesPresetId :"+propertiesPresetId+" , propertiespropValues :"+propertiespropValues);
	    Connection conn = null;
	    CallableStatement cs = null;
	    ResultSet rs = null; 
	    Session session = getSession();	  
	    List lists = new ArrayList();	
	    HibernateTemplate template = null;
	    
	    try{
	         conn = session.connection();
	         System.out.println("createReferenceFiles Connection = "+conn);
	         if (cs == null)
	         { 	             
	        	 System.out.println("Prepare before ");
	        	 cs = conn.prepareCall("{call P_REF_UPDATE_FILE_TEAMLINE(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	             	System.out.println("Prepare after ");
	             cs.setInt("p_ref_projectId", ref_projectId);
	             	System.out.println("p_ref_projectId :"+ref_projectId);
	             cs.setInt("p_current_projectId", current_projectId); 
	 			 	System.out.println("p_current_projectId :"+current_projectId);
	 			 cs.setInt("p_current_taskId", current_taskId); 
	 			 	System.out.println("p_current_taskId :"+current_taskId);
	 			 cs.setString("p_refTypeName", refTypeName);  
	 			 	System.out.println("p_refTypeName :"+refTypeName);
	 			 cs.setString("p_refCategoryName", refCategoryName);  
	 			 	System.out.println("p_refCategoryName :"+refCategoryName);
	 			 cs.setInt("p_txtInputImpLength", txtInputImpLength);
	             	System.out.println("p_txtInputImpLength :"+txtInputImpLength);
	             cs.setInt("p_clientTeamlineId", clientTeamlineId); 
	 			 	System.out.println("p_clientTeamlineId :"+clientTeamlineId);	 			
	 			 cs.setString("p_propprojectFkArray", propertiesprojectId); 
	        		System.out.println("p_propprojectFkArray :"+propertiesprojectId);
	        	 cs.setString("p_propPresetFkArray", propertiesPresetId);
	        		System.out.println("p_propPresetFkArray :"+propertiesPresetId);
	        	 cs.setString("p_propfieldValueArray", propertiespropValues);
	        		System.out.println("p_propfieldValueArray :"+propertiespropValues);
	        		
	        	 cs.registerOutParameter("p_fieldArrValue",OracleTypes.ARRAY,"PJ_ARR_FIELD");
	        	 cs.registerOutParameter("p_presetArrID",OracleTypes.ARRAY,"PJ_ARR_PRESETFK");
	        	 cs.registerOutParameter("PropertiesIDArray",OracleTypes.ARRAY,"PJ_ARR_PROPERTYPJID");
	         }
	         System.out.println("createReferenceFiles Prepare call is done;");
	         rs = cs.executeQuery();
	         System.out.println("createReferenceFiles ResultSet:"+rs);
	         System.out.println("createReferenceFiles p_fieldArrValue :"+cs);
	         Array simpleArray = cs.getArray("p_presetArrID");
			 Array valuesArray = cs.getArray("p_fieldArrValue");
			 Array PjIDArray = cs.getArray("PropertiesIDArray");
			 BigDecimal[] values = (BigDecimal[]) simpleArray.getArray();
			 System.out.println("createReferenceFiles Pj Values :"+valuesArray.getArray()+" ---- "+simpleArray.getArray());
			
			 String [] outValues = (String [])valuesArray.getArray();
			 BigDecimal [] PjValues = (BigDecimal [])PjIDArray.getArray();
			 
			 lists.add(outValues);
			 lists.add(values);
			 lists.add(PjValues);
			 
			 try{
				 System.out.println("current_projectId :::::"+current_projectId);
				 template = getHibernateTemplate();
				 List<Teamlines> selectTeamlines = (template.find("select u from Teamlines u where u.projectID = "+current_projectId));
				 lists.add(selectTeamlines);
			 }
			 catch(Exception e) {
			   	e.printStackTrace();
			 } 
			 
	         return lists;		        
	    }catch(Exception e) {
	    	e.printStackTrace();
	    }
	    finally {  
	    	try {  
	    		if (rs != null) {  
	    	        rs.close();  
	    		}       
	    		if (cs != null) {  
	    	      cs.close();  
	    	    }  
	    	    if (conn != null) { 
	    	       conn.close();  
	    	    }  
	    	    session.flush();
	            session.clear();
	            session.close(); 
	    	}  
	        catch (Exception e) {  
	           System.out.println(e.getClass().getName() +  " createReferenceFiles: " + e.toString());  
	        }  
	    }
	    return null;		
	}*/
}