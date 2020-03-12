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
        
        let items = results.map { mail -> CSSearchableItem in
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeEmailMessage as String)
            attributeSet.title = mail.author
            attributeSet.contentDescription = mail.body

            return CSSearchableItem(uniqueIdentifier: mail.timestamp!.description, domainIdentifier: "ru.agima.mail", attributeSet: attributeSet)
        }
        
        CSSearchableIndex.default().indexSearchableItems(items) { (error) in
            print(error)
        }
    }
    
    func delete(mail: Mail) {
        
    }
}
