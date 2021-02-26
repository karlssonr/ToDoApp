//
//  TaskRepository.swift
//  ToDoApp
//
//  Created by robin karlsson on 2020-12-16.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TaskRepository: ObservableObject {
    
    @Published var tasks = [Task]()
    @Published var tasksFromCache = [Task]()
    
    var taskFromDB : Task?
    var titles = [String]()
    
    var bubbleSortArray = [31, 2 ,65 ,5 ,4 ,3 , 8 ,9 ,12, 14 ,21 ]
    
    let db = Firestore.firestore()
    
    init() {
        print("bubbleSortArray Before: " ,bubbleSortArray)
        DispatchQueue.main.async {
            self.loadData()
            print("ladda data", self.loadData())
        }
        Encryption.init()
        bubbleSort(array: &bubbleSortArray)
        print("bubbleSortArray After: " ,bubbleSortArray)
    }
    
    func bubbleSort(array: inout [Int]) -> [Int] {
        var isSorted = false
        var counter = 0
        
        while !isSorted {
            isSorted = true
            for i in 0..<array.count - 1 - counter {
                if array[i] > array[i + 1] {
                    array.swapAt(i, i + 1)
                    isSorted = false
                }
            }
            counter = counter + 1
        }
        return array
    }
    
    //Cache function
    func cacheTasks() {
        
        let object = TaskHolder.init(tasks: tasks)
        TaskCache.taskCache.setObject(object , forKey: "Task")
        
    }
    
    
    //Turn off Firestore cache
    func enableOffline() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        
        let db = Firestore.firestore()
        db.settings = settings
    }
    
    
    //Cache size
    func cacheSize() {
        let settings = Firestore.firestore().settings
        settings.cacheSizeBytes = 100
        Firestore.firestore().settings = settings
    }
    
    
    func loadData() {
        
        self.titles.removeAll()
        
        let userId = Auth.auth().currentUser?.uid
        
        
        db.collection("tasks")
            
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.tasks = querySnapshot.documents.compactMap { document in
                        do {
                            guard let x = try document.data(as: Task.self) else {return nil}
                            self.taskFromDB = x
                            self.titles.append(x.title)
                            
                            
                            return x
                            
                        }
                        catch {
                            print(error)
                        }
                        return nil
                        
                    }
                    
                    
                    
                }
                self.cacheTasks()
                
                print("sort ", self.titles)
                
                if let taskFromCache = TaskCache.taskCache.object(forKey: "Task") {
                    
                    self.tasksFromCache.append(contentsOf: taskFromCache.tasks)
                }
                print("TaskFromCache:  " , self.tasksFromCache)
                
                
                
                
                
                
                
                
                
            }
        
        
        
    }
    
    
    
    func addTask(_ task: Task) {
        
        do {
            var addedTask = task
            addedTask.userId = Auth.auth().currentUser?.uid
            
            let _ = try! db.collection("tasks").addDocument(from: addedTask)
        }
        
        do {
            cacheTasks()
        }
        catch {
            fatalError("Unable to add task: \(error.localizedDescription)")
        }
    }
    
    func updateTask(_ task: Task) {
        if let taskID = task.id {
            do {
                try db.collection("tasks").document(taskID).setData(from: task)
            }
            catch {
                fatalError("Unable to add task: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTask(task: Task) {
        if let taskID = task.id {
            db.collection("tasks").document(taskID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                }
                else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
}


