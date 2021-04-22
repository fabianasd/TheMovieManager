//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Fabiana Petrovick on 18/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation
//codigo para interagir com a API do banco de dados de filmes
class TMDBClient {
    //propriedade estatica para a chave API
    static let apiKey = "8b0551a273cbd9426bc0254eb7c3b05e"
    // autenticacao, é estatica e referenciada pelo nome da classe ou estrutura seguido por um ponto seguido por o nome da propridade estatica que nao pertence para qualquer instancia da classe TMDBClients
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    //para fazer solicitacoes a esta API
    enum Endpoints {
        //endpoints sao construidos a partir do URL base e...
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getWatchlist
        case getRequestToken
        case login
        case createSessionId
        case webAuth
        case logout
        
        //... o valor associado aqui gera o caminho completo
        var stringValue: String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getRequestToken: return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .login: return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .createSessionId: return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .webAuth: return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=themoviemanager:authenticate"
            case .logout: return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            }
        }
        //esta propriedade de URL computada converte o valor da string em uma URL.
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error  in
            guard let data = data else {
                //acontece se houver um erro com a solicitação
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    //se a analise JSON for bem-sucedida ou...
                    completion(responseObject, nil)
                }
            } catch {
                //... falhar
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                //acontece se houver um erro com a solicitação
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    //se a analise JSON for bem-sucedida ou...
                    completion(responseObject, nil)
                }
            } catch {
                //... falhar
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    //get
    //metodo para retornar a lista de observacao.
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) { //o tipo passado para o manipulador de conclusao é uma matriz...
        //Leva um unico parametro, um gerenciador de conclusao e segue as etapas para criar uma solicitacao HTTP get
        taskForGETRequest(url: Endpoints.getRequestToken.url, response: RequestTokenResponse.self) { (response, error) in
            if let response = response {
                Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    //post
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
       let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: RequestTokenResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    //post
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
        let body = PostSession(requestToken: Auth.requestToken)
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) { (response, error) in
            
      if let response = response {
                       Auth.sessionId = response.sessionId
                       completion(true, nil)
                   } else {
                       completion(false, error)
                   }
               }
           }
    
    //post
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LogoutRequest(sessionId: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            Auth.requestToken = ""
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    //get
    //metodo para retornar a lista de observacao.
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) { //o tipo passado para o manipulador de conclusao é uma matriz...
        //Leva um unico parametro, um gerenciador de conclusao e segue as etapas para criar uma solicitacao HTTP get
        taskForGETRequest(url: Endpoints.getWatchlist.url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
}
