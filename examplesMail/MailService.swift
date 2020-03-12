//
//  MailService.swift
//  examplesMail
//
//  Created by Igor Vedeneev on 3/12/20.
//  Copyright © 2020 AGIMA Education. All rights reserved.
//

import CoreData
import CoreSpotlight
import MobileCoreServices

final class MailService {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
    }
    
    func startIndex() {
        let fetchRequest = NSFetchRequest<Mail>(entityName: "Mail")
        guard let results = try? context.fetch(fetchRequest) else { return }
        print(results)
        
        csIndex(mails: results)
    }
    
    func delete(mails: [Mail]) {
        let csIdentifiers = mails.map { $0.objectID.description }
        mails.forEach { [unowned self] in
            self.context.delete($0)
        }
        
        do {
            try context.save()
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: csIdentifiers) { (error) in
                print(error)
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful  during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func add(author: String, body: String, subject: String) {
        let newMail = Mail(context: context)
        newMail.timestamp = Date()
        newMail.author = author
        newMail.body = body
        newMail.subject = subject
        newMail.id = UUID().uuidString
        
        do {
            try context.save()
            csIndex(mail: newMail)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func mailCsSearchableItem(mail: Mail) -> CSSearchableItem {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeEmailMessage as String)
        attributeSet.title = mail.author
        attributeSet.contentDescription = mail.body

        return CSSearchableItem(uniqueIdentifier: mail.timestamp!.description, domainIdentifier: "ru.agima.mail", attributeSet: attributeSet)
    }
    
    func csIndex(mails: [Mail]) {
        let items = mails.map(mailCsSearchableItem)
        
        CSSearchableIndex.default().indexSearchableItems(items) { (error) in
            print(error)
        }
    }
    
    func csIndex(mail: Mail) {
        csIndex(mails: [mail])
    }
}
