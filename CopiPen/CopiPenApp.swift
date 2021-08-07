//
//  CopiPenApp.swift
//  CopiPen
//
//  Created by 廣瀬雄大 on 2021/08/07.
//

import SwiftUI

@main
struct CopiPenApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
