<?php
/**
* Export data, delivered in the POST, to excel.
*
* @version $Id: exportexcel.php,v 1.1 2009-10-07 14:10:11 christian Exp $
*/
header('ETag: etagforie7download'); //IE7 requires this header
header('Content-type: application/octet_stream');
header('Content-disposition: attachment; filename="report.xls"');
//Add html tags, so that excel can interpret it
echo "<html><body>".stripslashes($_POST["htmltable"])."
</body>
</html>
";

?>