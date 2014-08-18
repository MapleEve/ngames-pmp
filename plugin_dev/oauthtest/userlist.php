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
	<title>获取用户列表</title>
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
		'resource'		=> 'userlist',
		
		);

	$service = new BaseService;
	$data = $service->doHttpRequest($resoure_url,$post,false);
	var_dump($data);

?>


</body>
</html>