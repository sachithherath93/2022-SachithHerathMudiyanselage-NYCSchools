//
//  NetworkManager.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

/*
Sources -
https://data.cityofnewyork.us/Education/2017-DOE-High-School-Directory/s3k6-pzi2 (2017 DOE List of High Schools)
https://data.cityofnewyork.us/Education/2012-SAT-Results/f9bf-2cp4 (2012 SAT results by high school)
*/

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum SchoolAPIError: Error {
    case urlError
    case requestError
    case responseError
    case dataError
}

typealias schoolListCompletion = ([School]?, SchoolAPIError?) -> Void
typealias schoolSATCompletion = ([SchoolSAT]?, SchoolAPIError?) -> Void

struct NetworkManager {
    func executeSchoolListRequest(completion: @escaping schoolListCompletion) {
        guard let request = createRequest(urlString: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json") else {
            completion(nil, .urlError)
            return
        }
        executeRequest(request: request, onCompletion: completion)
    }
    
    func executeSchoolSATRequest(schoolId: String, completion: @escaping schoolSATCompletion) {
        guard let request = createRequest(urlString: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?dbn=\(schoolId)") else {
            completion(nil, .urlError)
            return
        }
        executeRequest(request: request, onCompletion: completion)
    }
    
    private func executeRequest<T: Codable>(request: URLRequest, onCompletion: @escaping ([T]?, SchoolAPIError?) -> Void) {
        // Didn't use alamofire, used url session instead
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = SchoolsConstants.Timeouts.timeout
        sessionConfiguration.timeoutIntervalForResource = SchoolsConstants.Timeouts.timeout
        let dataTask = URLSession(configuration: sessionConfiguration).dataTask(with: request) { data, response, error in
            guard error == nil else {
                onCompletion(nil, .requestError)
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                onCompletion(nil, .responseError)
                return
            }
            
            guard let data = data else {
                onCompletion(nil, .dataError)
                return
            }
            
            do {
                let responseArray = try JSONDecoder().decode([T].self, from: data)
                // Bring back to the main thread since the datatask call backs run in the background
                DispatchQueue.main.async {
                    onCompletion(responseArray, nil)
                }
                // onCompletion(responseArray, nil)
            } catch {
                onCompletion(nil, .dataError)
                return
            }
        }
        dataTask.resume()
    }
    
    // In case other types of requests come along later. put/ delete etc. Also if we need to adjust the request headers in future
    private func createRequest(urlString: String, method: HTTPMethod = .get) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
