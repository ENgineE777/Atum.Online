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

if ($queires->CheckTest($link))
{
	if ($queires->status == 0)
	{
    	echo json_encode(array("message" => "Exist", "link" => $queires->link));
    }
    else
    {
    	echo json_encode(array("message" => "Exist", "link" => $queires->link, "token" => $queires->token));
    }
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