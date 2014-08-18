<?php
/**
 * Service基类
 * @author Alex
 */
class BaseService {
    /**
     * 根据参数发起curl请求
     * @param string $url url
     * @param array $params 参数array('key' => 'value')
     * @param boolean $usePost 是否使用post请求 默认true使用post方式 
     * @param string $charset URL编码 格式
     * @param string $analysis 解析方式，默认 json
     * @return string result or false
     */
    public function doHttpRequest($url, $params, $usePost = true, $charset = 'utf-8', $analysis = 'json') {
        $result = false;
        if ($usePost) {
            $options = array(
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_CONNECTTIMEOUT => 10,
                CURLOPT_TIMEOUT => 10,
                CURLOPT_POST => true,
                CURLOPT_POSTFIELDS => http_build_query($params,'param_','&'),
            );
        } else {
            $options = array(
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_CONNECTTIMEOUT => 10,
                CURLOPT_TIMEOUT => 10,
            );
            $url = $url . '?' . http_build_query($params,'param_','&');
        }
        if ($charset != 'utf-8') {
            $url = @iconv('utf-8', $charset, $url);
        }
        $curl = curl_init($url);
        if (curl_setopt_array($curl, $options)) {
            $result = curl_exec($curl);
        }
        var_dump($result);exit();
        if ($analysis == 'json') {
        	$result = json_decode($result, true);
        } elseif ($analysis == 'xml') {
        	$result = @simplexml_load_string($result);
        }
        curl_close($curl);
        return $result;
    }

}