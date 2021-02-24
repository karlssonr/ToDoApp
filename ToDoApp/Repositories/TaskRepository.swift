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
        print("before")
        DispatchQueue.main.async {
            self.loadData()
            print("testar", self.loadData())
        }
        print("after")
        Encryption.init()
    }

    func sortByTitle() {
        self.titles.sort { $0 < $1 }
    }
    
    //Cache function
    func cacheTasks() {
        _ = taskFromDB
        let object = TaskHolder.init(tasks: tasks)
        TaskCache.taskCache.setObject(object , forKey: "Task")
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
                self.sortByTitle()
                print("sort ", self.titles)
                let taskFromCache = TaskCache.taskCache.object(forKey: "Task")
                print("4444" , taskFromCache?.tasks)
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


