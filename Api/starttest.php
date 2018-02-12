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

$link = isset($_GET['link']) ? $_GET['link'] : "empty";
$email = isset($_GET['email']) ? $_GET['email'] : "empty";

if ($queires->StartTest($link, $email))
{
	echo json_encode(array("message" => "Passed", "link" => $queires->link, "token" => $queires->token));
}
else
{
	echo json_encode(array("message" => "User not found"));
}

if (isset($_GET['callback']))
{
 	echo ")";
}
?>