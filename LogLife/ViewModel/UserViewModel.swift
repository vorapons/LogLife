//
//  UserViewModel.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 21/3/24.
//

import Foundation
import Combine


class UserViewModel:  ObservableObject {

    @Published var user_first_name : String = (UserDefaults.standard.string(forKey:"user.first_name") ?? "") {
        didSet{
            UserDefaults.standard.set( user_first_name, forKey: "user.first_name")
        }
    }
    @Published var user_last_name : String = (UserDefaults.standard.string(forKey:"user.last_name") ?? "") {
        didSet{
            UserDefaults.standard.set( user_last_name, forKey: "user.last_name")
        }
    }
    @Published var user_emailAddress : String = (UserDefaults.standard.string(forKey:"user.emailAddress") ?? "") {
        didSet{
            UserDefaults.standard.set( user_emailAddress, forKey: "user.emailAddress")
        }
    }
    @Published var user_userId : String = (UserDefaults.standard.string(forKey:"user.userId") ?? "") {
        didSet{
            UserDefaults.standard.set( user_userId, forKey: "user.userId")
        }
    }
    @Published var cookie_expire : String = (UserDefaults.standard.string(forKey:"cookie.expire") ?? "") {
        didSet{
            UserDefaults.standard.set( cookie_expire, forKey: "cookie.expire")
        }
    }
    
    @Published var isLoggedIn = false
    
    private static var logLifeLogoutURL = "https://api.loglife.guru/logout"
    
    @Published var responseString : String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        UserDefaults.standard.register(defaults: ["user.first_name" : "",
                                                  "user.last_name" : "",
                                                  "user.emailAddress" : "",
                                                  "user.userId" : "",
                                                  "cookie.expire" : ""    ])
        Publishers.CombineLatest($user_userId, $cookie_expire)
                    .receive(on: RunLoop.main)
                    .map { (user_userId, cookie_expire) in
                        return (user_userId != "") && (cookie_expire != "")
                    }
                    .assign(to: \.isLoggedIn, on: self)
                    .store(in: &cancellableSet)
    }
    
    func doLogout() {
        guard let loglifeUrl = URL(string : Self.logLifeLogoutURL) else {
            return
        }
        
        var request = URLRequest(url: loglifeUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.clearUserData()
        
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
                self.responseString = dataString
                print ("got data: \(dataString)")
                
                self.clearUserData()
                
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
    
    func clearUserData() {
        user_first_name = ""
        user_last_name = ""
        user_emailAddress = ""
        user_userId = ""
        cookie_expire = ""
    }
    
    
}
