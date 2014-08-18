<?php

require 'config.php';

$time = time();
?>
<!DOCTYPE html>
<html>
<head>
	<title>获取code</title>
</head>
<body>


<?php

// var_dump($_SESSION);exit();
if (isset($_GET['code'])) {
	$_SESSION['authorize'] = $_GET['code'];

	$post = array(
		'client_id'		=> $client_id,
		'code'			=> $_GET['code'],
		'grant_type'	=> 'authorization_code',
		'time'			=> $time,
		'signature_method'	=> 'md5',
		'signature'			=> md5($time.$client_id.$client_secret),

		);

	$service = new BaseService;
	$data = $service->doHttpRequest($access_url,$post,false);

	
	
	if ($data['code']==0) {
		$_SESSION['access'] = $data['data']['access_token'];  
	}else{
		var_dump($data);
		exit();
	}
	


}else{
	$access_token = isset($_SESSION['access']) ? $_SESSION['access'] : null;
	if (empty($access_token)) {
		header('Location:'.$authorize_url);	
	}
}

if (!empty($_SESSION['access'])) {
	echo '<br/><b>authorized_code</b>:'.$_SESSION['authorize'];
	echo '<br/><b>access_token</b>:'.$_SESSION['access'];
}


?>

<p>
<a href='userinfo.php' target="_blank">用户信息</a>
</p>

<p>
<a href='userlist.php' target="_blank">用户列表</a>

</p>

<p>
<a href='departments.php' target="_blank">部门组织</a>

</p>

<p>
<a href='sendqq.php' target="_blank">发送QQ</a>

</p>

<p>
<a href='sendbroadcast.php' target="_blank">发送广播</a>

</p>

<p>
<a href='login.php' target="_blank">单点登录</a>

</p>


</body>
</html>




