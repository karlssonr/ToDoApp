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
    

    let db = Firestore.firestore()
    
    init() {
        //enableOffline()
        loadData()
        sortByTitle()
//        tasks.sort {
//            $0.title < $1.title
//        }
//        print(sortArray(arr: [Task.ID]()))
    }

    func sortByTitle() {
        tasks.sort { $0.title < $1.title }
        print(TaskCache.taskCache)
    }
    
                
    //Cache function
    func cacheTasks() {
        let taskArray = tasks
        TaskCache.taskCache.setObject(taskArray as NSArray, forKey: "Task")
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
        
        
        let userId = Auth.auth().currentUser?.uid

        db.collection("tasks")

            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.tasks = querySnapshot.documents.compactMap { document in
                        do {
                            let x = try document.data(as: Task.self)
                            self.cacheTasks()
                            return x
                        }
                        catch {
                            print(error)
                        }
                        return nil
                    }
                }
            }
    }

    
//
//    func sortTasks(arr: [Task]) -> [Task] {
//
////        var taskArray = arr
////
////
////
////
////        taskArray.locations.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds })
////
////
////        var array = arr
////
////        for _ in 0..<array.count - 1 {
////            for j in 0..<array.count - 1 {
////
////                if (array[j].createdTime > array[j].createdTime) {
////
////                    let temp = array[j]
////                    array[j] = array[j+1]
////                    array[j+1] = temp
////                }
////
////
////
////            }
////        }
//
//
////
////        var swap = true
////
////           while(swap){
////               swap = false
////            for(i in 0 until array.size-1){
////                if(arr[i] > arr[i+1]){
////                       val temp = arr[i]
////                    arr[i] = arr[i+1]
////                       arr[i + 1] = temp
////                    swap = true
////                                }
////                            }
////                        }
////                        return arr
//
//
//    }

    func addTask(_ task: Task) {
//        do {
//            var addedTask = task
//            addedTask.userId = Auth.auth().currentUser?.uid
//
//            let _ = try db.collection("tasks").addDocument(from: addedTask)
//        }
        
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


