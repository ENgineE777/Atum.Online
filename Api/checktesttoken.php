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

$token = isset($_GET['token']) ? $_GET['token'] : "empty";

if ($queires->CheckTestToken($token))
{
	echo json_encode(array("message" => "Exist",
							"token" => $queires->token,
							"data0" => $queires->data0,
							"data1" => $queires->data1,
							"data2" => $queires->data2,
							"data3" => $queires->data3,
							"timeLeft" => $queires->timeLeft));
}
else
{
	echo json_encode(array("message" => "Empty"));
}

if (isset($_GET['callback']))
{
 	echo ")";
}
?>