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
	<title>发送QQ广播</title>
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
		'resource'		=> 'sendbroadcast',

		'title'			=> '这是测试',
		'content' 		=> '吃饭了，睡觉了', 
		'recv_dept_ids' => '',
		'recv_open_ids' => $_SESSION['open_id'], 
		'open_id'		=> $_SESSION['open_id'],



		);

	$service = new BaseService;
	$data = $service->doHttpRequest($resoure_url,$post,false);
	var_dump($data);

?>


</body>
</html>