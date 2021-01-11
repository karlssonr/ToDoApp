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
    
    var taskFromDB : Task?
    var titles = [String]()
    

    let db = Firestore.firestore()
    
    init() {
       
        loadData()
        Encryption.init()
        
        
   
        

    }

    func sortByTitle() {
        
        //var sortedTasks = titles
        //self.titles.sorted()
        
        
        
        //sortedTasks.sort { $0 < $1 }
        self.titles.sort { $0 < $1 }
        print("123", TaskCache.taskCache)
        //print("QQQTasks: ", sortedTasks)
        print("111", self.titles)

    }
    
                
    //Cache function
    func cacheTasks() {
        let taskArray = tasks
        TaskCache.taskCache.setObject(taskArray as NSArray, forKey: "Task")
        print("AAA",self.tasks)
        print("BBB", taskArray)
        

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

                            print("Tasks: " , x)
                            print("Tasks!!!: " , x)
                            self.taskFromDB = x
                            
                            
                            
                            self.titles.append(x.title)
                            

    
                            


                        
                            
                            return x
                            
                        }
                        catch {
                            print(error)
                        }
                        return nil

                    }

                    print("!!! TitlesFromDB: ", self.titles)
                    print("CCC", self.tasks)
                    self.cacheTasks()


                    

                   

                }
                self.sortByTitle()
                print("bög ", self.titles)
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


