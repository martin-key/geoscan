<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
$json = file_get_contents('php://input');
$data = json_decode($json, true);
if($data['user_item_id'] != NULL)
{
	$db = new DbConnect();
	$query = "Insert into item_actions(user_item_id, location_item_id, action) values(:user_item_id, :location_item_id, :action)";
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