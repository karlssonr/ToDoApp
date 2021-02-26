//
//  DarkMode.swift
//  ToDoApp
//
//  Created by Magnus Ahlqvist on 2021-02-26.
//
import Foundation
import SwiftUI

struct DarkMode: View {
    
    @State private var darkModeEnabled: Bool = false
    
    var body: some View {
        VStack {
            Toggle(isOn: self.$darkModeEnabled) {
                Text("")
            }.labelsHidden()
            .accessibility(identifier: "darkModeToggle")
            Text(self.darkModeEnabled ? "ON" : "OFF" )
                .accessibility(identifier: "darkModeText")
        }
    }
}

struct DarkMode_Previews: PreviewProvider {
    static var previews: some View {
        DarkMode()
    }
}
