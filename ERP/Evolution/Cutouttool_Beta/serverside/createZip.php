<?php

$method = $_GET['method'];
$name = $_GET['name'];

if ( isset ( $GLOBALS["HTTP_RAW_POST_DATA"] )) {

	// get bytearray
	$zip = $GLOBALS["HTTP_RAW_POST_DATA"];

	// add headers for download dialog-box
	header('Content-Type: application/zip');
	header('Content-Length: '.strlen($zip));
	header('Content-disposition:'.$method.'; filename="'.$name.'"');
	echo $zip;

}  else echo 'An error occured.'+$GLOBALS["HTTP_RAW_POST_DATA"];

?>