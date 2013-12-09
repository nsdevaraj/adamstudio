<?php

include 'config.php';
include 'connect.php';

echo "<?xml version='1.0' ?>\n";
echo "<news>"."\n";

$query = "select a.id, a.title, DATE_FORMAT(a.edit_dt,'%m/%d/%Y %k:%i:%s') as date, a.published, b.content";
$query = $query . " from articles a, contents b";
$query = $query . " WHERE a.id = b.articleId and a.category = 0 and a.published = true";
$query = $query . " ORDER BY a.edit_dt DESC";
$result = mysql_query($query);

while( $row=mysql_fetch_array($result, MYSQL_ASSOC) )
{
	echo "  <blurb id='".$row['id']."' title='".$row['title']."' date='".$row['date']."' published='".$row['published']."'>\n";
	echo "     <content><![CDATA[".$row['content']."]]></content>\n";
	echo "  </blurb>\n";
}

echo "</news>";

mysql_close($conn);

?>