//
//  ContentView.swift
//  ToDoApp
//
//  Created by robin karlsson on 2020-11-25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var taskListVM = TodoListViewModel()
    
    let tasks = testDataTasks
    
    @State var presentAddNewItem = false
    
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(taskListVM.taskCellViewModels) { taskCellVM in
                        TaskCell(taskCellVM: taskCellVM)
                    }
                    if presentAddNewItem {
                        TaskCell(taskCellVM: TodoCellViewModel(task: Task( title: "", completed: false))) { task in
                            self.taskListVM.addTask(task: task)
                            self.presentAddNewItem.toggle()
                            
                        }
                    }
                }
                
                Button(action: { self.presentAddNewItem.toggle()}) {
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20,height: 20)
                        
                        Text("Add New Task")
                    }
                    
                }
                .padding()
                
                
            }
            .navigationBarTitle("Tasks")
        }
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct TaskCell: View {
        
        @ObservedObject var taskCellVM: TodoCellViewModel
        
        var onCommit: (Task) -> (Void) = { _ in }
        
        
        var body: some View {
            HStack {
                Image(systemName: taskCellVM.task.completed ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 20,height: 20)
                    .onTapGesture {
                        self.taskCellVM.task.completed.toggle()
                    }
                TextField("Enter the task title", text: $taskCellVM.task.title, onCommit: {
                    self.onCommit(self.taskCellVM.task)
                })
            }
        }
    }
    
}
