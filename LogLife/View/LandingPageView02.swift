//
//  LandingPageView02.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 21/3/24.
//

import SwiftUI

struct LandingPageView02: View {
    var body: some View {
        VStack (alignment: .center){
            
            VStack {
//                Text("Keep You Motivate")
//                    .font(.system(size: 50, weight: .bold,design: .rounded))
                Text("Keep You Motivate")
                    .font(.system(size: 30,weight: .bold,design: .rounded))
                Text("Your emotion, displayed. Log your emotional state after each activity and see how far your body has become.")
                    .multilineTextAlignment(.center)
                    .frame(width:200)
            Image("mobile_example")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(30))
                .frame(width: 200)
                
            }
        }
    }
}

struct LandingPageView02_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView02()
    }
}
