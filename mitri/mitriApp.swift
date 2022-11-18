//
//  mitriApp.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 18/11/2022.
//

import SwiftUI

@main
struct mitriApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
