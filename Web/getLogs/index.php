<?php
include '../mysql.php';
$json = $_SERVER['HTTP_DATA'];
$credentials = json_decode($json, true);
if($credentials['user_id'] != NULL)
{
	$db = new DbConnect();
	$query = "select user_id, location_id, date, locations.name as location_name, users.name as user_name  from location_log 
	left join locations on location_log.location_id = locations.id
	left join users on location_log.user_id = users.id
	where user_id like :user_id
	ORDER by date DESC";
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