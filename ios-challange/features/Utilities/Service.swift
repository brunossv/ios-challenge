//
//  Service.swift
//  ios-challange
//
//  Created by Bruno Soares on 14/01/25.
//

import Foundation
import UIKit

class Services {
    
    static var baseUrl: String { get { return "https://api.tvmaze.com" } }

    enum HTTPmethod: String {
        case post
        case get
    }

    func request<I: Decodable>(_ urlstring: String, method: HTTPmethod = .get, parameters: [String:Any] = [:], headers: [String:String] = [:], completion: @escaping (_ success: I?,_ error: String?) ->()) {

        guard let urlQuery = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            var urlComponente = URLComponents(string: urlQuery) else {
            completion(nil, "Erro inesperado")
            return
        }

        if method == .get && parameters.count > 0 {
            urlComponente.queryItems = []
            for param in parameters {
                urlComponente.queryItems?.append(URLQueryItem(name: param.key, value: "\(param.value)"))
            }
        }

        guard let url = urlComponente.url else {
            completion(nil, "Sem url configurada")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        var headersDefault: [String: String] = [
            "Content-Type": "application/json"
        ]

        headers.forEach { key, value in
            headersDefault[key] = value
        }
        request.allHTTPHeaderFields = headersDefault

        if parameters.count > 0 && method == .post {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        debugPrint(url.absoluteString)
        debugPrint("Method: ", method.rawValue)
        
        if let headers = request.allHTTPHeaderFields {
            debugPrint("Headers:\n", headers)
        }
        
        if parameters.count > 0 {
            let jsonParameters = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            let jsonString = try? JSONSerialization.jsonObject(with: jsonParameters ?? Data(), options: .fragmentsAllowed)
            debugPrint("Parametros:\n", jsonString ?? "")
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            debugPrint(url.absoluteString)
            debugPrint("Method:\n", method.rawValue)
            
            if let headers = request.allHTTPHeaderFields {
                debugPrint("Headers:\n", headers)
            }
            if let parametros = urlComponente.queryItems {
                debugPrint("Parametros:\n", parametros)
            }

            if let msgError = error {
                DispatchQueue.main.async {
                    completion(nil, msgError.localizedDescription)
                }
                return
            }

            if let response = data {
                let debugJson = try? JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.allowFragments)
                debugPrint(debugJson ?? "")

                if let object = try? JSONDecoder().decode(I.self, from: response) {
                    DispatchQueue.main.async {
                        completion(object, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, "Error decode")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, "Erro inesperado")
                }
            }
        }

        task.resume()
    }

    func request<I: Decodable, T: Encodable>(_ urlstring: String, method: HTTPmethod = .get, encodable: T?, headers: [String:String] = [:], completion: @escaping (_ success: I?,_ error: String?) ->()) {
        DispatchQueue.main.async {
            guard let urlQuery = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                var urlComponente = URLComponents(string: urlQuery) else {
                completion(nil, "Erro inesperado")
                return
            }

            if method == .get {
                if let encodableValues = encodable, let data = try? JSONEncoder().encode(encodableValues),
                   let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    urlComponente.queryItems = []

                    for param in dictionary {
                        urlComponente.queryItems?.append(URLQueryItem(name: param.key, value: "\(param.value)"))
                    }
                }
            }

            guard let url = urlComponente.url else {
                completion(nil, "Sem url configurada")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue

            var headersDefault: [String: String] = [
                "Content-Type": "application/json"
            ]

            headers.forEach { key, value in
                headersDefault[key] = value
            }
            request.allHTTPHeaderFields = headersDefault

            if let encodable = encodable, method == .post {
                request.httpBody = try? JSONEncoder().encode(encodable)
                if let body = request.httpBody,
                    let debugJson = try? JSONSerialization.jsonObject(with: body, options: JSONSerialization.ReadingOptions.allowFragments) {
                    debugPrint(url.absoluteString)
                    debugPrint("Method: ", method.rawValue)
                    debugPrint("Headers: ", headersDefault)
                    debugPrint(debugJson)
                }
            }

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                debugPrint(url.absoluteString)
                debugPrint("Method: ", method.rawValue)
                if let headers = request.allHTTPHeaderFields {
                    debugPrint("Headers: ", headers)
                }
                if let parametros = urlComponente.queryItems {
                    debugPrint("Parametros: ", parametros)
                }

                if let msgError = error {
                    DispatchQueue.main.async {
                        completion(nil, msgError.localizedDescription)
                    }
                    return
                }

                if let response = data {
                    let debugJson = try? JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.allowFragments)
                    debugPrint(debugJson ?? "")

                    if let object = try? JSONDecoder().decode(I.self, from: response) {
                        DispatchQueue.main.async {
                            completion(object, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, "Erro servidor")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, "Erro inesperado")
                    }
                }
            }

            task.resume()
        }
    }

    func request(_ urlstring: String, method: HTTPmethod = .get, parameters: [String:Any] = [:], headers: [String:String] = [:], completion: @escaping (_ success: Any?,_ error: String?) ->()) {

        guard let urlQuery = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            var urlComponente = URLComponents(string: urlQuery) else {
            completion(nil, "Erro inesperado")
            return
        }

        if method == .get {
            urlComponente.queryItems = []
            for param in parameters {
                urlComponente.queryItems?.append(URLQueryItem(name: param.key, value: "\(param.value)"))
            }
        }

        guard let url = urlComponente.url else {
            completion(nil, "Sem url configurada")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        var headersDefault: [String: String] = [
            "Content-Type": "application/json"
        ]

        headers.forEach { key, value in
            headersDefault[key] = value
        }
        request.allHTTPHeaderFields = headersDefault

        if parameters.count > 0 {
            let jsonSerialization = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonSerialization
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            debugPrint(url.absoluteString)
            debugPrint("Method: ", method.rawValue)
            if let headers = request.allHTTPHeaderFields {
                debugPrint("Headers: ", headers)
            }
            if let parametros = urlComponente.queryItems {
                debugPrint("Parametros: ", parametros)
            }
            if let msgError = error {
                completion(nil, msgError.localizedDescription)
                return
            }

            if let response = data {
                let debugJson = try? JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.allowFragments)
                debugPrint(debugJson ?? "")

                DispatchQueue.main.async {
                    completion(debugJson, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, "Erro inesperado")
                }
            }
        }

        task.resume()
    }

    func loadImage(_ urlstring: String) async throws -> UIImage? {

        guard let _ = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlstring) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPmethod.get.rawValue
        request.cachePolicy = .useProtocolCachePolicy

        let (image, _) = try await URLSession.shared.data(for: request)
        
        return UIImage(data: image)
    }
}
