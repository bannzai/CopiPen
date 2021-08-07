//
//  CopiPenApp.swift
//  CopiPen
//
//  Created by 廣瀬雄大 on 2021/08/07.
//

import SwiftUI

@main
struct CopiPenApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PasteboardContentListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
