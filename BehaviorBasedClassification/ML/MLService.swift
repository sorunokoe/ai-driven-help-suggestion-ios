//
//  MLService.swift
//  BehaviorBasedClassification
//
//  Created by SALGARA, YESKENDIR on 21.09.23.
//

import SwiftUI
import CoreML

final class MLService: ObservableObject {
    
    static let shared = MLService()
    
    private var model: BehaviourClassifier?
    
    @Published var behaviourType: BehaviourAnalyticsService.BehaviourLabel?
    
    private init() {
        let configuration = MLModelConfiguration()
        do {
            self.model = try BehaviourClassifier(configuration: configuration)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func predictBehaviour() {
        guard let model else { return }
        
        let data = BehaviourAnalyticsService.shared.prepareData()
        guard !data.isEmpty else { return }
        
        if let first_page = data["first_page"],
            let first_duration = Double(data["first_duration"]!),
           let second_page = data["second_page"],
           let second_duration = Double(data["second_duration"]!),
           let third_page = data["third_page"],
           let third_duration = Double(data["third_duration"]!),
           let last_page = data["last_page"],
           let last_duration = Double(data["last_duration"]!),
           let home_page_visits = Double(data["home_page_visits"]!),
           let flight_page_visits = Double(data["flight_page_visits"]!),
           let check_in_page_visits = Double(data["check_in_page_visits"]!),
           let successfull_page_visits = Double(data["successfull_page_visits"]!),
           let failure_page_visits = Double(data["failure_page_visits"]!),
           let help_page_visits = Double(data["help_page_visits"]!),
           let check_in_help_visits = Double(data["check_in_help_visits"]!),
           let change_booking_help_visits = Double(data["change_booking_help_visits"]!),
           let cancelation_and_refund_help_visits = Double(data["cancelation_and_refund_help_visits"]!),
           let other_help_visits = Double(data["other_help_visits"]!) {
            do {
                let output = try model.prediction(first_page: first_page,
                                                  first_duration: first_duration,
                                                  second_page: second_page,
                                                  second_duration: second_duration,
                                                  third_page: third_page,
                                                  third_duration: third_duration,
                                                  last_page: last_page,
                                                  last_duration: last_duration,
                                                  home_page_visits: home_page_visits,
                                                  flight_page_visits: flight_page_visits,
                                                  check_in_page_visits: check_in_page_visits,
                                                  successfull_page_visits: successfull_page_visits,
                                                  failure_page_visits: failure_page_visits,
                                                  help_page_visits: help_page_visits,
                                                  check_in_help_visits: check_in_help_visits,
                                                  change_booking_help_visits: change_booking_help_visits,
                                                  cancelation_and_refund_help_visits: cancelation_and_refund_help_visits,
                                                  other_help_visits: other_help_visits)
                behaviourType = BehaviourAnalyticsService.BehaviourLabel(rawValue: Int(output.class_))
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: CoreML: Update model
    
    func updateModel(with label: BehaviourAnalyticsService.BehaviourLabel) {
        let url = Bundle.main.url(forResource: "BehaviourClassifier", withExtension: "mlmodelc")!
        
        let trainingData = getFeatureProvider(with: label)
        
        do {
            let task = try MLUpdateTask(forModelAt: url,
                                        trainingData: trainingData) { updateContext in
                let updatedModel = updateContext.model
                
                let fileManager = FileManager.default
                do {
                    let tempUpdatedModelURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MLTemporary")
                    
                    // Create a directory for the updated model.
                    try fileManager.createDirectory(at: tempUpdatedModelURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                    
                    // Save the updated model to temporary filename.
                    try updatedModel.write(to: tempUpdatedModelURL)
                    
                    // Replace any previously updated model with this one.
                    _ = try fileManager.replaceItemAt(url,
                                                      withItemAt: tempUpdatedModelURL)
                    
                    print("Updated model saved to:\n\t\(url)")
                } catch let error {
                    print("Could not save updated model to the file system: \(error)")
                    return
                }
                
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getFeatureProvider(with label: BehaviourAnalyticsService.BehaviourLabel) -> MLArrayBatchProvider {
        var featureProviders: [MLFeatureProvider] = []

//        let data = BehaviourAnalyticsService.shared.label(label)
//        let dataPoints = Dictionary(uniqueKeysWithValues: data.map { key, value in (key, MLFeatureValue(string: value))})
//        
//        let dataPointFeatures: [String: MLFeatureValue] = dataPoints
//        
//        if let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) {
//            featureProviders.append(provider)
//        }
//        
        return MLArrayBatchProvider(array: featureProviders)
    }
    
}
