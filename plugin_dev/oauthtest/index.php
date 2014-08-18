<?php

require 'config.php';

$access_token = isset($_SESSION['access']) ? $_SESSION['access'] : null;

$get_url = 'http://localhost/oauthtest/get.php';

?>

<html>
<head>
	<title>Oauth测试</title>
</head>
<body>
	<a href="<?php echo $get_url;?>" target="_blank">用户授权</a>

</body>
</html>