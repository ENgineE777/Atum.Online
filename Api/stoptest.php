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

$queires->token = isset($_GET['token']) ? $_GET['token'] : "empty";

if ($queires->StopTest())
{
	echo json_encode(array("message" => "Finished"));
}
else
{
	echo json_encode(array("message" => "Test not found"));
}

if (isset($_GET['callback']))
 {
 	echo ")";
 }
?>