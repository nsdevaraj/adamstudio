<?php

include 'config.php';
include 'connect.php';

echo "<?xml version='1.0' ?>\n";
echo "<links>"."\n";

$query = "SELECT label, url FROM links ORDER BY label";
$result = mysql_query($query);

while( $row=mysql_fetch_array($result, MYSQL_ASSOC) )
{
	echo "  <link label=\"".$row['label']."\" url=\"".$row['url']."\">\n";
	echo "  </link>\n";
}

echo "</links>";

mysql_close($conn);

?>