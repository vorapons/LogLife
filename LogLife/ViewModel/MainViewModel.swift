//
//  MainViewModel.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 19/3/24.
//

import Foundation
//{emailAddress: "vorapon_s@hotmail.com", password: "asdfasdf"}
// ...


class MainViewModel:  ObservableObject {
    
    private static var logLifeLoginURL = "https://api.loglife.guru/login"
    private static var logLifeFetchActURL = "https://api.loglife.guru/v2/activities/user/me?type=&sort=&take=10"
        
    @Published var responseString : String = ""
    @Published var activitiesString : String = ""
    
    enum CodingKeys: CodingKey {
        case loans
    }
    
    
    init() {
        
    }
    
    func doLogin() {
        guard let loglifeUrl = URL(string : Self.logLifeLoginURL) else {
            return
        }
        
        let login = LoginData(emailAddress: "vorapon_s@hotmail.com", password: "asdfasdf")
        guard let uploadData = try? JSONEncoder().encode(login) else {
            return
        }
        
        var request = URLRequest(url: loglifeUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                self.responseString = dataString
                print ("got data: \(dataString)")
                
                // Check if the response is an HTTPURLResponse
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }

                // Access cookies from the response
                if let allCookies = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                    // Split the cookies string if there are multiple cookies
                    let cookies = allCookies.components(separatedBy: "; ")

                    // Print each cookie
                    for cookie in cookies {
                        print("Cookie: \(cookie)")
                        // You can parse the cookie further if needed
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchActivites() {
        guard let loglifeUrl = URL(string : Self.logLifeFetchActURL) else {
            return
        }
        
        var request = URLRequest(url: loglifeUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                self.activitiesString = dataString
                print ("got data: \(dataString)")
            }
        }
        task.resume()
    }
    
//    APIManager.shared.fetchProducts { response in
//                switch response {
//                case .success(let products):
//                    self.products = products
//                case .failue(let error):
//                    print(error)
//                }
//            }
    
//    func parseJsonData(data:Data) -> [Loan] {
//        let decoder = JSONDecoder()
//
//        do {
//            let loanStore = try decoder.decode(LoanStore.self,from: data)
//            self.loans = loanStore.loans
//        } catch {
//            print(error)
//        }
//        return loans
//    }
    
    
}
