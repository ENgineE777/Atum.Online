<?php
require_once "SendMailSmtpClass.php";
 
class Mailer
{ 
    private $mailSMTP;
    public $reciver;
    public $theme;
    public $body;

	public function Send()
    {
		$mailSMTP = new SendMailSmtpClass('enginee777@yandex.ru', 'Se400860', 'ssl://smtp.yandex.ru', 'Evgeniy', 465);
  
		// заголовок письма
		$headers= "MIME-Version: 1.0\r\n";
		$headers .= "Content-type: text/html; charset=utf-8\r\n";
		$headers .= "From: Atum.Online <robot@atum.online>\r\n";
		return $mailSMTP->send($this->reciver, $this->theme, $this->body, $headers);
	}
}

 ?>