<?php

include 'config.php';
include 'connect.php';

$articleId = "";
$publish = true;

if( isset($_GET['articleId']) ) $articleId = $_GET['articleId'];
if( isset($_GET['publish']) ) $publish = $_GET['publish'];
else {
		echo "<?xml version='1.0' ?><publish><success>false</publish>";
		return;
}

$query = "UPDATE articles ";
$query = $query . " SET published=$publish";
$query = $query . " WHERE id = $articleId";
mysql_query($query);

$query = "FLUSH PRIVILEGES";
mysql_query($query);

echo "<?xml version='1.0' ?>\n";
echo "<publish>\n";
echo "  <success>true</success>\n";
echo "  <flag>$publish</flag>\n";
echo "</publish>";


mysql_close($conn);
?>