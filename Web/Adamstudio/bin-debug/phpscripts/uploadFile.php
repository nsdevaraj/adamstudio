<?php

/*
	uploadFile.php
	
	This is a very simplistic file uploader. It doesn't care what you upload,
	and it doesn't care how big it is. 
 */
$target_path = $_SERVER['DOCUMENT_ROOT']."/blog/uploads/";

$target_path = $target_path . basename( $_FILES['Filedata']['name'] );
if( move_uploaded_file($_FILES['Filedata']['tmp_name'], $target_path) )
{
	echo "<?xml version='1.0' ?>\n";
	echo "<fileUpload>\n";
	echo "	 <success>true</success>\n";
	echo "   <file>".$target_path."</file>\n";
	echo "</fileUpload>";
}
else {
	echo "<?xml version='1.0' ?>\n";
	echo "<fileUpload>\n";
	echo "	 <success>false</success>\n";
	echo "   <file>".$target_path."</file>\n";
	echo "</fileUpload>";
}

?>