<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
$json = file_get_contents('php://input');
$credentials = json_decode($json, true);
if($credentials['name'] != NULL)
{
	$db = new DbConnect();
	$query = "Insert into locations(name, latitude, longitude) values(:name, :latitude, :longitude)";
	if($db->execute_query($query, $credentials))
	{
		http_response_code(200);
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