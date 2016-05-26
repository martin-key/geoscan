<?php
include '../mysql.php';
$json = $_SERVER['HTTP_DATA'];
$credentials = json_decode($json, true);
	if($credentials['location_id'] != NULL)
	{
		$db = new DbConnect();
		$query = "select location_items.id, location_id, item_id, items.name, items.value from location_items 
	left join items on location_items.item_id = items.id
	where location_id like :location_id and available like 1";
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
	
	
?>