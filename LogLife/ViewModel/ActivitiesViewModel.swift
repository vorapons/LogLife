//
//  ActivitiesViewModel.swift
//  LogLife
//
//  Created by Vorapon Sirimahatham on 19/3/24.
//

import Foundation


struct Activity: Codable, Identifiable{
    let id: String // Conforming to Identifiable
    let title: String
    let description: String
    let type: String
    let startTime: String
    let endTime: String
    let date: String
    let duration: Duration
    let barometer: String
//    let activityId: String
    
    enum CodingKeys: String, CodingKey {
            case id = "activityId" // Mapping activityId to id
            case title, description, type, startTime, endTime, date, duration, barometer
        }
}

struct Duration: Codable {
    let hour: Int
    let minute: Int
}

class ActivitiesViewModel:  ObservableObject {
    
    private static var logLifeFetchActURL = "https://api.loglife.guru/v2/activities/user/me?type=&sort=&take=10"
        
    @Published var activitiesString : String = ""

    @Published var activities: [Activity] = []
    
    
    init() {
        
    }
    
    func fetchActivites() {
        guard let loglifeUrl = URL(string : Self.logLifeFetchActURL) else {
            return
        }
        
        var request = URLRequest(url: loglifeUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Start Fetch")
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
//                self.activitiesString = dataString
                print ("got data: \(dataString)")
                do {
                    let activitiesData = try JSONDecoder().decode([Activity].self, from: data)
                    self.activities = activitiesData
                    for activity in activitiesData {
                        print("Title: \(activity.title)")
                        print("Description: \(activity.description)")
                        print("Type: \(activity.type)")
                        print("Start Time: \(activity.startTime)")
                        print("End Time: \(activity.endTime)")
                        print("Date: \(activity.date)")
                        print("Duration: \(activity.duration.hour) hours \(activity.duration.minute) minutes")
                        print("Barometer: \(activity.barometer)")
                        print("Activity ID: \(activity.id)")
                        print("------")
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
        task.resume()
    }
    
}
