<?php 
include("zip.php"); 
$ziper = new zipfile(); 
$ziper->addFiles(array("sathish","251220081742.jpg","261220081767.jpg"));  //array of files 
$ziper->output("zipFile.zip");
?>