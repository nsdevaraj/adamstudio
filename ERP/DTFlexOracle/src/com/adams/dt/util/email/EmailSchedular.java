package com.adams.dt.util.email;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import com.adams.dt.pojo.Events;
import com.adams.dt.util.BuildConfig;
import com.adams.dt.util.EncryptUtil;

public final class EmailSchedular extends java.util.TimerTask {
	private String serverLocation = null;
	private EncryptUtil encryptUtil = null;
	public EmailSchedular() {
		serverLocation = "http://"+BuildConfig.serverAddress+":"+BuildConfig.serverPort+"/"+BuildConfig.applicationContext+"/";
    	eventsList = new ArrayList<Events>();
    	encryptUtil = new EncryptUtil();
	}
	
	private List<Events> eventsList = null;
	
	public void run(){		
	    //try implementation
	    System.out.println("Sending mail...");
	    StringBuffer sqlquery = null;
		StringBuffer urlLinkBuf = null;
		StringBuffer body = null;
	    try {	    	
	    	if(BuildConfig.db.trim().equalsIgnoreCase("mysql")) {
	    		sqlquery = new StringBuffer("");
		    	sqlquery.append("select t.task_ID, t.workflow_template_FK, p.project_Id, p.Project_Name, per.person_id, per.Person_Login, per.Person_Email, per.Person_Password, pr.profile_code, st.status_id, comp.Company_Name " )
		    	.append(	    		"from projects p, companies comp, status st, profiles pr, tasks t join persons per on per.Person_ID = t.person_FK " )
		    	.append(	    		"where TIMESTAMPDIFF(HOUR,t.t_date_creation, CURRENT_TIMESTAMP()) >48 " )
		    	.append(	    			"and st.status_label = REPLACE(REPLACE(pr.profile_code, 'EPR', 'IMPMAIL'), 'IND', 'INDMAIL') " )
		    	.append(	    			"and comp.Company_ID = per.Company_FK " )
		    	.append(	    			"and t.task_ID= (select max(t0.task_ID) " )
		    	.append(	    							"from tasks t0, workflow_templates w, status st " )
		    	.append(	    							"where t0.project_FK= p.Project_ID " )
		    	.append(	    								"and t0.workflow_template_FK = w.workflow_template_ID " )
		    	.append(	    								"and pr.Profile_ID = w.profile_FK " )
		    	.append(	    								"and pr.profile_code in ('EPR', 'IND') " )
		    	.append(	    								"and st.status_ID = t0.task_status_FK " )
		    	.append(	    								"and st.status_label in ('waiting', 'in_progress'))");
	    	} else if(BuildConfig.db.trim().equalsIgnoreCase("oracle")) {
	    		sqlquery = new StringBuffer("");
	    		sqlquery.append("select t.task_ID, t.workflow_template_FK, p.project_Id, p.Project_Name, per.person_id, per.Person_Login, per.Person_Email, per.Person_Password, pr.profile_code, st.status_id, comp.Company_Name " )
		    	.append(	    		"from projects p, companies comp, status st, profiles pr, tasks t join persons per on per.Person_ID = t.person_FK " )
		    	.append(	    		"where (sysdate-t.t_date_creation)*24 >48 " )
		    	.append(	    			"and st.status_label = REPLACE(REPLACE(pr.profile_code, 'EPR', 'IMPMAIL'), 'IND', 'INDMAIL') " )
		    	.append(	    			"and comp.Company_ID = per.Company_FK " )
		    	.append(	    			"and t.task_ID= (select max(t0.task_ID) " )
		    	.append(	    							"from tasks t0, workflow_templates w, status st " )
		    	.append(	    							"where t0.project_FK= p.Project_ID " )
		    	.append(	    								"and t0.workflow_template_FK = w.workflow_template_ID " )
		    	.append(	    								"and pr.Profile_ID = w.profile_FK " )
		    	.append(	    								"and pr.profile_code in ('EPR', 'IND') " )
		    	.append(	    								"and st.status_ID = t0.task_status_FK " )
		    	.append(	    								"and st.status_label in ('waiting', 'in_progress'))");
	    	}
			List<?> lists = BuildConfig.dtPageDAO.getQueryResult(sqlquery.toString());
			String messageContent = "Messieurs,<div><div><br></div><div>Nous sommes en charge de la photogravure de la reference citee en objet.</div><div>Merci de bien vouloir consulter et valider le process technique en cliquant le lien suivant :</div><div><br></div><div><a href=";
			String postMessage = "</div><div><br></div><div>Vous y trouverez le fichier PDF agence dans l'onglet 'Files'.</div><div>Nous realiserons les photogravures sur reception de votre validation en ligne.</div><div>Merci de votre collaboration.</div><div><br></div></div>";
			EmailDispatcher dispatchEmail = new EmailDispatcher();
			dispatchEmail.openTransport();
			for(Object object: lists ) {
				urlLinkBuf = new StringBuffer("");
				body = new StringBuffer("");

				Object[] recordList = (Object[])object;
				Integer taskId = (Integer)recordList[0];
				Integer workflowTemplateFk = (Integer)recordList[1];
				Integer projectId = (Integer)recordList[2];
				String projectName = (String)recordList[3];
				Integer personId = (Integer)recordList[4];
				String impEmailUser = (String)recordList[5];
				String personEmail = (String)recordList[6];
				String impEmailPwd = (String)recordList[7];
				String profileCode = (String)recordList[8];
				Integer eventType = (Integer)recordList[9];
				String companyName = (String)recordList[10];
				
				/*System.out.println(taskId +"\t"+ projectId + "\t" + projectName + "\t" + personId 
						+"\t" + impEmailUser + "\t" + impEmailPwd + "\t" + profileCode + "\t" + eventType + "\t" + companyName);*/
				
				String userName = URLEncoder.encode(encryptUtil.getEncryptedString(impEmailUser),"UTF8");
				String passName = URLEncoder.encode(encryptUtil.getEncryptedString(impEmailPwd),"UTF8");
				
				urlLinkBuf.append(serverLocation).append("ExternalMail/flexexternalmail.html?type=All%23ampuser=").append(userName).append("%23amppass=").append(passName).append("%23amptaskId=").append(taskId).append("%23ampprojId=").append(projectId);
				
				body.append(messageContent).append(serverLocation).append("ExternalMail/flexexternalmail.html?type=All%23ampuser=").append(userName).append("%23amppass=").append(passName).append("%23amptaskId=").append(taskId).append("%23ampprojId=").append(projectId).append(">Link -&gt;</a>").append(urlLinkBuf).append(postMessage);
				
				Message mailMessage = new Message();
				mailMessage.setSubject(projectName);
				mailMessage.setText(body.toString());
				mailMessage.setTo(personEmail);
				
				String error = null;
				if(!dispatchEmail.dispatch(mailMessage)) {
					error = dispatchEmail.getErrorDetails();
				}
				buildEvents(eventType, personId, taskId, projectId, personEmail, companyName, urlLinkBuf.toString(), workflowTemplateFk, error);

			}
			dispatchEmail.closeTransport();
			BuildConfig.dtPageDAO.bulkUpdate(eventsList);
		} catch (Exception e) {
			e.printStackTrace();
		}
	  }

	private void buildEvents(Integer eventType, Integer personId, Integer taskId,
			Integer projectId, String personEmail, String companyName, String url, Integer workflowTemplateFk, String error) {
		
		Events event = null;
		byte [] details = null;
		try {
			event = new Events();
			event.setEventDateStart(Calendar.getInstance().getTime());
			event.setEventType(eventType);
			event.setPersonFk(personId);
			event.setTaskFk(taskId);
			event.setProjectFk(projectId);
			if(error==null)
				details = (personEmail +"\n" + companyName + "\n" + url).getBytes();
			else
				details = (personEmail +"\n" + companyName + "\n" + url + "\n" +error).getBytes();
			event.setDetails(details);
			event.setEventName("Property Updation");
			event.setWorkflowtemplatesFk(workflowTemplateFk);
			
			eventsList.add(event);
		} finally {
			
		}
	}
}