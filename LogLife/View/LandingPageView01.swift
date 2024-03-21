//
//  LandingPageView01.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 21/3/24.
//

import SwiftUI

struct LandingPageView01: View {
    var body: some View {
        VStack (alignment: .center){
            Image("walk")
                .resizable()
                .scaledToFit()
                .frame(width:300)
            VStack {
                Text("LogLife")
                    .font(.system(size: 50, weight: .bold,design: .rounded))
                Text("Log Your Active Life")
                    .font(.system(size: 20,weight: .bold,design: .rounded))
                Text("Finished your active session? Let’s log your progress with LogLife. Fast and easy you will be amazed!")
                    .multilineTextAlignment(.center)
                
            }
        }
    }
}

struct LandingPageView01_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView01()
    }
}
