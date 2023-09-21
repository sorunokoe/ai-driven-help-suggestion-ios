//
//  FileService.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import Foundation

class FileService {
    
    static func createCSVX(from arr: [String: String]) {
        let columns = ["first_page", "first_duration", "second_page", "second_duration", "third_page", "third_duration", "last_page", "last_duration", "home_page_visits", "flight_page_visits", "check_in_page_visits", "successfull_page_visits", "failure_page_visits", "help_page_visits", "check_in_help_visits", "change_booking_help_visits", "cancelation_and_refund_help_visits", "other_help_visits", "class"]
        let heading = columns.joined(separator: ",") + "\n"
        let rows = columns.map { arr[$0] ?? "-" }.joined(separator: ",")
        let csvString = rows + "\n"
        do {
            
            let path = try FileManager.default.url(for: .documentDirectory,
                                                   in: .allDomainsMask,
                                                   appropriateFor: nil,
                                                   create: false)
            let url = path.appendingPathComponent("behaviour.csv")
            
//            let url = Bundle.main.url(forResource: "behaviour", withExtension: "csv")!
            print(url)
            
            var initial = (try? String(contentsOf: url)) ?? ""
            if initial.isEmpty {
                initial.append(contentsOf: heading)
            }
            initial.append(contentsOf: csvString)
            try initial.write(to: url, atomically: true , encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
