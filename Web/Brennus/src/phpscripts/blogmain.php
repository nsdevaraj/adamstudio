<?php

include 'config.php';
include 'connect.php';

echo "<?xml version='1.0' ?>\n";
echo "<articles>"."\n";

$query = "SELECT a.id, a.title, a.edit_dt as date, b.content from articles a, contents b where a.id = b.articleId";
$result = mysql_query($query);

while( $row=mysql_fetch_array($result, MYSQL_ASSOC) )
{
	echo "  <article id='".$row['id']."' title='".$row['title']."' date='".$row['date']."'>\n";
	echo "     <content><![CDATA[".$row['content']."]]></content>\n";
	echo "  </article>\n";
}

echo "</articles>";

mysql_close($conn);

?>