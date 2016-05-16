<?php
include '../mysql.php';
$json = $_SERVER['HTTP_DATA'];
$credentials = json_decode($json, true);
if($credentials != NULL && $credentials['username'] != NULL && $credentials['password'] != NULL)
{
	$db = new DbConnect();
	$query = "Insert into users(email, password) values(:username, :password)";
	$credentials['password'] = password_hash($credentials['password'], PASSWORD_BCRYPT);
	if($db->execute_query($query, $credentials))
	{
		http_response_code(200);
		echo "User ".$credentials['username']." created";
	}
	else
	{
		http_response_code(400);
	}
	
}
else
{
	http_response_code(400);
}


?>