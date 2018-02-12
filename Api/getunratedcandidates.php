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

if ($queires->GetUnratedCandidates())
{
	$num = $queires->stmt->rowCount();
 
	if($num>0)
	{
		$date = new DateTime();

    	$canditates_arr=array();
    	$canditates_arr["candidates"]=array();
 
    	while ($row = $queires->stmt->fetch(PDO::FETCH_ASSOC))
    	{
        	extract($row);

			if ($status == "1")
			{
				$timeLeft = 60 - ($date->getTimestamp()  - strtotime( $started ) );

            	if ($timeLeft < 0)
				{
					$queires->token = $token;
					$queires->StopTest();
				}

				$status = "2";
			}

			if ($status > 1)
			{
        		$product_item=array("id" => $id,
            						"name" => $name,
            						"email" => $email,
            						"owner" => $owner,
            						"link" => $link,
            						"status" => (String)$status,
                                	"token" => $token,
                                	"rating" => $rating);
 
        		array_push($canditates_arr["candidates"], $product_item);
			}
    	}
 
    	echo json_encode($canditates_arr);
	}
	else
	{
		echo json_encode(array("message" => "Empty"));
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