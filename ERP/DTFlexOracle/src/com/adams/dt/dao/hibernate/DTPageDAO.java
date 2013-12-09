package com.adams.dt.dao.hibernate;
 
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.ArrayList; 
import java.sql.*;

import oracle.jdbc.driver.OracleCallableStatement;
import oracle.jdbc.driver.OracleTypes;
import oracle.sql.BLOB;

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
import com.mchange.v2.c3p0.impl.NewProxyCallableStatement;
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
	    return list;
	} 
	 
	public List<?> SelectALLCategories(Integer catID) throws Exception {
    	//System.out.println("createProjectList projectName :"+projectName+" , categoryId :"+categoryId+" , personId :"+personId);
		List list = null;
		Query query = null;
		try {
			list = new ArrayList();
			query = getSession().getNamedQuery("Categories.SelectALLCategories"); 
			System.out.println("query :"+query.getQueryString());			
			System.out.println("query.list() :"+query.list().size());
			//query.setParameter(1, OracleTypes.CURSOR); 
			query.setInteger(1, catID);
			List<?> objectsList = query.list();  
			System.out.println("objectsList:"+objectsList.size());
			
			list.add(objectsList);
			return list;
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("SQL server db exception."+e.getMessage());
			
		}	 
		
	} 
	public List<?> createBulkTasks(int workflowId, int workflownexttempId,int projId, int personId,String wftcode) throws Exception {
    	System.out.println("createBulkTasks workflowId :"+workflowId+" , workflownexttempId :"+workflownexttempId+" , projId :"+projId+" , personId :"+personId+" , projectName :"+wftcode);
    	Transaction tx = null;
	    Connection conn = null;
	    CallableStatement cs = null;
	    ResultSet rs = null; 
	    Session session = getSession();
	    try{
	    	 tx = session.beginTransaction();
	    	 System.out.println("beginTransaction call "+tx);
	         conn = session.connection();
	         System.out.println("Connection = "+conn);
	         if (cs == null)
	         { 
	        	 System.out.println("Prepare before ");
	        	 cs = conn.prepareCall("{call P_CREATE_BULK_TASKS(?,?,?,?,?) }");
	             System.out.println("Prepare after ");
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
	         }
	         System.out.println("Prepare call is done;");
	         rs = cs.executeQuery();
	         System.out.println("ResultSet:"+rs);
	         int index = 1;
	        while(rs.next()) {
	         
	        	System.out.println( "index " + index);
	        	 index++;
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
	    	    	}  
	    	        catch (Exception e) {  
	    	           System.out.println(e.getClass().getName() +  " line 59: " + e.toString());  
	    	        }  
	    }
	    return null;
		
	}
	
	public List<?> createOracleNewProject(String projectConfigCode,String projectName,String projectComments,int categoryId, int personId,String parentFolderName,Categories categorydomain,Categories category1,Categories category2,int p_workflowfk,String codeEAN,String codeGEST,String codeIMPRE) throws Exception {
    	System.out.println("createOracleNewProject projectConfigCode :"+projectConfigCode+" , projectName :"+projectName+" , projectComments :"+projectComments+" , categoryId :"+categoryId+" , personId :"+personId+" , parentFolderName :"+parentFolderName+" , categorydomain :"+categorydomain.getCategoryName()+" , category1 :"+category1.getCategoryName()+" , category2 :"+category2.getCategoryName()+" , p_workflowfk :"+p_workflowfk+" , codeEAN :"+codeEAN+" , codeGEST :"+codeGEST+" , codeIMPRE :"+codeIMPRE);
    	Transaction tx = null;
	    Connection conn = null;
	    CallableStatement cs = null;
	    ResultSet rs = null; 
	    Session session = getSession();
	    List lists = null;	
	    HibernateTemplate template = null;
	    
	    String codeEANs = "";
		String codeGESTs = "";
		String codeIMPREs = "";
		
	    try{
	    	 folderCreation(projectName,parentFolderName,categorydomain,category1,category2);
	    	
	    	 tx = session.beginTransaction();
	    	 System.out.println("beginTransaction call "+tx);
	         conn = session.connection();
	         System.out.println("Connection = "+conn);
	         if (cs == null)
	         { 
	        	 		System.out.println("Prepare before ");
	        	cs = conn.prepareCall("{call P_CREATE_PROJECT_ROW(?,?,?,?,?,?,?,?,?,?) }");
	             		System.out.println("Prepare after ");
	            cs.setString("p_projectName", projectName); 
		 				System.out.println("projectName :"+projectName);
		 				
		 		cs.setInt("p_categoryId", categoryId);   //82 or 2 == categoryId
	 					System.out.println("categoryId :"+categoryId);
	 			cs.setInt("p_personfk", personId);  
	 					System.out.println("personId :"+personId);	
	 					
				cs.setInt("p_workflowfk", p_workflowfk);  //1 == p_workflowfk
						System.out.println("p_workflowfk :"+p_workflowfk);
	 			byte[] projectCommentsBytes = projectComments.getBytes();	
	 			cs.setObject("p_projectComment", projectCommentsBytes);
	 					System.out.println("projectComments :"+projectComments);
	 			
	 			if((codeEAN!="") || (codeEAN!=null))
	 				codeEANs = codeEAN;
	 			if((codeGEST!="") || (codeGEST!=null))
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
	 			cs.registerOutParameter("cursor_project",OracleTypes.CURSOR);
	         }
	         System.out.println("Prepare call is done;");
	         rs = cs.executeQuery();
	         System.out.println("ResultSet:"+rs);
	         rs=(ResultSet)((NewProxyCallableStatement)cs).getObject("cursor_project");
	         int index = 1;
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
		        	List<Categories> selectCategoriesdomain = (template.find("select u from Categories u where u.categoryId = "+project.getCategoryFKey()));
		        	Categories domaincategory1 = (Categories)selectCategoriesdomain.get(0);
		        	lists.add( selectCategoriesdomain );
		        	
		        	List<Categories> selectCategories1 = (template.find("select u from Categories u where u.categoryId = "+domaincategory1.getCategoryId()));
		        	Categories rootcategory1 = (Categories)selectCategories1.get(0);
		        	lists.add( selectCategories1 );
		        	
		        	List<Categories> selectCategories2 = (template.find("select u from Categories u where u.categoryId = "+rootcategory1.getCategoryId()));
		        	Categories rootcategory2 = (Categories)selectCategories2.get(0);
		        	lists.add( selectCategories2 );
		        	
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
	    	    	}  
	    	        catch (Exception e) {  
	    	           System.out.println(e.getClass().getName() +  " line 59: " + e.toString());  
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
	    	System.out.println("localcategroies1.getCategoryName() :"+localcategroies1.getCategoryName());
	    	String categoryName = localcategroies1.getCategoryName().toString();
	    	List<Categories> findByNameCategories = (template.find("select u from Categories u where u.categoryName = '"+categoryName+"'"));
	    	System.out.println("findByNameCategories :"+findByNameCategories.size());
	    	if(findByNameCategories!=null&&findByNameCategories.size()>0){ 
	    		resultcategroies = getCategroies(findByNameCategories,domainparameter);
			}
	    	if(resultcategroies!=null){
		    	System.out.println("resultcategroies :"+resultcategroies.getCategoryId());
	    		modelcategroies1 = resultcategroies;
	    		if(localcategroies2 == null){
	    			
	    		}else{
	    			localcategroies2.setCategoryFK(resultcategroies);
	    			modelcategroies2 = localcategroies2;
	    			
	    			localcategroies2 = modelcategroies2;
	    			modelcategroies2.setCategoryFK(modelcategroies1);
	    			localcategroies1 = modelcategroies1;
	    			
	    			System.out.println("modelcategroies2.getCategoryName() :"+modelcategroies2.getCategoryName()+" ---- "+modelcategroies2.getCategoryFK().getCategoryId());
	    	    	List<Categories> findByNameIdCategories = (template.find("select u from Categories u where u.categoryName ='"+modelcategroies2.getCategoryName()+"' and u.categoryFK.categoryId = "+modelcategroies2.getCategoryFK().getCategoryId()+")"));
	    	    	System.out.println("findByNameIdCategories :"+findByNameIdCategories.size());
	    	    	if(findByNameIdCategories.size()>0){
	    	    		modelcategroies2 = (Categories)findByNameIdCategories.get(0);
	    	    		//modelnewproject.categories = modelcategroies2;
	    	    		System.out.println("modelcategroies2 :"+modelcategroies2.getCategoryName());
	    	    		
	    	    		//------ createprojectfolder start -----
	    	    		modelcategroies2.setCategoryFK(modelcategroies1);
	    	    		localcategroies2 = modelcategroies2;
	    	    				//model.domain.categoryName - domainparameter.
	    	    		String domainyearmonth = parentFolderName+domainparameter.getCategoryName()+"/"+localcategroies2.getCategoryFK().getCategoryName()+"/"+localcategroies2.getCategoryName();
	    	    		String proj = projectName; //modelnewproject.getProjectName();
	    	    		String domainyearmonthproject = domainyearmonth+"/"+proj;
	    	    		modelcurrentDir = domainyearmonthproject;
	    	    		modelcurDirWithoutProj = null;
	    	    		modelcurDirWithoutProj = domainyearmonth;
	    	    		System.out.println("modelcurrentDir :"+modelcurrentDir);
	    	    		String folderCreate = createDirectStructure(domainyearmonth, proj); // createDirectStructure -- directoryCreation.createSubDir
	    	    		System.out.println("folderCreate :"+folderCreate);
	    	    		//------ createprojectfolder end -----
	    	    		//------ createbasicfolderevent start -----
	    	    		localcategroies2 = modelcategroies2;
	    	    		String basicfolderCreate = createDirectStructure(modelcurrentDir,"Basic");
	    	    		System.out.println("basicfolderCreate :"+basicfolderCreate);
	    	    		//------ createbasicfolderevent end -----
	    	    		//------ createtasksfolderevent start -----
	    	    		localcategroies2 = modelcategroies2;
	    	    		String tasksfolderCreate = createDirectStructure(modelcurrentDir,"Tasks");
	    	    		System.out.println("tasksfolderCreate :"+tasksfolderCreate);
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
	}
	public List<?> createNavigationTasks(int currenttaskId,int workflowId, int workflownexttempId,int projId, int personId,String wftcode,String tasksComments) throws Exception {
    	System.out.println("createNavigationTasks :"+currenttaskId+" , workflowId "+workflowId+" , workflownexttempId :"+workflownexttempId+" , projId :"+projId+" , personId :"+personId+" , projectName :"+wftcode+" , tasksComments :"+tasksComments);
    	Transaction tx = null;
	    Connection conn = null;
	    CallableStatement cs = null;
	    ResultSet rs = null; 
	    Session session = getSession();
	    try{
	    	 tx = session.beginTransaction();
	    	 System.out.println("beginTransaction call "+tx);
	         conn = session.connection();
	         System.out.println("Connection = "+conn);
	         if (cs == null)
	         { 
	        	 System.out.println("Prepare before ");
	        	 cs = conn.prepareCall("{call P_CREATE_NAVIGATION_TASKS(?,?,?,?,?,?,?) }");
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
	         }
	         System.out.println("Prepare call is done;");
	         rs = cs.executeQuery();
	         System.out.println("ResultSet:"+rs);
	         int index = 1;
	        
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
	    	    	}  
	    	        catch (Exception e) {  
	    	           System.out.println(e.getClass().getName() +  " line 59: " + e.toString());  
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
}