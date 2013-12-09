<?php

include 'config.php';
include 'connect.php';

$title = "";
$content = "";
$category = "";

if( isset($_POST['title']) ) $title = $_POST['title'];
if( isset($_POST['category']) ) $category = $_POST['category'];
if( isset($_POST['content']) ) $content = $_POST['content'];

$query = "INSERT into articles (title, category, published) VALUES ('$title','$category',false)";
mysql_query($query);

$articleId = mysql_insert_id();

$query = "INSERT INTO contents (articleId, content) VALUES ($articleId,'$content')";
mysql_query($query);

$query = "FLUSH PRIVILEGES";
mysql_query($query);

echo "<?xml version='1.0' ?>\n";
echo "<insert>\n";
echo "  <success>true</success>\n";
echo "</insert>";


mysql_close($conn);
?>