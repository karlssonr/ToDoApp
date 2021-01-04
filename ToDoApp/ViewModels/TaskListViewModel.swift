//
//  TaskListViewModel.swift
//  ToDoApp
//
//  Created by robin karlsson on 2020-11-26.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    
    @Published var taskRepository = TaskRepository()
    @Published var taskCellViewModels = [TaskCellViewModel]()
    //let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
       // if reachabilityManager!.isReachable {
            taskRepository.$tasks.map { tasks in
                tasks.map { task in
                    TaskCellViewModel(task: task)
                }
            }
            .assign(to: \.taskCellViewModels, on: self)
            .store(in: &cancellables)

    //    }

    }
    
    
    func addTask(task: Task) {
        taskRepository.addTask(task)


    }
    
    func deleteTask(task: Task) {
        taskRepository.deleteTask(task: task)


    }
}
