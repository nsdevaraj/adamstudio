<?php

include 'config.php';
include 'connect.php';

$articleId = "";
$title = "";
$content = "";
$category = "";

if( isset($_POST['articleId']) ) $articleId = $_POST['articleId'];
if( isset($_POST['title']) ) $title = $_POST['title'];
if( isset($_POST['category']) ) $category = $_POST['category'];
if( isset($_POST['content']) ) $content = $_POST['content'];

$query = "UPDATE articles ";
$query = $query . " SET title='$title', category='$category', edit_dt=current_timestamp";
$query = $query . " WHERE id = $articleId";
mysql_query($query);

$query = "UPDATE contents SET content='$content' WHERE articleId = $articleId";
mysql_query($query);

$query = "FLUSH PRIVILEGES";
mysql_query($query);

echo "<?xml version='1.0' ?>\n";
echo "<update>\n";
echo "  <success>true</success>\n";
echo "</update>";


mysql_close($conn);
?>