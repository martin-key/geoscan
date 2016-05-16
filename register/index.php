<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
$json = file_get_contents('php://input');
$credentials = json_decode($json, true);
if($credentials['email'] != NULL && $credentials['password'] != NULL)
{
	$db = new DbConnect();
	$query = "Insert into users(email, password, username, name, familyName) values(:email, :password, :username, :name, :familyName)";
	$credentials['password'] = password_hash($credentials['password'], PASSWORD_BCRYPT);
	if($db->execute_query($query, $credentials))
	{
		http_response_code(200);
		echo "User ".$credentials['email']." created";
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