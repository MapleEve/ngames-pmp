<?php
session_start();
error_reporting(E_ALL^E_NOTICE);
require 'service.php';
header('Content-type: text/html; charset=utf-8');
$client_id = 110003;
$client_secret = 'de55b038ed25a3e126409abeb14d5bd0baf30cd2';

$authorize_url = 'http://oatest.ngames.cn/oauth/v2/authorize?client_id='.$client_id.'&response_type=code';
$access_url = 'http://oatest.ngames.cn/oauth/v2/token';
$resoure_url = 'http://oatest.ngames.cn/oauth/v2/resource';

$login_url = 'http://oatest.ngames.cn/login?logintype=oauth&callback_url='.urlencode('http://localhost/oauthtest/login.php');
$verifyhashkey_url = 'http://oatest.ngames.cn/oauth/v2/verifyhashkey';