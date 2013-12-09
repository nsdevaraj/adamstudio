package com.adams.pdf.util;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.channels.FileChannel;


import java.nio.ByteBuffer;

import java.util.ArrayList;
import java.util.List;

public class FileUtil {
   	 public void copyDirectory(String from, String to) {
   		System.out.print("\n copyDirectory from :"+from);
   		System.out.print("\n copyDirectory to :"+to);
   		
   		String targetPath = to.substring(0,to.lastIndexOf("/")+1);
   		System.out.print("\n copyDirectory targetPath :"+targetPath);
   		File targetLocation = new File(targetPath);	
   		System.out.print("\n copyDirectory targetLocation :"+targetLocation.getAbsolutePath()+" -- "+targetLocation.isDirectory());
        if (!targetLocation.exists()) {
        	System.out.print("\n copyDirectory targetLocation exists");
            targetLocation.mkdirs();
        }
   		
		 File sourceDir = new File(from);
		 File destDir = new File(to);		 
		 sourceDir.renameTo(destDir);
	}
   public String  doUpload(byte[] bytes, String fileName,String filePath) throws Exception
   {
	   try{
	       fileName = filePath + File.separator + fileName;
	       System.out.print(fileName);
	       File f = new File(fileName);
	       File dir = new File(f.getParent());
	       if(dir.exists()==false){
	    	   dir.mkdirs();
	       }
	       FileOutputStream fos = new FileOutputStream(f);
	       fos.write(bytes);
	       fos.close();
	       return "success";
	   } catch (Exception e){
	       return "failure";
	   }
   }
	public List<String> getDownloadList(String path)
   {
       File dir = new File(path);
       String[] children = dir.list();
       List<String> dirList = new ArrayList<String>();
       if (children == null) {
              // Either dir does not exist or is not a directory
          } else {
              for (int i=0; i<children.length; i++) {
                  // Get filename of file or directory
                  dirList.add( children[i]);
              }
          }
       return dirList;
   }
   public String doConvert(String filePath,String executable)
   {	   
	  String output = "";
	  if(BuildConfig.batchurl!=null){
		  System.out.print("\n doConvert BuildConfig.batchurl :"+BuildConfig.batchurl);
	   	  System.out.print("\n doConvert applicationContext :"+BuildConfig.applicationContext);
	   	  System.out.print("\n doConvert appContextConverter :"+BuildConfig.appContextConverter);
	  }
   	  try {
	   	  String command = executable+" "+filePath;
   		  //String command = BuildConfig.applicationContext+"/"+BuildConfig.batchurl+" "+filePath;   		  
   		  //String command = BuildConfig.appContextConverter+"\\"+BuildConfig.batchurl+" "+filePath;
   		  //String command = "Converter/pdf2swf.bat"+" "+filePath;
	   	  System.out.print("\n doConvert executable :"+executable);
	   	  System.out.print("\n doConvert filePath :"+filePath);
	      Process proc = Runtime.getRuntime().exec(command);
	      System.out.print("\n doConvert command :"+command);
	      BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream()));
		  String line = null;
		  while ((line = in.readLine()) != null) {
			  output+=line;
			  System.out.print("\n doConvert line :"+line+"\n");
		  }
	   }
	   catch (Exception e) {
	      e.printStackTrace();
	   }
	   return output;
   }
   public String createSubDir(String parentfolderName,String folderName)
   {
	   try {
		   String path = parentfolderName + File.separator + folderName;
	       File f = new File(path);
	       if(f.exists()==false){
	    	   f.mkdirs();
	    	   return folderName;
	       }
	    } catch (Exception e){
	   }
	    return folderName;
   }
   public byte[] doDownload(String fileName)
   {
       FileInputStream fis;
       byte[] data =null;
       FileChannel fc;
       try {
           fis = new FileInputStream(fileName);
           fc = fis.getChannel();
           data = new byte[(int)(fc.size())];
           ByteBuffer bb = ByteBuffer.wrap(data);
           fc.read(bb);
       } catch (FileNotFoundException e) {
           // TODO
       } catch (IOException e) {
           // TODO
       }
       return data;
   }
}