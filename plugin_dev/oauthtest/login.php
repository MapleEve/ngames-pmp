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
	<title>单点登录</title>
</head>
<body>
<?php
if (!isset($_GET['hashkey']) || !isset($_GET['account'])) {
	header('Location:'.$login_url);	
}

	$time = time();
	$post = array(

		'client_id'		=> $client_id,
		'code'			=> $access_token,
		'time'			=> $time,
		'signature_method'	=> 'md5',
		'signature'			=> md5($time.$client_id.$client_secret),
		'hashkey'			=> $_GET['hashkey'],
		'account'			=> $_GET['account'],
		);
	// var_dump($post);exit();
	$service = new BaseService;
	$data = $service->doHttpRequest($verifyhashkey_url,$post,false);
	var_dump($data);

?>


</body>
</html>