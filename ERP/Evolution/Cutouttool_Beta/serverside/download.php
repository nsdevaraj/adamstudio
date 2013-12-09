<?php
// ver. 1.04 - added an example how to use this script with the filename from a query string
// ver. 1.03 - moved the disposition header into the switch because the attachement attibute is sometimes needed  
// ver. 1.02 - use pathinfo() to get the fileinformation (extesnion) now
// ver. 1.01 - Added the stringconv. to handle also extensions with caps
 
// place this code inside a php file and call it f.e. "download.php"
$path = $_GET['path'];//"C:/wamp/www/flex/amfphp/services/dev/zipFile.zip"; // play with the path if the document root does noet exist
$fullPath = $path;
if ($fd = fopen ($fullPath, "r")) {
    $fsize = filesize($fullPath);
    $path_parts = pathinfo($fullPath);
    $ext = strtolower($path_parts["extension"]); 
    switch ($ext) {
        case "pdf":
        header("Content-type: application/pdf"); // add here more headers for diff. extensions
        header("Content-Disposition: attachment; filename=\"".$path_parts["basename"]."\""); // use 'attachement' to force a download
        break;
        default;
        header("Content-type: application/octet-stream");
        header("Content-Disposition: filename=\"".$path_parts["basename"]."\"");
    }
    header("Content-length: $fsize");
    header("Cache-control: private"); //use this to open files directly
    while(!feof($fd)) {
        $buffer = fread($fd, 2048);
        echo $buffer;
    }
}
fclose ($fd);
exit;
// example: place this kind of link into your document where the download is shown:
// <a href="download.php?download_file=some_file.pdf">Download here</a>
?>