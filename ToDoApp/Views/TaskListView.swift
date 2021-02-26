//
//  ContentView.swift
//  ToDoApp
//
//  Created by robin karlsson on 2020-11-25.
//

import SwiftUI
import FirebaseFirestore


struct TaskListView: View {
    
    @ObservedObject var taskListVM = TaskListViewModel()
    
    @State var presentAddNewItem = false
    @State var showCachedTasks = false
    
    
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(taskListVM.taskCellViewModels) { taskCellVM in
                        TaskCell(taskCellVM: taskCellVM)
                    }.onDelete(perform: { indexSet in
                        
                        
                    })
                    
                    
                    
                    
                    if presentAddNewItem {
                        
                        TaskCell(taskCellVM: TaskCellViewModel(task: Task( title: "", completed: false))) { task in
                            self.taskListVM.addTask(task: task)
                            self.presentAddNewItem.toggle()
                            
                        }
                    }
                    
                    
                }.navigationBarItems(trailing: EditButton())
                
                if showCachedTasks {
                    List {
                        ForEach(taskListVM.taskCellViewModelsFromCache) { taskCellVM in
                            TaskCell(taskCellVM: taskCellVM)
                        }
                    }}
                
                Button(action: {
                    
                    self.showCachedTasks.toggle()
                    
                }) {
                    
                    Text("Toggle CachedTasks")
                    
                }
                
                Button(action: { self.presentAddNewItem.toggle()
                }) {
                    
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20,height: 20)
                        
                        Text("Add New Task")
                    }
                    
                    
                }
                .accessibility(identifier: "addTaskButton")
                .padding()
                
                
            }
            .navigationBarTitle("Tasks")
        }
        
    }
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            TaskListView()
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
                        
                    }.accessibility(identifier: "checkMarkTask")
                TextField("Enter the task title", text: $taskCellVM.task.title, onCommit: {
                    
                    self.onCommit(self.taskCellVM.task)
                    print("nu skapades den")
                })
                .accessibility(identifier: "taskNameTextField")
            }
        }
    }
    
    
    
    
}
