import java.applet.*;
import java.awt.*;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.ImageIcon;
import java.awt.BorderLayout;
import java.awt.Graphics;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Image;
import java.awt.Insets;
import java.awt.Container;
import java.awt.Color;
import java.awt.event.*;
import java.awt.dnd.*;
import java.awt.datatransfer.*;
import java.util.List;
import java.util.ArrayList;
import java.io.*;
import java.lang.reflect.Array;
import java.net.*;
import java.util.zip.*;
import netscape.javascript.*;

import java.security.*;

import java.lang.Exception;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.UnknownHostException;

/**
* This applet allows users to select files from their file system using drag
* and drop and upload them to a remote server.  All files will be zipped and
* sent to the server as a single file to improve upload performance.  This
* applet will use the HTTP protocol to communicate with the server.
*
*/
public class DNDApplet extends Applet implements DropTargetListener,Runnable
{
    private Image img;
    private String imgName;
    private String colorName;
	private int BufferSize = 1024;
	
	private ArrayList fileList = new ArrayList();    
    private JSObject window = null;  
    private Thread uploaderThread;
    private Thread threadObj = null;
    private String prefix ="";
    private String username = "username";
    private String password = "password";    
    private String metadata = "metadata";
  
   //private ArrayList m_fileList = new ArrayList();

   public void init()
   {
	   img = null;
	   
	   try
	   {
		   window = JSObject.getWindow(this);
	   }
	   catch ( JSException e1 )
	   {
		   System.out.println("Cannot get a reference to the container window:" + e1.getMessage() );
	   }    
	   
	   imgName = getParameter("ImagePath");
	   colorName = getParameter("ColorName");

       setLayout(new BorderLayout());
       Container main = new Container();

       add(main, BorderLayout.CENTER);
	   //this.setBackground(new Color(143, 165, 176));

	   Color col = parseColorStr(colorName);
	   this.setBackground(col);

       GridBagLayout gbl = new GridBagLayout();
       main.setLayout(gbl);
       //main.setBackground(new Color(143, 165, 176));

       GridBagConstraints gbc = new GridBagConstraints();
       gbc.anchor = GridBagConstraints.NORTHWEST;
       gbc.fill = GridBagConstraints.BOTH;
       gbc.weighty = 0.1;
       gbc.weightx = 0.00001;
       gbc.gridy = 0;
       gbc.gridx = 0;
       gbc.gridheight = 1;
       gbc.gridwidth = 1;
       gbc.insets = new Insets(1, 0, 1, 1);

       JLabel title = new JLabel();
       title.setVerticalAlignment(SwingConstants.CENTER);
       title.setHorizontalAlignment(SwingConstants.CENTER);
       DropTarget dt2 = new DropTarget(title, this);
       //title.setBorder(new LineBorder(Color.black));
       title.setOpaque(false);

       main.add(title);
  	   gbl.setConstraints(title, gbc);

   }
   public void paint(Graphics g)
   {
	  if (img == null)
		 loadImage();
	  g.drawImage(img, this.getX(), this.getY(),this.getWidth(), this.getHeight(),this);
   }
   private void loadImage()
   {
      try
      {
          img = getImage(getDocumentBase(), imgName);
      }
      catch(Exception e) { }
   }
	public static Color getColor(String arg0)
	{
		if (arg0.startsWith("#")) {
			String digits = arg0.substring(1, Math.min(arg0.length(), 7));
			String hstr = "0x" + digits;
			Color c = Color.decode(hstr);

			return c;
		}
		return(Color.white);
	}
	private Color parseColorStr(String s)
	{
		int r, g, b;

		// Convert a string in the standard HTML "#RRBBGG" format to a valid
		// color value, if possible.

		if (s.length() == 7 && s.charAt(0) == '#') {
		try {
		r = Integer.parseInt(s.substring(1,3),16);
		g = Integer.parseInt(s.substring(3,5),16);
		b = Integer.parseInt(s.substring(5,7),16);
		return(new Color(r, g, b));
		}
		catch (Exception e) {}
		}

		// Otherwise, default to white.

		return(Color.white);
	}

   /** Returns an ImageIcon, or null if the path was invalid. */
   protected static ImageIcon createImageIcon(String path,
                                              String description) {
       java.net.URL imgURL = DNDApplet.class.getResource(path);
       if (imgURL != null) {
           return new ImageIcon(imgURL, description);
       } else {
           System.err.println("Couldn't find file: " + path);
           return null;
       }
   }
   
   public void dragExit(DropTargetEvent dte)
   {}

   public void dragEnter(DropTargetDragEvent dtde)
   {}

   public void dragOver(DropTargetDragEvent dtde)
   {}

   public void dropActionChanged(DropTargetDragEvent dtde)
   {}

   /**
    * This method will be called when the user drops a file on our target label.
    *
    * @param dtde
    */
   public void drop(DropTargetDropEvent dtde)
   {
       int action = dtde.getDropAction();

       /*
        * We have to tell Java that we are going to accept this drop before
        * we try to access any of the data.
        */
       dtde.acceptDrop(action);

       fromTransferable(dtde.getTransferable());

       /*
        * Once the drop event is complete we need to notify Java again so it
        * can reset the cursor and finish showing the drop behavior.
        */
       dtde.dropComplete(true);
   }

   /**
    * This is a helper method to get the data from the drop event.
    *
    * @param t
    */
   private void fromTransferable(Transferable t)
   {
       if (t == null)
           return;

       /*
        * The user may have dropped a file or anything else from any application
        * running on their computer.  This interaction is handled with data flavors.
        * For example, text copied from OpenOffice might have one flavor which
        * contains the text with formatting information and another flavor which
        * contains the text without any of this information.  We need to look for
        * the data flavor we know how to support and read the list of files from it.
        */
       try {
           DataFlavor flavors[] = t.getTransferDataFlavors();
           if (t.isDataFlavorSupported(DataFlavor.javaFileListFlavor)) {
               /*
                * We are looking for the list of files data flavor.  This will be a
                * list of the paths to the files the user dragged and dropped on to
                * our application.
                */
               List list = (List) t.getTransferData(DataFlavor.javaFileListFlavor);
               ArrayList m_fileList = new ArrayList();
               m_fileList.addAll(list);
               fileList.addAll(list);

               int filesize;
               int count = 0;
               FileInputStream in = null;
               File f = null;
               String sendvalue = null;
			   String convertDetails="";
               for (int i = 0; i < m_fileList.size(); i++)
               {
                    f = (File) m_fileList.get(i);

					URL js;
					try
					{
						in = new FileInputStream(f);
						filesize = in.available();

	                   if(filesize < 1024) // code to format fsize as bytes
	                   {
							count = filesize;
							convertDetails = "Byte(s)";
						}
						else if((filesize > 1024) && (filesize < 1048576)) // code to format fsize as KB
						{
							count = filesize/BufferSize;
							convertDetails = "KB";
						}
						else if(filesize > 1048576)	// code to format fsize as MB
						{
							count = filesize/(BufferSize*BufferSize);
							convertDetails = "MB";
						}
						Integer dou = new Integer(count);

						/*if(sendvalue==null)
							sendvalue = f.getAbsolutePath() +":::"+dou.toString()+""+convertDetails;
						else
							sendvalue += "**"+f.getAbsolutePath() +":::"+dou.toString()+""+convertDetails;*/
																								
						if(sendvalue==null)
							sendvalue = f.getAbsolutePath() +":::"+dou.toString()+""+convertDetails+":*:"+"uploadsTemp";
						else
							sendvalue += "**"+f.getAbsolutePath() +":::"+dou.toString()+""+convertDetails+":*:"+"uploadsTemp";
												
					}
					catch (MalformedURLException me) { }
               }
              	sendvalue = sendvalue.replace("://",":\\");
              	sendvalue = sendvalue.replace("\\","\\\\");
                //System.out.println(sendvalue);
               try
				{
            	   getAppletContext().showDocument(new URL("javascript:FileNameDetails(\"" + sendvalue+"\")"));
				}
				catch (MalformedURLException me) { }
				//resetInput();
				
				threadObj = new Thread(this);
				threadObj.start();
				try
				{
					threadObj.join();
				}catch(Exception Ex){
				}
				
				//uploadFiles();
           }
           else {
               /*
                * There is a very large number of other data flavors the user can
                * drop onto our applet.  we will just show the information from
                * those types, but we can't get a list of files to upload from
                * them.
                */
               DataFlavor df = DataFlavor.selectBestTextFlavor(flavors);

               JOptionPane.showMessageDialog(this, "df: " + df);

               JOptionPane.showMessageDialog(this, "t.getTransferData(df): " + t.getTransferData(df));
           }
       } catch (Exception ex) {
           ex.printStackTrace();
       }
   }
   public void run()
   {
	   uploadFiles();
   }
   public void uploadFiles()
   {
	   /*
	       * we start a new thread for the loop
	       */
	      uploaderThread = new Thread( new Runnable()
	      {
	        public void run()
	        {
         	          
	          String url = getDocumentBase().toString();
	          String uploadPath = ( getParameter("uploadPath") != null ? getParameter("uploadPath") : "appletupload.php" ); 
	          url = url.substring(0, url.lastIndexOf("/"));
	          
	          //url = url.substring(0,5).compareTo("file:") == 0 ? "http://localhost" : url.substring(0, url.lastIndexOf("/"));
	          url = url + "/" + uploadPath;
	          	          
	          /*
	           * http connection 
	           */
	          HttpURLConnection.setFollowRedirects(false);
	          HttpURLConnection conn = null;
	                    
	          /*
	           * Authentication hash
	           */
	          String authHash = null;
	          if ( username != null && password != null )
	          {
	              String s = username + ":" + password;                
	              authHash = new sun.misc.BASE64Encoder().encode(s.getBytes());   
	          }
	              
	          /* for each file, make an upload request
	           * 
	           */
	          for (int i = 0; i < fileList.size(); i++ ) 
	          {
	            /*
	             * check for interrupt
	             */
	            if ( Thread.currentThread().isInterrupted() )
	            {
	              continue;
	            }
	           
	            File f = (File) fileList.get(i);  
	            String fileName = prefix + f.getName();
	            
	            try 
	            {  
	              conn = (HttpURLConnection) new URL(url).openConnection();	              
	              if ( authHash != null )
	              {
	                conn.setDoInput( true );
	                conn.setRequestProperty( "Authorization", "Basic " + authHash );
	                conn.connect();
	                conn.disconnect();
	              }	                 
	              conn.setRequestMethod("POST");
	              String boundary = "boundary220394209402349823";	              
	              String tail    = "\r\n--" + boundary + "--\r\n"; 
	              conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary );
	              
	              conn.setDoOutput(true);

	              String metadataPart = "--" + boundary + "\r\n"
	                + "Content-Disposition: form-data; name=\"metadata\"\r\n\r\n"
	                + metadata + "\r\n";          
	             	              
	              String fileHeader1 = "--" + boundary + "\r\n"
	                + "Content-Disposition: form-data; name=\"uploadfile\"; filename=\"" + fileName + "\"\r\n"
	                + "Content-Type: application/octet-stream\r\n"
	                + "Content-Transfer-Encoding: binary\r\n";              
	              
	              long   fileLength  = f.length() + tail.length();                          
	              String fileHeader2 = "Content-length: " + fileLength + "\r\n";
	              String fileHeader  = fileHeader1 + fileHeader2 + "\r\n";   
	              
	              String stringData = metadataPart + fileHeader;
	             
	              long requestLength = stringData.length() + fileLength ;
	              conn.setRequestProperty("Content-length", "" + requestLength );

	              conn.setFixedLengthStreamingMode((int) requestLength );
	              
	              conn.connect();  
	               
	              DataOutputStream out = new DataOutputStream( conn.getOutputStream() );
	              
	              out.writeBytes(stringData);                            
	              out.flush();
	                            
	              int progress = 0;
	              int bytesRead = 0;
	              byte b[] = new byte[1024];
	              BufferedInputStream bufin = new BufferedInputStream(new FileInputStream(f));
	              while ((bytesRead = bufin.read(b)) != -1) 
	              {
	                if ( Thread.currentThread().isInterrupted() )
	                {	                  
	                }
	               
	                out.write(b, 0, bytesRead); 
	                out.flush();
	                progress += bytesRead;
	               
	                final int p = progress;
	                SwingUtilities.invokeLater( new Runnable(){
	                  public void run()
	                  {
	                    //progressBar.setValue(p);
	                    //progressBar.revalidate();
	                  }
	                });   

	              }
	              
	              out.writeBytes(tail);
	              out.flush();
	              out.close();
	              	              
	              BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	              String line;
	              while ((line = rd.readLine()) != null) 
	              {
	                final String l = line;
	                SwingUtilities.invokeLater( new Runnable(){
	                  public void run()
	                  {
	                  }
	                });
	              }
	                
	              try 
	              {
	                /*
	                 * If we got a 401 (unauthorized), we can't get that data. We will
	                 * get an IOException. This makes no sense since a 401 does not
	                 * consitute an IOException, it just says we need to provide the
	                 * username again.
	                 */
	                int responseCode        = conn.getResponseCode();
	                String responseMessage  = conn.getResponseMessage();
	              } 
	              catch (IOException ioe) 
	              {
	                  System.out.println(ioe.getMessage());
	              }	      
	            } 
	            catch (Exception e) 
	            {	              
	              e.printStackTrace();
	            } 
	            finally 
	            {	              
	              if (conn != null) conn.disconnect();
	            }
	            
	            /*
	             * call JavaScript function to indicate current upload
	             */
	            String funcName2 = getParameter("funcNameHandleCurrentUpload");
	            if ( funcName2 != null && window != null )
	            {
	            	String currentFileName = f.getName()+"::Done";
	            	try
	            	{
	            		window.call(funcName2, new Object[] { currentFileName } );
	            	}
	            	catch( JSException e3 )
	            	{
	            		System.out.println(e3.getMessage());
	            	}
	            }	
	          }	  
	          fileList.clear();  
	          String boolValue = "Upload finished";
	          try
				{
	        	  getAppletContext().showDocument(new URL("javascript:ConfirmationUpload(\"" + boolValue+"\")"));
				}
				catch (MalformedURLException me) { }
	        }
	      } );
	      
	      uploaderThread.start();
   }   
      
}
