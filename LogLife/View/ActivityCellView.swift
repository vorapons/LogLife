//
//  ContentView.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 21/3/24.
//

import SwiftUI

struct ActivityCellView: View {
    
    var activity : Activity
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(activity.title)
                    .font(.system(.headline, design: .rounded))
                    .bold()
                Text(activity.date)
                    .font(.system(.subheadline, design: .rounded))
                Text(activity.type)
                    .font(.system(.body, design: .rounded))
                Text(activity.barometer)
                    .font(.system(.body, design: .rounded))
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct ActivityCellView_Previews: PreviewProvider {
//    var example_loan =
    static var previews: some View {
        ActivityCellView(activity: Activity(id: "ASDFASDF",title: "Title", description: "Description", type: "Running", startTime: "11:00", endTime: "12:00", date: "Today", duration: Duration(hour: 10, minute: 11), barometer: "good")
                        
        )
    }
}
