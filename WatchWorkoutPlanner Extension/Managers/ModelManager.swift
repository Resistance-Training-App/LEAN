//
//  ModelManager.swift
//  Form Identifier
//
//  Manages all motion models and static model variables.
//

import Foundation
import CoreML

// Model selection
enum Model: String, Equatable, CaseIterable {
    case BicepCurl = "Bicep Curl"
    case LateralRaise = "Lateral Raise"
    case ShoulderPress = "Shoulder Press"
    case Exercise = "Exercise"
}

// The axis from which reps will be counted.
enum RepCountingAxis: String, Equatable, CaseIterable {
    case DMGravX, DMGravY, DMGravZ
}

class ModelManager: ObservableObject {

    static let frequency: Int = 40
    static let predictionWindowSize: Int = frequency * 4
    static let predictionWindowOverlap: Int = predictionWindowSize / 2
    static let sensorsUpdateFrequency = 1.0 / Double(frequency)
    
    @Published var selectedModel: Model = .BicepCurl
    @Published var repCountingAxis: RepCountingAxis = .DMGravX
    
    // Bicep curl model
    let bicepCurl: BicepCurl = {
        do {
            let config = MLModelConfiguration()
            return try BicepCurl(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create BicepCurl Model.")
        }
    }()
    
    // Lateral raise model
    let lateralRaise: LateralRaise = {
        do {
            let config = MLModelConfiguration()
            return try LateralRaise(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create LateralRaise Model.")
        }
    }()
    
    // Shoulder press model
    let shoudlerPress: ShoulderPress = {
        do {
            let config = MLModelConfiguration()
            return try ShoulderPress(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create ShoulderPress Model.")
        }
    }()
    
    // Exercise model
    let exercises: Exercises = {
        do {
            let config = MLModelConfiguration()
            return try Exercises(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create Exercise Model.")
        }
    }()
    
    // Predict the type of bicep curl form or 'other' motion.
    func bicepCurlPrediction(input: BicepCurlInput) -> (Dictionary<String, Double>, String)? {

        guard let modelPrediction = try? bicepCurl.prediction(input: input)
        else { fatalError("BicepCurl Model Error") }
        
        // Return the predicted activity
        return (modelPrediction.classProbability, modelPrediction.activity)
    }

    // Predict the type of lateral raise form or 'other' motion.
    func lateralRaisePrediction(input: LateralRaiseInput) -> (Dictionary<String, Double>, String)? {

        guard let modelPrediction = try? lateralRaise.prediction(input: input)
        else { fatalError("LateralRaise Model Error") }
        
        // Return the predicted activity
        return (modelPrediction.classProbability, modelPrediction.activity)
    }
    
    // Predict the type of shoulder press form or 'other' motion.
    func shoudlerPressPrediction(input: ShoulderPressInput) -> (Dictionary<String, Double>, String)? {

        guard let modelPrediction = try? shoudlerPress.prediction(input: input)
        else { fatalError("ShoudlerPress Model Error") }
        
        // Return the predicted activity
        return (modelPrediction.classProbability, modelPrediction.activity)
    }
    
    // Predict the type of exercise form or 'other' motion.
    func exercisesPrediction(input: ExercisesInput) -> (Dictionary<String, Double>, String)? {

        guard let modelPrediction = try? exercises.prediction(input: input)
        else { fatalError("Exercise Model Error") }
        
        // Return the predicted activity
        return (modelPrediction.classProbability, modelPrediction.activity)
    }
}

// Extension used to be able to change the current selected model.
extension ModelManager : Identifiable {

    struct Template {
        var selectedModel: Model = .BicepCurl
    }

    var template: Template {
        return Template(selectedModel: selectedModel)
    }
    
    func update(from template: Template) {
        self.selectedModel = template.selectedModel
    }
}
