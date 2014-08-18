<?php
require 'config.php';

$access_token = isset($_SESSION['access']) ? $_SESSION['access'] : null;

if (empty($access_token)) {
	header('Location:'.$authorize_url);	
}

?>
<!DOCTYPE html>
<html>
<head>
	<title>发送QQ提醒</title>
</head>
<body>
<?php

	$time = time();
	$post = array(

		'client_id'		=> $client_id,
		'code'			=> $access_token,
		'time'			=> $time,
		'signature_method'	=> 'md5',
		'signature'			=> md5($time.$client_id.$client_secret),
		'resource'		=> 'sendqq',
		'receivers'		=> $_SESSION['open_id'],
		'tips_content'  => '这里有美女', 
		'tips_url' 		=> 'http://www.baidu.com', 
		'window_title'  => '操',
		'tips_title'    => 'OAKJKJJK',
		'receive_type'  => 0,
		'to_all'        => 0,
		'display_time'  => 0,


		);

	$service = new BaseService;
	$data = $service->doHttpRequest($resoure_url,$post,false);
	var_dump($data);

?>


</body>
</html>