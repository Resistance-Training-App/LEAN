//
//  RemoveDuplicateMetricsTests.swift
//  WatchWorkoutPlannerTests
//

import XCTest
@testable import WatchWorkoutPlanner_Extension
import CoreData

class RemoveDuplicateMetricsTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!

    var metrics: Metrics!

    var motionManager: MotionManager!

    override func setUpWithError() throws {
        try super.setUpWithError()

        coreDataStack = TestCoreDataStack()
        
        metrics = Metrics.init(context: coreDataStack.testContext)
        
        motionManager = MotionManager.init()
        motionManager.metrics = [[metrics, metrics], [metrics, metrics]]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
        metrics = nil
        motionManager = nil
    }

    func testRemoveDuplicateMetrics() throws {
        
        removeDuplicateMetrics(motion: motionManager, viewContext: coreDataStack.testContext)
        
        let metrics = try coreDataStack.testContext.fetch(Metrics.fetchRequest())

        XCTAssertTrue(motionManager.metrics.isEmpty)
        XCTAssertTrue(metrics.isEmpty)
    }
}
