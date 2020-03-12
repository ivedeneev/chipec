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
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(mail.author!)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                Spacer()
                Text("\(mail.timestamp!, formatter: dateFormatter)")
                    .font(.system(size: 13, weight: .regular, design: .default))
                    .foregroundColor(.gray)
            }
            
            Text(mail.subject!)
                .font(.system(size: 15, weight: .regular, design: .default))
            Text(mail.body!)
                .lineLimit(2)
                .font(.system(size: 15, weight: .regular, design: .default))
                .foregroundColor(.gray)
        }
    }
}
