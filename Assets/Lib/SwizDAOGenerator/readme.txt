
Lightweight Ant script extensions generator for SwizDAO implementation of MVCs by @EladElrom

Features:

1. SwizDAO Folder structure.
2. SwizDAO libraries and source code 
3. SwizDAO MainClass and files    
4. Creating VO. 
5. Create view and mediator combo 

In case you are running into errors:
You need to ensure you copy the following plugins:
Copy to [eclipsedirectory]/plugins

    * BSF  http://jakarta.apache.org/site/downloads/downloads_bsf.cgi
    * Rhino  http://www.mozilla.org/rhino/download.html

After you add the jars you will need to do the following step:

Flash Builder>Preferences>Ant>Runtime>Classpath,
�Ant Home Entries� > �Add External JARs�  point to jar files for:

    * bsf
    * rhino
    * org.apache.commons.logging._[ver].jar (which should already be in your Eclipse plugins directory)

Otherwise you will get the errors when trying to run an Ant task, such as the one below:
/Users/501706853/Documents/workspace/tools/�/build.xml:245: Unable to load a script engine manager (org.apache.bsf.BSFManager or javax.script.ScriptEngineManage
