<?php

require_once "mail/mail.php";

class Queires
{ 
    private $conn;
    public $token;
    public $userID;
    public $link;
    public $data0;
    public $data1;
    public $data2;
    public $data3;
    public $timeLeft;
    public $status;
    public $stmt;

    public function __construct($db)
    {
        $this->conn = $db;
    }

    function MarkServer($ip, $port)
    {
        $query = "UPDATE server SET ip=".$ip.", port=".$port." where id=1";

        $stmt = $this->conn->prepare($query);

        $stmt->execute();
    }

    function GetServer()
    {
        $query = "SELECT * FROM server where id=1";

        $this->stmt = $this->conn->prepare($query);

        $this->stmt->execute();

        if ($this->stmt->rowCount() > 0)
        {
            return true;
        }

        return false;
    }

    function LeaveRequest($email)
    {
        $query = "SELECT * FROM requests WHERE email = '".$email."'";

        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();

        if ($stmt->rowCount() == 0)
        {
            $query = "INSERT INTO requests SET email='".$email."'";

            $stmt = $this->conn->prepare($query);

            $stmt->execute();

            $mailer = new Mailer();
            
            $mailer->reciver = 'rimma.solyanova@gmail.com';
            $mailer->theme = "New betta testing request!";
            $mailer->body = "  Greate guy with email ".$email." just now leaved request to mege beta testig! Yeeeeeeeaaah!!!!";
            $mailer->Send();
        }
    }

    function CheckLoginData($login, $pass)
    {
        $query = "SELECT * FROM users WHERE login = '".$login."'";

        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();

        if ($stmt->rowCount() > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            if (strcmp(md5($pass), $row['pass']) == 0)
            {
                if ($row['role'] == 0)
                {
                    $this->link = "Dashboard";
                }
                else
                if ($row['role'] == 1)
                {
                    $this->link = "DashboardRate";
                }

                $this->token = $row['token'];

                return true;
            }
        }
 
        return false;
    }

    function CheckToken()
    {
        $query = "SELECT * FROM users WHERE token = '".$this->token."'";

        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();

        $num = $stmt->rowCount();

        if ($num > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            $this->userID = $row['id'];

            return true;
        }

        return false;

    }

    function AddCandidate($name, $email)
    {
        if (!$this->CheckToken())
        {
            return false;
        }

        if (is_null($name) || is_null($email))
        {
            return false;
        }
 
        $name=htmlspecialchars(strip_tags($name));
        $email=htmlspecialchars(strip_tags($email));
        $type = 0;
        $link = md5($name.$email);
        $token = md5($email.$name);
        $data0 = '';
        $data1 = '';
        $data2 = '';
        $data3 = '';
 
        $query = "SELECT * FROM testers_data";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        $num = $stmt->rowCount();

        if ($num > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            $data0 = $row['issues'];
            $data1 = $row['check_list'];
            $data2 = $row['user_reports'];
            $data3 = $row['description'];
        }

        $query = "INSERT INTO candidates SET name='".$name."', email='".$email."', owner=".$this->userID.", type=".$type.",link='".$link."', token='".$token."', data0='".$data0."', data1='".$data1."', data2='".$data2."', data3='".$data3."'";
        $stmt = $this->conn->prepare($query);

        if($stmt->execute())
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    function GetCandidates()
    {
        if (!$this->CheckToken())
        {
            return false;
        }

        $query = "SELECT * FROM candidates WHERE owner = ".$this->userID;
 
        $this->stmt = $this->conn->prepare($query);
 
        $this->stmt->execute();
 
        return true;
    }

    function GetUnratedCandidates()
    {
        if (!$this->CheckToken())
        {
            return false;
        }

        $query = "SELECT * FROM candidates WHERE owner = ".$this->userID." AND status > 0";
 
        $this->stmt = $this->conn->prepare($query);
 
        $this->stmt->execute();
 
        return true;
    }

    function GetCandidate($token)
    {
        if (!$this->CheckToken())
        {
            return false;
        }

        $query = "SELECT * FROM candidates WHERE token = '".$token."'";
 
        $this->stmt = $this->conn->prepare($query);
 
        $this->stmt->execute();
 
        if ($this->stmt->rowCount() > 0)
        {
            return true;
        }

        return false;
    }

    function GetLink($type)
    {
        if ($type == 0)
        {
            return "Tester";
        }

        return "Not ready";
    }

    function CheckTest($link)
    {
        $query = "SELECT * FROM candidates WHERE link = '".$link."'";
 
        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();
 
        if ($stmt->rowCount() > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            $this->status = $row['status'];

            if ($this->status == 0)
            {
                $this->link = "Not ready";
                return true;
            }
            else
            if ($this->status == 1)
            {
                $this->link = $this->GetLink($row['type']);
                $this->token = $row['token'];

                return true;
            }            
        }

        return false;
    }

    function CheckTestToken($token)
    {
        $query = "SELECT * FROM candidates WHERE token = '".$token."'";
 
        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();
 
        if ($stmt->rowCount() > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            $this->status = $row['status'];

            if ($this->status == 0)
            {
                return false;
            }
            else
            if ($this->status == 1)
            {
                $this->token = $row['token'];
                $this->data0 = $row['data0'];
                $this->data1 = $row['data1'];
                $this->data2 = $row['data2'];
                $this->data3 = $row['data3'];

                $date = new DateTime();
                $this->timeLeft = 60000 - ($date->getTimestamp() - strtotime( $row['started'] ));
                return true;
            }            
        }

        return false;
    }

    function StartTest($link, $email)
    {
        $query = "SELECT * FROM candidates WHERE link = '".$link."'";

        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();

        if ($stmt->rowCount() > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            $this->token = $row['token'];

            if (strcasecmp($email, $row['email']) == 0)
            {
                $this->link = $this->GetLink($row['type']);

                if ($row['status'] == 0)
                {
                    $date = new DateTime();

                    $query = "UPDATE candidates SET status = 1, started = FROM_UNIXTIME(".$date->getTimestamp().") WHERE id = ".$row['id'];

                    $stmt = $this->conn->prepare($query);
 
                    $stmt->execute();
                }

                return true;
            }
        }
 
        return false;
    }

    function StopTest()
    {
        $query = "SELECT * FROM candidates WHERE token = '".$this->token."'";

        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();

        if ($stmt->rowCount() > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            $query = "SELECT * FROM users WHERE id = ".$row['owner'];

            $stmt = $this->conn->prepare($query);
 
            $stmt->execute();

            if ($stmt->rowCount() > 0)
            {
                $rw = $stmt->fetch(PDO::FETCH_ASSOC);

                $mailer = new Mailer();

	            $mailer->reciver = $rw['email'];
                $mailer->theme = "Hi!";
                $mailer->body = "  Candidate ".$row['name']." are completeted the test. We need som time to analyze result of the test. They wiil be ready very soon!";
                $mailer->Send();
            }

            $query = "UPDATE candidates SET status = 2 WHERE id = ".$row['id'];

            $stmt = $this->conn->prepare($query);
 
            $stmt->execute();

            return true;
        }
 
        return false;
    }

    function SaveIssues($issues)
    {
        $query = "SELECT * FROM candidates WHERE token = '".$this->token."'";

        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();

        if ($stmt->rowCount() > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            $query = "UPDATE candidates SET data0 = '".$issues."' WHERE token = '".$this->token."'";

            $stmt = $this->conn->prepare($query);
 
            $stmt->execute();

            return true;
        }
 
        return false;
    }

    function SaveChecklist($checklist)
    {
        $query = "SELECT * FROM candidates WHERE token = '".$this->token."'";

        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();

        if ($stmt->rowCount() > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            $query = "UPDATE candidates SET data1 = '".$checklist."' WHERE token = '".$this->token."'";

            $stmt = $this->conn->prepare($query);
 
            $stmt->execute();

            return true;
        }
 
        return false;
    }


    function RateCandidate($ctoken, $rating)
    {
        if (!$this->CheckToken())
        {
            return false;
        }

        $query = "SELECT * FROM candidates WHERE token = '".$ctoken."'";

        $stmt = $this->conn->prepare($query);
 
        $stmt->execute();

        if ($stmt->rowCount() > 0)
        {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($row['status'] == 2)
            {
                $query = "SELECT * FROM users WHERE id = ".$row['owner'];

                $stmt = $this->conn->prepare($query);
 
                $stmt->execute();

                if ($stmt->rowCount() > 0)
                {
                    $rw = $stmt->fetch(PDO::FETCH_ASSOC);

                    $mailer = new Mailer();

                    $mailer->reciver = $rw['email'];
                    $mailer->theme = "Hi!";
                    $mailer->body = "  Result of the testing candidate ".$row['name']." is ready at http://atum.online/testers/".$ctoken.".";
                    $mailer->Send();
                }
            }

            $query = "UPDATE candidates SET status = 3, rating = ".$rating." WHERE token = '".$ctoken."'";

            $stmt = $this->conn->prepare($query);
 
            $stmt->execute();
        }
 
        return true;
    }
}