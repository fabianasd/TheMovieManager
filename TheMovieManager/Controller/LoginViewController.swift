//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Fabiana Petrovick on 18/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = "fabianasd"
        passwordTextField.text = "S3nhaTMDB"
    }
    //IBActions para os botoes, no momento isso segue para o resto do aplicativo, mas o usuario nao esta realmente conectado
    @IBAction func loginTapped(_ sender: UIButton) {
        //  performSegue(withIdentifier: "completeLogin", sender: nil)
        TMDBClient.getRequestToken(completion: handleRequestTokenResponse(success: error:))
    }
    
    @IBAction func loginViaWebsiteTapped() {
        TMDBClient.getRequestToken{ (success, error) in
            if success {
                UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:],
                                          completionHandler: nil)
            }
        }
    }
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            print(TMDBClient.Auth.requestToken)
            TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        print(TMDBClient.Auth.requestToken)
        if success {
            TMDBClient.createSessionId(completion: handleSessionResponse(success:error:))
        }
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
    }
}
