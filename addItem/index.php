<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
$json = file_get_contents('php://input');
$data = json_decode($json, true);
if($data['name'] != NULL)
{
	$db = new DbConnect();
	$query = "Insert into items(name, value) values(:name, :value)";
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