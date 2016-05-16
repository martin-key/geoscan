<?php
class DbConnect
{
	private $dbConnection;
	function __construct()
	{
		$url = 'localhost';//'rapiddevcrew.com';
		$username = 'rapidde_puff';
		$pass = '12348765';
		$database = 'rapidde_puff';
		$this->dbConnection = new PDO('mysql:dbname='.$database.';host='.$url.';charset=utf8', $username, $pass);
		$this->dbConnection->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
		$this->dbConnection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	}
	
	function authorization_check($email, $password)
	{
		$query = 'Select email, password from users where email = :email';
		$stmt = $this->dbConnection->prepare($query);
		$params = array('email' => $email);
		$stmt->execute($params);
		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		if(is_array($result) && $result && password_verify($password, $result['password']))
		{
			return true;
		}
		return false;
		
	}
	
	function execute_query($query, $params, $isSelect)
	{
		$stmt = $this->dbConnection->prepare($query);
		if($stmt->execute($params))
		{
			//echo "query executed";
			if($isSelect ===true)
			{
				$fetch = $stmt->fetchAll(PDO::FETCH_ASSOC);
				$result = json_encode($fetch);
			}
			else
			{
				$result = true;
			}
		}
		else
		{
			//echo "query not executed";
			$result = false;
			echo $stmt->errorinfo();
		}
		return $result;
	}
	
	
	
	
	
}
	
?>