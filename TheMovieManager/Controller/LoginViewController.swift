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
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    //IBActions para os botoes, no momento isso segue para o resto do aplicativo, mas o usuario nao esta realmente conectado
    @IBAction func loginTapped(_ sender: UIButton) {
        //  performSegue(withIdentifier: "completeLogin", sender: nil)
        TMDBClient.getRequestToken(completion: handleRequestTokenResponse(success: Error:))
    }
    
    @IBAction func loginViaWebsiteTapped() {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    func handleRequestTokenResponse(success: Bool, Error: Error?) {
        if success {
            print(TMDBClient.Auth.requestToken)
            print("success handleRequestTokenResponse")
            TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:Error:))
        }
    }
    
    func handleLoginResponse(success: Bool, Error: Error?) {
        print(TMDBClient.Auth.requestToken)
        if success {
             print("success handleLoginResponse")
            TMDBClient.createSessionId(completion: handleSessionResponse(success:Error:))
        }
    }
    
    func handleSessionResponse(success: Bool, Error: Error?) {
        if success {
            print("success handleSessionResponse")
            DispatchQueue.main.async {
                 print("success handleSessionResponse 2")
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
        }
    }
}
