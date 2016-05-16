<?php
include 'mysql.php';


$db = new DbConnect();
$headers = getallheaders();
if($headers['Credentials'])
{
	$credentials = json_decode($headers['Credentials'], true);
	if($credentials != NULL && $credentials['email'] != NULL && $credentials['password'] != NULL)
	{
		if($db->authorization_check($credentials['email'], $credentials['password']))
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