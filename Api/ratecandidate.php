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

$ctoken = isset($_GET['ctoken']) ? $_GET['ctoken'] : "empty";
$rating = isset($_GET['rating']) ? $_GET['rating'] : 0;
$queires->token = isset($_GET['token']) ? $_GET['token'] : "empty";

if ($queires->RateCandidate($ctoken, $rating))
{
	echo json_encode(array("message" => "Rated"));
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