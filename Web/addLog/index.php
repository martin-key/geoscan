<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
$json = file_get_contents('php://input');
$data = json_decode($json, true);
if($data['user_id'] != NULL)
{
	$db = new DbConnect();
	$query = "Insert into location_log(user_id, location_id, date) values(:user_id, :location_id, :datetime)";
	if($data['datetime'] == NULL)
	{
		$query = "Insert into location_log(user_id, location_id, date) values(:user_id, :location_id, now())";
	}
	if($db->execute_query($query, $data))
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