//
//  Event.swift
//  examplesMail
//
//  Created by Igor Vedeneev on 3/11/20.
//  Copyright © 2020 AGIMA Education. All rights reserved.
//

import SwiftUI
import CoreData
import CoreSpotlight

extension Collection where Element == Mail, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        let csIdentifiers = indices.map { self[$0].timestamp!.description }
        indices.forEach { managedObjectContext.delete(self[$0]) }
 
        do {
            try managedObjectContext.save()
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: csIdentifiers) { (error) in
                print(error)
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension Mail {
    static func create(in managedObjectContext: NSManagedObjectContext, author: String, body: String, subject: String) {
        let newMail = self.init(context: managedObjectContext)
        newMail.timestamp = Date()
        newMail.author = author
        newMail.body = body
        newMail.subject = subject
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
