<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header('Content-Type: application/json');
 
error_reporting( E_ALL );
ini_set('display_errors', 1);

include_once 'config/database.php';
include_once 'queires.php';
require_once "mail/mail.php";

$database = new Database();
$db = $database->getConnection();
 
$queires = new Queires($db);

if (isset($_GET['callback']))
{
	echo $_GET['callback']."(";
}

if (isset($_GET['email']) && isset($_GET['link']))
{
	$mailer = new Mailer();

	$mailer->reciver = $_GET['email'];
    $mailer->theme = "You are invated";
    $mailer->body = " Hi Dude!\n You are choosen one! But you need to prove yourself.\n Please pass the test at https://atum.online/starttest/".$_GET['link']." and all world will know that you are wortly!\n\nGood luck!!!";
    if ($mailer->Send())
    {
    	echo json_encode(array("message" => "Sended"));
    }
    else
    {
    	echo json_encode(array("message" => "Test not found"));
	}
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