<?php

$swfs = $_GET['swfs'];

echo "SWFS = ".$swfs."<br>";

$swfList = explode(";",$swfs);
echo "SWFS count = ".count($swfList)."<br>";

foreach( $swfList as $item)
{
	echo $item."<br>";
	list($label,$url) = explode("//",$item);
	if( strlen($label) == 0 ) continue;
	echo "SWF label=$info[0]  url=$info[1]<br>";
}
?>