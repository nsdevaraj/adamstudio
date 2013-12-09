<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.io.File" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="com.adams.pdf.pojo.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
	<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="com.adams.pdf.dao.hibernate.DTPageDAO"%>
<%@page import="org.springframework.orm.hibernate3.HibernateTemplate"%>
<%@page import="org.springframework.orm.hibernate3.support.HibernateDaoSupport"%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>	
		<%!
			public DTPageDAO dtPageDao = null;	
			public DTPageDAO getDtPageDao() {
				System.out.println("getDtPageDao getDtPageDao :"+dtPageDao);
				return dtPageDao;
			}
			public void setDtPageDao(DTPageDAO dtPageDao) {
				this.dtPageDao = dtPageDao;
				System.out.println("setDtPageDao setDtPageDao :"+dtPageDao);
			}
			public FileDetails makeFileValueObjects(String fileName,String filePath) throws Exception {
				System.out.println("makeFileValueObjects fileName :"+fileName+" , filePath :"+filePath);
				FileDetails fileObj = new FileDetails();
				//String[] fileNameParts = fileName.split(".");		        
				//String extFilename = fileNameParts[0];		        
				//String extension = fileNameParts[1];
				
				String extFilename = fileName.substring(0, fileName.lastIndexOf("."));
				//String extension = fileName.substring(fileName.lastIndexOf("."),fileName.length()-1);
				String extension = fileName.substring(fileName.lastIndexOf(".")+1,fileName.length());
				System.out.println("makeFileValueObjects extFilename :"+extFilename);
				System.out.println("makeFileValueObjects extension :"+extension);
				
				Date d = new Date();
				String datemiscellenous = ""+d.getDate()+d.getDay()+d.getMonth()+d.getYear()+d.getHours()+d.getMinutes()+d.getSeconds();
				String extensionlessFilename = extFilename+datemiscellenous;
				String storeFileName = extensionlessFilename+"."+extension;
				//fileObj.setFileId()
				fileObj.setFileName(fileName);
				fileObj.setFilePath(filePath);			   
				fileObj.setFileDate(new Date());
				fileObj.setType("Basic");
				fileObj.setStoredFileName(storeFileName); //Test0017373983201118120890.pdf
				fileObj.setReleaseStatus(1); // 1
				fileObj.setVisible(true); //pdf-->>true/1 or other swf -->false/0
				fileObj.setMiscelleneous(datemiscellenous); //1302266522234
				fileObj.setFileCategory(null); //null
				fileObj.setPage(0); //pdf-->>0 swf-->1
				
				System.out.println("makeFileValueObjects fileObj");
			   	return fileObj;
			}
		%>	
		<%
			
			//DTPageDAO dtPageDao = null;
			//List<FileDetails> tempFileDetailsList = new ArrayList<FileDetails>();
			List<FileDetails> tempFileDetailsList = null;
			tempFileDetailsList = new ArrayList<FileDetails>();
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		 	if (!isMultipart) {
		 	} 
		 	else {
			   FileItemFactory factory = new DiskFileItemFactory();
			   ServletFileUpload upload = new ServletFileUpload(factory);
			   List items = null;
			   try {
					items = upload.parseRequest(request);
			   } catch (FileUploadException e) {
				e.printStackTrace();
			   }
			   
			   Iterator itr = items.iterator();
			   while (itr.hasNext()) {
			   		FileItem item = (FileItem) itr.next();
			   if (item.isFormField()) {
			   } 
			   else {
				   try {					   
					   String itemName = item.getName();
					   //File savedFile = new File(config.getServletContext().getRealPath("/")+"Files/"+itemName);
					   File savedFile = new File("c://temp/jsp/"+itemName);
					   item.write(savedFile);
					   
					   FileDetails fileObjs = makeFileValueObjects(itemName, savedFile.getAbsolutePath());
					   System.out.println("FileDetails fileObj ----------:"+fileObjs.getFilePath());
					   tempFileDetailsList.add(fileObjs);
					   System.out.println("FileDetails fileObj after----------:"+fileObjs.getFilePath());
					   
				   } catch (Exception e) {
					   e.printStackTrace();
				   }
			   	}
			   }
   			}		 	
		 	dtPageDao = new DTPageDAO();
		 	System.out.println("dtPageDao----------:"+dtPageDao);
		 	System.out.println("dtPageDao-tempFileDetailsList-size--------:"+tempFileDetailsList.size());
		 	
		 	try {
		 		List<Persons> perList = (List<Persons>)dtPageDao.getPersonListResult();
			 	System.out.println("dtPageDao-getPersonListResult------"+perList.size());
		   	} catch (Exception e) {		
		   		System.out.println("getPersonListResult Exception---------:"+e.getMessage());
				e.printStackTrace();
		   	}	
		 	
		 	
		 	try {
		 		dtPageDao.bulkUpdate(tempFileDetailsList);
			 	System.out.println("dtPageDao-bulkUpdate--final-------");

		   	} catch (Exception e) {		
		   		System.out.println("bulkUpdate Exception---------:"+e.getMessage());
				e.printStackTrace();
		   	}	 	
		 			 	
			String TimeServer=request.getRemoteAddr();
			String SessionId=session.getId();
		%>
		<title>PDFTool Jsp Page</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<style type="text/css" media="screen">
			body { margin:0; text-align:center; }
				div#content { text-align:left; }
				object#content { display:inline; }
		</style>	
		<script type="text/javascript" src="swfobject.js"></script>
		<script type="text/javascript">
			var flashvars = {
				htmlURL: document.location.toString(),
				FileServer: "C://temp/",
				autoTimerInterval: "05",
				TimeServer:'<%= TimeServer %>',
				SessionId:'<%= SessionId %>'
			};
			var params = {
				menu: "false",
				wmode: "transparent"
			};
			var attributes = {
				id: "myId",
				name: "myId"
			};
			swfobject.embedSWF("PDFTool.swf", "myContent","100%", "100%", "10.3.0", "expressInstall.swf", flashvars, params, attributes);
		</script>
	</head>
	<body style="background-color:#000;" TOPMARGIN=0 LEFTMARGIN=0 MARGINHEIGHT=0 MARGINWIDTH=0>
		<div id="myContent">
			<h1>Alternative content</h1>
			<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p>
		</div>
	</body>
</html>