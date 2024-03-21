//
//  ContentView.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 17/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var userVM = UserViewModel()
    
    var body: some View {
        if( self.userVM.isLoggedIn ) {
            ActivitiesView().environmentObject(userVM)
        } else {
            MainView().environmentObject(userVM)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
