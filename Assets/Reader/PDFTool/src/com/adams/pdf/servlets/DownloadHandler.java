package com.adams.pdf.servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DownloadHandler
 */
public class DownloadHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;


    public DownloadHandler() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("DownloadHandler called.");
		System.out.println("***************************");

		String enUsername = request.getParameter("eun");//!=null?request.getParameter("eun"):"";
		String enPassword = request.getParameter("eps");//!=null?request.getParameter("eps"):"";

		System.out.println("DownloadHandler enUsername:"+enUsername);
		System.out.println("DownloadHandler enUsername:"+enPassword);
		int userId = 0;
		try {
			ServletOutputStream output = response.getOutputStream();
			//userId = getUserId(encryptUtil.getDecryptedString(enUsername), encryptUtil.getDecryptedString(enPassword));
			System.out.println("User Id:"+userId);

			String fileName = request.getParameter("saveFilePath");
			if(fileName == null) return;

			File fname = new File(fileName);
			String saveFileName = fname.getName().toString();
			System.out.println("Save As: "+fname.getName() );
			if(!fname.exists())	return;
			FileInputStream istr = null;
			response.setContentType("application/binary;charset=ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + saveFileName + "\";");
			try {
				istr = new FileInputStream(fname);
				int curByte=-1;
				while( (curByte=istr.read()) !=-1){
					output.write(curByte);
				}
				output.flush();
			} catch(Exception ex){
				ex.printStackTrace(System.out);
			} finally{
				try {
					if(istr!=null) istr.close();
				} catch(Exception ex){
					System.out.println("Major Error Releasing Streams: "+ex.toString());
				}
			}
			try {
				response.flushBuffer();
			} catch(Exception ex){
				System.out.println("Error flushing the Response: "+ex.toString());
			}

		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}

}
