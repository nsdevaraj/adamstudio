<?php

include 'config.php';
include 'connect.php';

$linkLabel = "";
$linkURL = "";

if( isset($_GET['label']) ) $linkLabel = $_GET['label'];
if( isset($_GET['url']) ) $linkURL = $_GET['url'];

$query = "DELETE FROM links WHERE label = '$linkLabel' and url = '$linkURL'";
mysql_query($query);

$query = "FLUSH PRIVILEGES";
mysql_query($query);

echo "<?xml version='1.0' ?>\n";
echo "<deleteLink>\n";
echo "   <success>true</success>\n";
echo "</deleteLink>";

mysql_close($conn);