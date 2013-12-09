<?php

include 'config.php';
include 'connect.php';

$articleId = 0;

if( isset($_GET['articleId']) ) $articleId = $_GET['articleId'];
else {
		echo "<?xml version='1.0' ?><delete><success>false</success></delete>";
		return;
}

$query = "DELETE FROM contents WHERE articleId = '$articleId'";
mysql_query($query);

$query = "DELETE FROM articles WHERE id = $articleId";
mysql_query($query);

echo "<?xml version='1.0' ?><delete><success>true</success></delete>";

mysql_close($conn);