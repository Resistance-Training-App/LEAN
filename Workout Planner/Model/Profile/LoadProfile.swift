//
//  LoadProfile.swift
//  Workout Planner
//
//  Loads an existing profile object or creates a new one if none exist.
//

import Foundation
import CoreData

func loadProfile(viewContext: NSManagedObjectContext) -> Profile {

    let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

    do {
        let profile = try viewContext.fetch(fetchRequest) as [Profile]
        
        // Clean up unnecessary profiles (temporary).
        for profile in profile {
            if (profile.creationDate == nil || profile.creationDate == Date.distantPast) {
                viewContext.delete(profile)
            }
            
        }
    
        do { try viewContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
        
        // Profile found.
        if (!profile.isEmpty &&
            profile.first?.creationDate != Date.distantPast &&
            profile.first?.creationDate != nil) {

            return profile.first!
            
        // Create new profile.
        } else {
            let newProfile = Profile(context: viewContext)
            newProfile.statistics = Statistics(context: viewContext)
            newProfile.creationDate = Date()

            do { try viewContext.save() } catch {
                print(error.localizedDescription)
            }
            PersistenceController.shared.save()
            return newProfile
        }
    } catch let error {
        print("error FetchRequest \(error)")
    }

    return Profile.init()
}
