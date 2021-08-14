//
//  PersonDataApp.swift
//  PersonData
//
//  Created by Jan Hovland on 14/08/2021.
//

import SwiftUI

@main
struct PersonDataApp: App {
    var body: some Scene {
        WindowGroup {
            PersonData()
                .environmentObject(ViewModelPerson())
        }
    }
}
