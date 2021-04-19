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
        
        //... o valor associado aqui gera o caminho completo
        var stringValue: String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                
            case .getRequestToken: return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            }
        }
        //esta propriedade de URL computada converte o valor da string em uma URL.
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    //metodo para retornar a lista de observacao.
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) { //o tipo passado para o manipulador de conclusao é uma matriz...
        //Leva um unico parametro, um gerenciador de conclusao e segue as etapas para criar uma solicitacao HTTP get
        let task = URLSession.shared.dataTask(with: Endpoints.getWatchlist.url) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do { //analisa o JSON e é chamado de manipulador de conclusao.
                let responseObject = try decoder.decode(MovieResults.self, from: data)//...de digite filme e o JSON é analisado em um tipo chamado resultados de filme
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    //metodo para retornar a lista de observacao.
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) { //o tipo passado para o manipulador de conclusao é uma matriz...
        //Leva um unico parametro, um gerenciador de conclusao e segue as etapas para criar uma solicitacao HTTP get
        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) { data, response, error  in
            guard let data = data else {
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(RequestTokenResponse.self, from: data)
                Auth.requestToken = responseObject.requestToken
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
}
