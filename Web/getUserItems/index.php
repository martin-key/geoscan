<?php
include '../mysql.php';
$json = $_SERVER['HTTP_DATA'];
$credentials = json_decode($json, true);
	if($credentials['user_id'] != NULL)
	{
		$db = new DbConnect();
		$query = "select user_items.id, user_id, item_id, items.name, items.value from user_items 
	left join items on user_items.item_id = items.id
	where user_id like :user_id and available like 1";
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