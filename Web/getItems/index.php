<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
//$json = file_get_contents('php://input');
$headers = getallheaders();
$json = $headers['data'];
$credentials = json_decode($json, true);

	$db = new DbConnect();
	$query = "select * from items";
	if($credentials['sort'] != NULL)
	{
		$query = "select * from items order by :sort";
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