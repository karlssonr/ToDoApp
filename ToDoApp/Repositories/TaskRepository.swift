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
    
    public func enableOffline() {
       let settings = FirestoreSettings()
       settings.isPersistenceEnabled = false
       
       let db = Firestore.firestore()
       db.settings = settings
   }
   
    public func setupCacheSize() {
       let settings = Firestore.firestore().settings
       settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
       Firestore.firestore().settings = settings
   }
    
    let db = Firestore.firestore()
    
    init() {
        enableOffline()
        loadData()
        listenToOffline()
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser?.uid
        
        db.collection("tasks")
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.tasks = querySnapshot.documents.compactMap { document in
                        do {
                            let x = try document.data(as: Task.self)
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
    
    func addTask(_ task: Task) {
        do {
            var addedTask = task
            addedTask.userId = Auth.auth().currentUser?.uid
            
            let _ = try db.collection("tasks").addDocument(from: addedTask)
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
    
    public func listenToOffline() {
        let userId = Auth.auth().currentUser?.uid
            let db = Firestore.firestore()
            // [START listen_to_offline]
            // Listen to metadata updates to receive a server snapshot even if
            // the data is the same as the cached data.
            db.collection("tasks").whereField("userId", isEqualTo: userId)
                .addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("Error retreiving snapshot: \(error!)")
                        return
                    }

                    for diff in snapshot.documentChanges {
                        if diff.type == .added {
                            print("New task: \(diff.document.data())")
                        }
                    }

                    let source = snapshot.metadata.isFromCache ? "local cache" : "server"
                    print("Metadata: Data fetched from \(source)")
            }
    
}

    
}


