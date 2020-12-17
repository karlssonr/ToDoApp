//
//  ContentView.swift
//  ToDoApp
//
//  Created by robin karlsson on 2020-11-25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var taskListVM = TaskListViewModel()
    
    
    let tasks = testDataTasks
    
    @State var presentAddNewItem = false
    
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(taskListVM.taskCellViewModels) { taskCellVM in
                        TaskCell(taskCellVM: taskCellVM)
                    }.onDelete(perform: { indexSet in
                        
                        delete()
                        
                    })
                    if presentAddNewItem {
                        TaskCell(taskCellVM: TaskCellViewModel(task: Task( title: "", completed: false))) { task in
                            self.taskListVM.addTask(task: task)
                            self.presentAddNewItem.toggle()
                            
                        }
                    }
                }.navigationBarItems(trailing: EditButton())
                
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
    
    func delete() {
        TaskRepository.deleteTask()
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct TaskCell: View {
        
        @ObservedObject var taskCellVM: TaskCellViewModel
        
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