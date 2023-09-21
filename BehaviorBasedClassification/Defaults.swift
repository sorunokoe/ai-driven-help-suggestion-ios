//
//  Defaults.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import Foundation


struct Default {
    static let flightModel = FlightModel(fromTime: "06.45",
                                         fromCity: "FRA",
                                         toTime: "07:35",
                                         toCity: "ZRH",
                                         duration: "0h 50m",
                                         operatedCompany: "Air Lines",
                                         price: "199.99", 
                                         checkInState: .available)
}
