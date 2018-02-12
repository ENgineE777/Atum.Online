<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header('Content-Type: application/json');
 
error_reporting( E_ALL );
ini_set('display_errors', 1);

include_once 'config/database.php';
include_once 'queires.php';
 
$database = new Database();
$db = $database->getConnection();
 
$queires = new Queires($db);

if (isset($_GET['callback']))
{
	echo $_GET['callback']."(";
}

$email = isset($_GET['email']) ? $_GET['email'] : "";

if (strlen($email) > 2)
{
	$queires->LeaveRequest($_GET['email']);

	if ($email)
	{
		return;
	}

	echo json_encode(array("message" => "Leaved"));
}
else
{
	echo json_encode(array("message" => "Not leaved"));
}

if (isset($_GET['callback']))
 {
 	echo ")";
 }
?>