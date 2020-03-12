//
//  ContentView.swift
//  examplesMail
//
//  Created by Igor Vedeneev on 3/11/20.
//  Copyright © 2020 AGIMA Education. All rights reserved.
//

import SwiftUI

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()

let bodies = ["Пацы, когда во двор пойдем играть?", "Ребят, в следующий раз лучше не записывайтесь, если примерно понимаете, что не пойдёте", "Если вы уже похоронили Фотошоп в эпоху Инстаграма и быстрых фоторедакторов — не спешите. Уметь фотошопить — один из 2-3 навыков, которые легко освоить и тут же начать зарабатывать.\n\nНа биржах — куча заказов даже для тех, кто занимается несколько недель. Людям нужны логотипы, баннеры, шаблоны — без работы не останется никто, даже если ещё вчера вы не знали, как работает пипетка."]

let authors = ["Igor Vedeneev", "Макcим Калиниченко", "Юдаев Виктор", "Василий Удалов"]

let subjects = ["Футбольчик", "Обучение photoshop"]

struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    
    var service: MailService
    
    @State var presentingModal = false
 
    var body: some View {
        NavigationView {
            MasterView(service: service)
                .navigationBarTitle(Text("AGIMA Mail"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { self.service.add(author: authors.randomElement()!, body: bodies.randomElement()!, subject: subjects.randomElement()!) }
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
    
    
    var service: MailService
    
    var body: some View {
        List {
            ForEach(mailList, id: \.self) { mail in
                NavigationLink(
                    destination: DetailView(mail: mail)
                ) {
                    MailListCell(mail: mail)
                }
            }.onDelete { indices in
//                self.mailList.delete(at: indices, from: self.viewContext)
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
        return ContentView(service: MailService.init(context: context)).environment(\.managedObjectContext, context)
    }
}
