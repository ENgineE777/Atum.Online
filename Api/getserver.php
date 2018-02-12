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

if ($queires->GetServer())
{
    $row = $queires->stmt->fetch(PDO::FETCH_ASSOC);
    extract($row);

	echo json_encode(array("ip" => $ip,
            				"port" => $port));
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