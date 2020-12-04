//
//  Task.swift
//  ToDoApp
//
//  Created by robin karlsson on 2020-11-25.
//

import Foundation

struct Task: Identifiable {
    var id : String = UUID().uuidString
    var title: String
    var completed: Bool
    
}

#if DEBUG
let testDataTasks = [
    Task(title: "Implement the UI", completed: true),
    Task(title: "Connect to Firebase", completed: false),
    Task(title: "?????", completed: false),
    Task(title: "Profit!!", completed: false)
    
]
#endif
