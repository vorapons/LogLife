//
//  LoginViewModel.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 19/3/24.
//

import Foundation
//import SwiftUI

struct LoginData : Codable {

    let emailAddress : String
    let password : String
}

struct vUser: Codable {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let userId: String
    
    // CodingKeys enum to map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case emailAddress = "emailAddress"
        case userId
    }
}

struct LoginResponse: Codable {
    let message: String
    let status: String
    let user: vUser
}


class LoginViewModel:  ObservableObject {
    
    private static var logLifeLoginURL = "https://api.loglife.guru/login"
    private static var logLifeLogoutURL = "https://api.loglife.guru/logout"
    
    @Published var responseString : String = ""
//    @ObservableObject var userViewModel : UserViewModel
    
    var emailAddress : String = ""
    var password : String = ""
    //    @Published var userDataArray : [UserData]
    
    init() {
        UserDefaults.standard.register(defaults: ["user.first_name" : "",
                                                  "user.last_name" : "",
                                                  "user.emailAddress" : "",
                                                  "user.userId" : "",
                                                  "cookie.expire" : ""    ])
    }
    
    func clearUserData() {
        user_first_name = ""
        user_last_name = ""
        user_emailAddress = ""
        user_userId = ""
        cookie_expire = ""
    }
    
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
                
                DispatchQueue.main.async {
                    self.responseString = dataString
                    print ("got data: \(dataString)")
                    
//                    let userData = self.parseJsonData(data: data)
//                    print("FIRSTFIRSTNAME")
//                    print(userData.first_name)
                    
                    do {
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        print("Message: \(loginResponse.message)")
                        print("Status: \(loginResponse.status)")
                        print("User:")
                        print("First Name: \(loginResponse.user.firstName)")
                        print("Last Name: \(loginResponse.user.lastName)")
                        self.user_first_name = loginResponse.user.firstName
                        self.user_last_name = loginResponse.user.lastName
                        self.user_userId = loginResponse.user.userId
                        self.user_emailAddress = loginResponse.user.emailAddress
                    
//                        self.userViewModel.user_first_name = loginResponse.user.firstName
//                        self.userViewModel.user_last_name = loginResponse.user.lastName
//                        self.userViewModel.user_userId = loginResponse.user.userId
//                        self.userViewModel.user_emailAddress = loginResponse.user.emailAddress
                        
                    }
                    catch {
                        print("Error decoding JSON: \(error)")
                    }
                    
                }
                
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
                        // print("Cookie: \(cookie)")
                        // You can parse the cookie further if needed
                        if cookie.contains("Expires=") {
                            let expiretimeString = String(cookie.dropFirst(8))
                            DispatchQueue.main.async {
                                self.cookie_expire = expiretimeString
//                                self.userViewModel.cookie_expire = expiretimeString
                            }
                        }
                    }
                }
            }
        }
        task.resume()
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
//
//    func parseJsonData(data:Data) -> UserData {
//////        let decoder = JSONDecoder()
//////        var readUserData2 = UserData(from: Decoder())
//////        do {
//////            let readUserData = try decoder.decode( UserData.self,from: data)
//////            readUserData2 = readUserData
//////        } catch {
//////            print(error)
//////        }
////        return readUserData2
//    }
    
}
