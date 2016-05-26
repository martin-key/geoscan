<?php
include '../mysql.php';
$json = $_SERVER['HTTP_DATA'];
$credentials = json_decode($json, true);
	if($credentials['id'] != NULL)
	{
		$db = new DbConnect();
		$query = "update user_items set available = 0
	where id like :id";
	$result = $db->execute_query($query, $credentials);
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