<?php

include 'config.php';
include 'connect.php';

echo "<?xml version='1.0' ?>\n";
echo "<categories>"."\n";

$query = "SELECT code, label FROM categories ORDER BY code";
$result = mysql_query($query);

echo "  <category code='*' label='All Categories' />\n";

while( $row=mysql_fetch_array($result, MYSQL_ASSOC) )
{
	echo "  <category code=\"".$row['code']."\" label=\"".$row['label']."\">\n";
	echo "  </category>\n";
}

echo "</categories>";

mysql_close($conn);

?>