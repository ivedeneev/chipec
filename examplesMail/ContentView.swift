//
//  ContentView.swift
//  examplesMail
//
//  Created by Igor Vedeneev on 3/11/20.
//  Copyright © 2020 AGIMA Education. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    
    @State var presentingModal = false
 
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text("AGIMA Mail"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { Mail.create(in: self.viewContext, author: "Igor Vedeneev", body: UUID().uuidString) }
//                            self.presentingModal = true
                        }
                    ) { 
                        Image(systemName: "plus")
                    }
                )
            Text("Detail view content goes here")
                .navigationBarTitle(Text("Detail"))
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        .sheet(isPresented: $presentingModal) { ModalView(presentedAsModal: self.$presentingModal) }
    }
}

struct MasterView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Mail.timestamp, ascending: true)],
        animation: .default)
    var mailList: FetchedResults<Mail>

    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        List {
            ForEach(mailList, id: \.self) { mail in
                NavigationLink(
                    destination: DetailView(mail: mail)
                ) {
                    MailListCell(mail: mail)
                }
            }.onDelete { indices in
                self.mailList.delete(at: indices, from: self.viewContext)
            }
        }
    }
}

struct DetailView: View {
    @ObservedObject var mail: Mail

    var body: some View {
        Text("\(mail.timestamp!, formatter: dateFormatter)")
            .navigationBarTitle(Text("Detail"))
    }
}

struct ModalView: View {
    @Binding var presentedAsModal: Bool
    var body: some View {
        Button("dismiss") { self.presentedAsModal = false }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
