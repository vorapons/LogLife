//
//  LoginView.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 19/3/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    @ObservedObject var viewModel = LoginViewModel()
    @ObservedObject var viewModel2 = ActivitiesViewModel()
//    @ObservedObject var userViewModel : UserViewModel
    
    var body: some View {
        VStack {
            Image("loglife_logo_jpg")
            Text(viewModel.user_first_name)
            Text(viewModel.user_last_name)
            Text(viewModel.user_emailAddress)
//            Text(userViewModel.user_first_name)
//            Text(userViewModel.user_last_name)
//            Text(userViewModel.user_emailAddress)
            
            VStack {
                FormField(fieldName: "Email", fieldValue: $viewModel.emailAddress)
                    .padding()
                FormField( fieldName: "Password", fieldValue:  $viewModel.password, isSecure: true)
                    .padding()
                Button {
                    viewModel.doLogin()
                } label: {
                    Text("Login")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color(red: 66/255, green: 133/255, blue: 244/255))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                Button {
                    viewModel.doLogout()
                } label: {
                    Text("Logout")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color(red: 66/255, green: 133/255, blue: 244/255))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                }
                Text(viewModel.responseString)
                Button {
                    viewModel2.fetchActivites()
                } label: {
                    Text("Fetch")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color(red: 66/255, green: 133/255, blue: 244/255))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                }
                Text(viewModel2.activitiesString)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct FormField : View {
    var fieldName = ""
    @Binding var fieldValue : String
    var isSecure = false
    
    var body : some View {
        VStack {
            if isSecure {
                SecureField( fieldName, text : $fieldValue )
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .padding(.horizontal)
            } else {
                TextField( fieldName, text: $fieldValue)
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .padding(.horizontal)
            }
            Divider()
                .frame(height:1)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                .padding(.horizontal)
        }
    }
    
}

// MARK: Convert Strings
extension String {
    /// convert string in http url
    public var asUrl: URL {
        let urlStr = self.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlStr) else {
            return URL.init(fileURLWithPath:  "")
        }
        return url
    }
}
