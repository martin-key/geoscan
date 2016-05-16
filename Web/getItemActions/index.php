<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
//$json = file_get_contents('php://input');
$headers = getallheaders();
$json = $headers['data'];
$credentials = json_decode($json, true);

	$db = new DbConnect();
	$query = "select * from item_actions 
	left join user_items on item_actions.user_item_id = user_items.id 
	left join location_items on item_actions.location_item_id = location_items.id 
	";
	if($credentials['sort'] != NULL)
	{
		$query = "select * from item_actions 
	left join user_items on item_actions.user_item_id = user_items.id 
	left join location_items on item_actions.location_item_id = location_items.id order by :sort";
	}
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
?>