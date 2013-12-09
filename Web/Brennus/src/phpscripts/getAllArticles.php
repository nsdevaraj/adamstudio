<?php

include 'config.php';
include 'connect.php';

$published = "dk";
$excludeNews = false;
$month = "";
$day = "";
$year = "";
$category = "";

if( isset($_GET['published']) ) $published = $_GET['published'];
if( isset($_GET['excludeNews']) ) $excludeNews = $_GET['excludeNews'] == "true";
if( isset($_GET['month']) ) $month = $_GET['month'];
if( isset($_GET['day']) ) $day = $_GET['day'];
if( isset($_GET['year']) ) $year = $_GET['year'];
if( isset($_GET['category']) ) $category = $_GET['category'];

echo "<?xml version='1.0' ?>\n";
echo "<articles>"."\n";

$query = "SELECT a.id, a.title, c.label as category, c.code, DATE_FORMAT(a.edit_dt,'%m/%d/%Y %k:%i:%s') as date, b.content, a.published";
$query = $query . " FROM articles a, contents b, categories c";
$query = $query . " WHERE a.id = b.articleId and a.category = c.code";
if( $published != "dk" ) $query = $query . " and a.published = true";
if( $excludeNews ) $query = $query . " and a.category <> 0";
if( $month != "" ) $query = $query . " and MONTH(edit_dt)=$month and DAY(edit_dt)=$day and YEAR(edit_dt)=$year";
if( $category != "" ) $query = $query . " and c.code = $category";
$query = $query . " ORDER BY a.edit_dt DESC";
$result = mysql_query($query);

while( $row=mysql_fetch_array($result, MYSQL_ASSOC) )
{
	echo "  <article id='".$row['id']."' title='".str_replace("<","&lt;",str_replace(">","&gt;",str_replace("&","&amp;",$row['title'])))."' category='".$row['category']."' categoryCode='".$row['code']."' date='".$row['date']."' published='".$row['published']."'>\n";
	echo "     <content><![CDATA[".str_replace("<","&lt;",str_replace(">","&gt;",str_replace("&","&amp;",$row['content'])))."]]></content>\n";
	echo "  </article>\n";
}

echo "</articles>";

mysql_free_result($result);

mysql_close($conn);

?>