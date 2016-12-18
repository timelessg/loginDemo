<?php 

class Response
{
	var $code;
	var $msg;
	var $result;

	function __construct($code='', $msg='', $result='')
	{
		$this->code = $code;
		$this->msg = $msg;
		$this->result = $result;
	}
}
class User
{
	var $uid;
	var $phone;
	var $nickname;
	var $email;
	var $sex;

	function __construct($uid='',$nickname='',$email='',$phone='',$sex='')
	{
		$this->uid = $uid;
		$this->nickname = $nickname;
		$this->email = $email;
		$this->phone = $phone;
		$this->sex = $sex;
	}
}

function login($phone, $code)
{
	if ($phone == '13000000000') {
		$user = new User(1,'Garry','garry@timelessg.cn','1111',1);
		$res = new Response(1, '登陆成功', $user);
		return $res;
	}else {
		$res = new Response(0, '登陆失败', (object)null);
		return $res;
	}
}

// $requestUrl = $_SERVER['REQUEST_URI'];

// $path = explode("/", $requestUrl)[2];

$params = $_REQUEST;

// if ($path == 'login') {
	$phone =  $params['phone'];
	$code = $params['code'];

	if ($phone != null && $code != null) {
		$login = login($phone,$code);
		echo json_encode($login);
	}else{
		$res = new Response(0, '参数错误', (object)null);
		echo json_encode($res);
	}
// }
 ?>