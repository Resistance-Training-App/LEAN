//
//  RemoveDuplicateMetrics.swift
//  WatchWorkoutPlanner Extension
//
//  Remove duplicated metrics objects from the motion manager.
//

import Foundation
import CoreData

func removeDuplicateMetrics(motion: MotionManager, viewContext: NSManagedObjectContext) {

    for metricArray in motion.metrics {
        for metric in metricArray {
            viewContext.delete(metric)
        }
    }

    motion.metrics.removeAll()

    do { try viewContext.save() } catch {
        print(error.localizedDescription)
    }
    PersistenceController.shared.save()
}
