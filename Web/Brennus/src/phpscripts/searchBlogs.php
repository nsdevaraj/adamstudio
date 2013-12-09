<?php

include 'config.php';
include 'connect.php';

$searchTerm = "";
if( isset($_GET['search']) ) $searchTerm = $_GET['search'];

echo "<?xml version='1.0' ?>\n";
echo "<articles>"."\n";

$query = "SELECT a.id, a.title, c.label as category, DATE_FORMAT(a.edit_dt,'%m/%d/%Y %k:%i:%s') as date, b.content, a.published";
$query = $query . " FROM articles a, contents b, categories c";
$query = $query . " WHERE a.id = b.articleId and a.category = c.code";
$query = $query . " and a.published = true";
$query = $query . " and a.category <> 0";
$query = $query . " and (a.title like '%$searchTerm%' or b.content like '%$searchTerm%')";
$query = $query . " ORDER BY a.edit_dt DESC";
$result = mysql_query($query);

while( $row=mysql_fetch_array($result, MYSQL_ASSOC) )
{
	echo "  <article id='".$row['id']."' title='".$row['title']."' category='".$row['category']."' date='".$row['date']."' published='".$row['published']."'>\n";
	echo "     <content><![CDATA[".$row['content']."]]></content>\n";
	echo "  </article>\n";
}

echo "</articles>";

mysql_close($conn);

?>