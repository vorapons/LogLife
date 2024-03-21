//
//  ActivitiesView.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 19/3/24.
//

import SwiftUI
import Combine

struct ActivitiesView: View {
    
    @ObservedObject var actViewModel = ActivitiesViewModel()
    @EnvironmentObject var userViewModel : UserViewModel
    
    @State var activitiesString = "..."
    
    var body: some View {
        NavigationView {
            List(self.actViewModel.activities) { activity in
                ActivityCellView(activity: activity)
                    .padding(.vertical, 5)
            }
            .navigationBarTitle("Activities")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        userViewModel.doLogout()
                    }, label: {
                        HStack {
                               Text("Logout")
                                   .fontWeight(.semibold)
                                   .font(.caption)
                           }
                           .padding(5)
                           .foregroundColor(.white)
                           .background(Color(red: 66/255, green: 133/255, blue: 244/255))
                           .cornerRadius(60)
                   }
                    )
                }
            }
        }
        .onAppear {
            self.actViewModel.fetchActivites()
        }
       
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    
    static var previews: some View {
        ActivitiesView().environmentObject(UserViewModel())
    }
}
