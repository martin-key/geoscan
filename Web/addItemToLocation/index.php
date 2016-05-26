<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
$json = file_get_contents('php://input');
$credentials = json_decode($json, true);
if($credentials['location_id'] != NULL)
{
	$db = new DbConnect();
	$query = "Insert into location_items(location_id, item_id) values(:location_id, :item_id)";
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