//
//  TaskCellViewModel.swift
//  ToDoApp
//
//  Created by robin karlsson on 2020-11-26.
//

import Foundation
import Combine

class TaskCellViewModel: ObservableObject, Identifiable {
    
   @Published var todoRepository = TodoRepository()
   @Published var task: Todo
    
    var id = ""
    @Published var completionStateIconName = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(task: Todo) {
        
        self.task = task
        
        $task
            .map { task in
                task.completed ? "ckeckmark.circle.fill" : "circle"
            }
            .assign(to: \.completionStateIconName, on: self)
            .store(in: &cancellables)
        
        $task
            .compactMap { task in
                task.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $task
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { task in
                self.todoRepository.updateTask(task)
            }
            .store(in: &cancellables)
    }
}
