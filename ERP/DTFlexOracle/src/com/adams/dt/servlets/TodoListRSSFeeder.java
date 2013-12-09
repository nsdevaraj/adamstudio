package com.adams.dt.servlets;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import com.adams.dt.dao.hibernate.DTPageDAO;
import com.adams.dt.pojo.Persons;
import com.adams.dt.util.BuildConfig;
import com.adams.dt.util.EncryptUtil;
import com.sun.syndication.feed.synd.SyndContent;
import com.sun.syndication.feed.synd.SyndContentImpl;
import com.sun.syndication.feed.synd.SyndEntry;
import com.sun.syndication.feed.synd.SyndEntryImpl;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.feed.synd.SyndFeedImpl;
import com.sun.syndication.io.FeedException;
import com.sun.syndication.io.SyndFeedOutput;

public class TodoListRSSFeeder extends HttpServlet {
	private DTPageDAO dao = null;
	private SyndFeed feed = null;
	private String feedType = "rss_2.0";
	private String fileName = "totdolist.xml";
	private List entries = null;
	private static final String CONTENT_TYPE = "application/rss+xml";
	private EncryptUtil encryptUtil = null;
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		ServletContext context = getServletContext();
		WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
		dao = (DTPageDAO) applicationContext.getBean("pagingDAO");
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException { 
		System.out.println("TodoListRSSFeeder called.");
		System.out.println("***************************");
		encryptUtil = new EncryptUtil();
		//    user arnaud encrypted string : VF5+cdN88xoRd5ZNmAeGnA==
		//password ctpmb  encrypted string : v2VxC1Isc1Vh74PU4PieDQ==
		String enUsername = request.getParameter("eun")!=null?request.getParameter("eun"):"";
		String enPassword = request.getParameter("eps")!=null?request.getParameter("eps"):"";
		
		System.out.println("enUsername:"+enUsername);
		System.out.println("enUsername:"+enPassword);
		int userId = 0;
		try {
			userId = getUserId(encryptUtil.getDecryptedString(enUsername), encryptUtil.getDecryptedString(enPassword));
			System.out.println("User Id:"+userId);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		feed = new SyndFeedImpl();
		entries = new ArrayList();
		createTodoListFeed(userId);
		feed.setEntries(entries);
		
		SyndFeedOutput output = new SyndFeedOutput();
		try {
		    response.setContentType(CONTENT_TYPE);
		    PrintWriter out = response.getWriter();
			output.output(feed,out);
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (FeedException e) {
			e.printStackTrace();
		} 
	}

	
	private int getUserId(String username, String password) {
		int userId = 0;
		List<?> userList;
		try {
			System.out.println("Username:"+username);
			System.out.println("Password:"+password);
			userList = dao.paginationListViewStr("Persons.findByName", username, 0, 1);
			if(userList.size()>0) {
				Persons person = (Persons)userList.get(0);
				if(person.getPersonPassword().equals(password)) {
					userId = person.getPersonId();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return userId;
	}

	private void createTodoListFeed(int userId) {
		/*feed.setFeedType(feedType);
		feed.setTitle("DTFlex - Todo List");
		feed.setLink("http://"+BuildConfig.serverAddress+":"+BuildConfig.serverPort+"/DTFlex");
		feed.setDescription("DTFlex - Todo List");*/
		
		feed.setFeedType(feedType);
		feed.setTitle(BuildConfig.rssRootContext+" - Todo List");
		feed.setLink("http://"+BuildConfig.serverAddress+":"+BuildConfig.serverPort+"/"+BuildConfig.rssRootContext);
		feed.setDescription(BuildConfig.rssRootContext+" - Todo List");
		
		try {
			if(userId>0)
				getEntries(dao.paginationListViewId("Tasks.findRssListById", userId, 0, 100) );
			else 
				assignInvalidUserEntry();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void assignInvalidUserEntry() {
		String descriptionStr;
		SyndEntry entry;
		SyndContent description;
		try {
			entry = new SyndEntryImpl();
			description = new SyndContentImpl();
			descriptionStr = "The URL is not Authenticated. Please verify your URL or contact "+BuildConfig.rssRootContext;
			entry.setTitle("Invalid User!");
			//entry.setLink("http://"+BuildConfig.serverAddress+":"+BuildConfig.serverPort+"/DTFlex");
			entry.setLink("http://"+BuildConfig.serverAddress+":"+BuildConfig.serverPort+"/"+BuildConfig.rssRootContext);
			entry.setPublishedDate(Calendar.getInstance().getTime());
			description.setType("text/html");
			description.setValue(descriptionStr);
			entry.setDescription(description);
			entries.add(entry);
		} finally {
			
		}
	}
	
	private void getEntries(List<?> todolist) {
		System.out.println("todoList:"+todolist.size());
		for(Object obj: todolist) {
			Object[] objs = (Object[])obj;
			assignTaskEntry(objs);
		}		
	}

	private void assignTaskEntry(Object[] objs) {
		String descriptionStr;
		SyndEntry entry;
		SyndContent description;
		try {
			entry = new SyndEntryImpl();
			description = new SyndContentImpl();
			descriptionStr = "";
			Blob comment = (Blob)objs[1];
			if(comment!=null) {
				descriptionStr = new String(toByteArray(comment));
				if(descriptionStr.contains("&#$%^!@")) {
					descriptionStr = descriptionStr.replace("&#$%^!@","#_6#6#6_#");
					descriptionStr = descriptionStr.split("#_6#6#6_#")[2];
				}
			}
			descriptionStr = descriptionStr.replace("\n", "<br>");
			entry.setTitle((String)objs[0]);
			//entry.setLink("http://"+BuildConfig.serverAddress+":"+BuildConfig.serverPort+"/DTFlex");
			entry.setLink("http://"+BuildConfig.serverAddress+":"+BuildConfig.serverPort+"/"+BuildConfig.rssRootContext);
			entry.setPublishedDate((Date)objs[2]);
			description.setType("text/html");
			if(descriptionStr.trim().equals("")) {
				descriptionStr = "-";
			}
			descriptionStr = "<div style='background-color:#efefef; padding:10px; border:solid 1px #aeaeae;'>"+descriptionStr+"</div>";
			description.setValue(descriptionStr);
			entry.setDescription(description);
			entries.add(entry);
		} finally {
			
		}
	}
	
	private byte[] toByteArray(Blob fromBlob) {
		 ByteArrayOutputStream baos = new ByteArrayOutputStream();
		 try {
			 return toByteArrayImpl(fromBlob, baos);
		 } catch (SQLException e) {
			 throw new RuntimeException(e);
		 } catch (IOException e) {
			 throw new RuntimeException(e);
		 } finally {
			 if (baos != null) {
				 try {
					 baos.close();
				 } catch (IOException ex) {
				 }
		 	}
		 }
	}
	
	private byte[] toByteArrayImpl(Blob fromBlob, ByteArrayOutputStream baos) throws SQLException, IOException {
		  byte[] buf = new byte[4000];
		  InputStream is = fromBlob.getBinaryStream();
		  try {
			  for (;;) {
				  int dataSize = is.read(buf);

				  if (dataSize == -1)
					  break;
				  baos.write(buf, 0, dataSize);
			  }
		  	} finally {
		  		if (is != null) {
		  			try {
		  				is.close();
		  			} catch (IOException ex) {
		  			}
		  		}
		  	}
		  	return baos.toByteArray();
		}
}
