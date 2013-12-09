<?php 
$urls=array(
'http://localhost/img/1.jpg',
'http://localhost/img/2.jpg',
'http://localhost/img/3.jpg',
'http://localhost/img/4.jpg',
'http://localhost/img/5.jpg',
);
 
$save_to='downloaded/';
 
$mh = curl_multi_init();
foreach ($urls as $i => $url) {
    $g=$save_to.basename($url);
    if(!is_file($g)){
        $conn[$i]=curl_init($url);
        $fp[$i]=fopen ($g, "w");
        curl_setopt ($conn[$i], CURLOPT_FILE, $fp[$i]);
        curl_setopt ($conn[$i], CURLOPT_HEADER ,0);
        curl_setopt($conn[$i],CURLOPT_CONNECTTIMEOUT,60);
        curl_multi_add_handle ($mh,$conn[$i]);
    }
}
do {
    $n=curl_multi_exec($mh,$active);
}
while ($active);
foreach ($urls as $i => $url) {
    curl_multi_remove_handle($mh,$conn[$i]);
    curl_close($conn[$i]);
    fclose ($fp[$i]);
}
echo 'sathish';
curl_multi_close($mh);
?>

