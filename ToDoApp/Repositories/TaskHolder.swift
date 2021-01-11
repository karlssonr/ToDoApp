//
//  TaskHolder.swift
//  ToDoApp
//
//  Created by robin karlsson on 2021-01-11.
//

import Foundation

class TaskHolder: NSObject {
    var tasks : [Task]
    
    init (tasks: [Task]) {
        self.tasks = tasks
    }
}
