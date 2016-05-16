<?php
include 'mysql.php';


$db = new DbConnect();
$headers = getallheaders();
if($headers['Credentials'])
{
	$credentials = json_decode($headers['Credentials'], true);
	if($credentials != NULL && $credentials['username'] != NULL && $credentials['password'] != NULL)
	{
		if($db->authorization_check($credentials['username'], $credentials['password']))
		{
			http_response_code(200);
			echo 'Success';
		}
		else
		{
			http_response_code(401);
		}
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