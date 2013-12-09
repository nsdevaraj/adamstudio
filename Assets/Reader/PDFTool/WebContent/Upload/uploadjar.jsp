<%@ page import="org.apache.commons.fileupload.*,

org.apache.commons.fileupload.servlet.ServletFileUpload,

org.apache.commons.fileupload.disk.DiskFileItemFactory,

org.apache.commons.io.FilenameUtils,

java.util.*,

java.io.File,

java.lang.Exception,

java.io.*,

java.net.*,

org.apache.poi.hssf.usermodel.*" %>

<h1>Data Received at the Server</h1>

<hr />

<strong>Uploaded File[s] Info:</strong>

<%

String optionalFileName = "";

FileItem fileItem = null;

String[] files = new String[2]; // file names

String dirName = "D:/Program Files/Tomcat 5.5/webapps/comp-tool/uploads/"; // upload directory path

int i=0;

if (ServletFileUpload.isMultipartContent(request)) {

ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());

List fileItemsList = servletFileUpload.parseRequest(request);

Iterator it = fileItemsList.iterator();

while (it.hasNext()) {

FileItem fileItemTemp = (FileItem)it.next();

if (fileItemTemp.isFormField()) {

%>

<strong>Name-value Pair Info:</strong>

Field name: <%= fileItemTemp.getFieldName() %>

Field value: <%= fileItemTemp.getString() %>

<%

if (fileItemTemp.getFieldName().equals("filename"))

optionalFileName = fileItemTemp.getString();

}

else

fileItem = fileItemTemp;

if (fileItem!=null) {

String fileName = fileItem.getName();

%>

<!- Content type: <%= fileItem.getContentType() %> Field name: <%= fileItem.getFieldName() %> ->

File name: <font color="blue"> <%= fileName %></font>

File size: <font color="blue"> <%= fileItem.getSize() %> Bytes</font>

<%

/* Save the uploaded file if its size is greater than 0. */

if (fileItem.getSize() > 0 && fileItem.getSize() < 4000000) {

if (optionalFileName.trim().equals(""))

fileName = FilenameUtils.getName(fileName);

else

fileName = optionalFileName;

// added by Pavan recently

files[i++] = dirName + fileName;

File saveTo = new File(dirName + fileName);

try {

fileItem.write(saveTo);

%>

Upload Status: <font color="blue">Uploaded successfully</font>

<%

} catch (Exception e){

%>

Error: <font color="red">An error occurred while saving the uploaded file.</font>

<%=e%>

<%

}

}

else {

%>

Error: <font color="red">File size exceeds 4MB or below 0 Bytes.</font>

<%

return;

}

}

}

}

%>