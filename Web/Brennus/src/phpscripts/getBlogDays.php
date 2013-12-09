<?php

include 'config.php';
include 'connect.php';

$month = 0;
$year  = 0;

if( isset($_GET['month']) ) $month = $_GET['month'];
if( isset($_GET['year']) )  $year  = $_GET['year'];

$query = "select distinct DAY(edit_dt) as day";
$query = $query." from articles";
$query = $query." where MONTH(edit_dt) = $month and YEAR(edit_dt) = $year and published = true and category <> 0";
$query = $query." order by day asc";
$result = mysql_query($query);

echo "<?xml version='1.0' ?>\n";
echo "<blogdays>\n";
echo "  <month>$month</month>\n";
echo "  <year>$year</year>\n";

while( $row=mysql_fetch_array($result, MYSQL_ASSOC) )
{
	echo "  <day num='".$row['day']."' />\n";
}

echo "</blogdays>";

mysql_close($conn);
?>