//
//  mitriApp.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 18/11/2022.
//

import SwiftUI
import GoogleSignIn

@main
struct mitriApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            BaseView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
