//
//  MailListCell.swift
//  examplesMail
//
//  Created by Igor Vedeneev on 3/11/20.
//  Copyright © 2020 AGIMA Education. All rights reserved.
//

import SwiftUI

struct MailListCell: View {
    
    @ObservedObject var mail: Mail
    
    var body: some View {
        VStack {
            HStack {
                Text(mail.author!)
                Text(mail.timestamp!.description)
            }
            
            Text(mail.subject!)
            Text(mail.body!)
        }
    }
    
}
