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

$login = isset($_GET['login']) ? $_GET['login'] : "empty";
$pass = isset($_GET['pass']) ? $_GET['pass'] : "empty";

if ($queires->CheckLoginData($login, $pass))
{
	echo json_encode(array("message" => "Passed", "token" => $queires->token, "link" => $queires->link));
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