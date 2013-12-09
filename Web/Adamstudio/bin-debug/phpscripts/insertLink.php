<?php

include 'config.php';
include 'connect.php';

$linkLabel = "";
$linkURL = "";

if( isset($_GET['label']) ) $linkLabel = $_GET['label'];
if( isset($_GET['url']) ) $linkURL = $_GET['url'];

$query = "INSERT INTO links (label,url) VALUES ('$linkLabel','$linkURL')";
mysql_query($query);

$query = "FLUSH PRIVILEGES";
mysql_query($query);

echo "<?xml version='1.0' ?>\n";
echo "<newLink>\n";
echo "   <success>true</success>\n";
echo "</newLink>";

mysql_close($conn);

?>