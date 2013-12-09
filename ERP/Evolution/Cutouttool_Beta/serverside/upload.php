<?php 
ini_set ( max_execution_time, "1000");
ini_set ( memory_limit, "1000M");
ini_set ( post_max_size, "1000M");
ini_set ( upload_max_filesize, "1000M"); 
$dir = getcwd();
$dir = $dir."/uploadedFiles";
if(!file_exists($dir)){
	mkdir($dir,0777);
}
if($_POST["userType"]=="1"){
	$dir = $dir."/client";
}else if ($_POST["userType"] == "2") {
	$dir = $dir."/supplier";
}
if(!file_exists($dir)){
	mkdir($dir,0777);
}	
$dir = $dir."/".$_POST["clientName"];
if(!file_exists($dir)){
	mkdir($dir,0777);
}
$dir = $dir."/".$_POST["year"];
if(!file_exists($dir)){
	mkdir($dir,0777);
}
$dir = $dir."/".$_POST["month"];
if(!file_exists($dir)){
	mkdir($dir,0777);
}
$dir = $dir."/".$_POST["date"]."/";   
if(!file_exists($dir)){
	mkdir($dir,0777);
}
$destination_dir = $dir;
if(
  isset($_FILES['Filedata']) &&
  is_array($_FILES['Filedata']) &&
  isset(
      $_FILES['Filedata']['tmp_name'],
      $_FILES['Filedata']['name'],
      $_FILES['Filedata']['size'],
      $_FILES['Filedata']['error']
  ) &&
  intVal($_FILES['Filedata']['error']) === 0
) {
  if(move_uploaded_file($_FILES['Filedata']['tmp_name'], $destination_dir.$_FILES['Filedata']['name'])) {
      $result = "
          Date: ".date('Y-m-d H:i:s')."
          File: {$_FILES['Filedata']['tmp_name']}
          Size: {$_FILES['Filedata']['size']}
          Successfull uploaded.
      ".$dir;
  }
  else {
      $result = "
          Date: ".date('Y-m-d H:i:s')."
          File: {$_FILES['Filedata']['tmp_name']}
          Size: {$_FILES['Filedata']['size']}
          Error: {$_FILES['Filedata']['error']}
          Unable to move file.
      ".$dir;
  }
  if(@$fp = fopen($destination_dir.'upload.txt', 'w')) {
      fwrite($fp, $result);
      fclose($fp);
  }
}
?>