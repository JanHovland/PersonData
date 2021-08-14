//
//  PersonData.swift
//  PersonData
//
//  Created by Jan Hovland on 14/08/2021.
//

import SwiftUI

@MainActor
struct PersonData: View {
    
    @EnvironmentObject var vm: ViewModelPerson
    
    var body: some View {
        Text("Hello from Persondata now.")
            .padding()
        
            .task() {
                do {
                    try await vm.deleteLastPerson()
                } catch {
                    print(error.localizedDescription)
                }
//                do {
//                    try await vm.savePerson()
//                } catch {
//                    print(error.localizedDescription)
//                }
            }
    }
}

