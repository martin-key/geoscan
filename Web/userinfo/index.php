<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
//$json = file_get_contents('php://input');
$headers = getallheaders();
$json = $headers['Credentials'];
$credentials = json_decode($json, true);
if($credentials['username'] != NULL)
{
	$db = new DbConnect();
	$query = "select id, username, name, familyName, email, points from users where username like :username";
	
	$result = $db->execute_query($query, $credentials, true);
	if($result)
	{
		http_response_code(200);
		echo $result;
	}
	else
	{
		http_response_code(400);
	}
	
}
else
{
	http_response_code(401);
}


?>