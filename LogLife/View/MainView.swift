//
//  MainView.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 21/3/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    @State var isLoginViewPresent : Bool = false
    
    let yExtension: CGFloat = 50
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("loglife_logo_jpg")
                    .resizable()
                    .frame(width: 180,height:70)
                Button( action: {
                       self.isLoginViewPresent = true
                   }, label: {
                        HStack {
                               Text("Login")
                                   .fontWeight(.semibold)
                                   .font(.body)
                           }
                           .padding()
                           .foregroundColor(.white)
                           .background(Color(red: 66/255, green: 133/255, blue: 244/255))
                           .cornerRadius(80)
                   })
            }
            .padding()
            .sheet(isPresented: $isLoginViewPresent) {
                LoginView().environmentObject(userViewModel)
            }
//            Spacer()
//            Spacer()
            
            ZStack {
                   GeometryReader { gp in
                    TabView {
                        LandingPageView01()
                            .tabItem { Text("01")}
                            .id("001")
                        LandingPageView02()
                            .tabItem { Text("02")}
                            .id("002")
                    }
                    .id( UUID())
                    .frame(width: gp.size.width, height: gp.size.height + yExtension)
                            // Bug fix for TabView EdgeIgnore not working
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                   }
                   .offset(y: -yExtension) // Bug fix for TabView EdgeIgnore not working
                   .edgesIgnoringSafeArea(.all)
            }
//            .animation(.easeInOut(duration: 1.0))
            .edgesIgnoringSafeArea(.all)
            
        }
    }
        
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserViewModel())
    }
}
