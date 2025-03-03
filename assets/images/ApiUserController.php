<?php

defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . 'libraries/RestController.php';

use chriskacerguis\RestServer\RestController;

class ApiUserController extends RestController
{

public function __construct()

	{
		parent::__construct();
		// Load API Model
		// $this->load->database();
		// $this->load->vars($data);
		// Extract JSON Data
		$json = file_get_contents("php://input");
		// Convert The String Of Data To An Array
		$this->data = json_decode($json, true);
	}

	public function login_post() {

		$username = $this->data['username'];
		$password = $this->data['password'];
		
		try {
		    $user = $this->User->get_user_by_username($username);

		if ($user && password_verify($password, $user->user_password)) {
			// Successful Login
			if($user->user_role_id == 1){
				$role_name = 'Admin';
			}else if($user->user_role_id == 2){
				$role_name = 'Finance';
			}else{
				$role_name = 'Administrative';
			}
			$response = array(
				'status' => '200',
				'message' => 'Logged In Successfully',
                'data' => [
                	'id' => $user->id,
                	'name' => $user->name,
                    'username' => $user->user_name,
                    'email' => $user->email,
					'role_id' => $user->user_role_id,
					'mobile_number' => $user->mobile_number,
					'role_name' => $role_name
                ]
				);
			$this->output->set_status_header(200);
		} else {
			// Invalid credentials
            $response = array(
                'status' => '404',
                'message' => 'Invalid username or password'
			);
            $this->output->set_status_header(404);
		}
		    
		} catch(Exception $e) {
		    // Invalid credentials
		    
            $response = array(
                'status' => '500',
                'message' => "Caught exception: " . $e->getMessage()
			);
            $this->output->set_status_header(500);
		}

		

		json_output($response['status'], $response);
	}
	
}

?>
