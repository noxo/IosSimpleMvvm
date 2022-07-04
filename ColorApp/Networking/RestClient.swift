//
//  RestClient.swift
//  ColorApp
//
//  Created by Erkki Nokso-Koivisto on 4.7.2022.
//

import Foundation
import Combine

enum RestClientError: Error {
    case failed
}

protocol RestClientProtocol {
    func doRequestJson<T : Decodable>(
        request: URLRequest
    ) -> AnyPublisher<T, Error>
    
    func doRequest(
        request: URLRequest
    ) -> AnyPublisher<String, Error>
}

class RestClient : RestClientProtocol {
    
    func doRequestJson<T>(request: URLRequest) -> AnyPublisher<T, Error> where T : Decodable {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw RestClientError.failed
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func doRequest(request: URLRequest) -> AnyPublisher<String, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryCompactMap{ data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw RestClientError.failed
                }
            
                return String(decoding: data, as: UTF8.self)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
