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
$ctoken = isset($_GET['ctoken']) ? $_GET['ctoken'] : "empty";

if ($queires->GetCandidate($ctoken))
{
    $row = $queires->stmt->fetch(PDO::FETCH_ASSOC);
    extract($row);

	echo json_encode(array("id" => $id,
            				"name" => $name,
            				"email" => $email,
            				"owner" => $owner,
            				"link" => $link,
            				"status" => $status,
                            "token" => $token,
                            "rating" => $rating));
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