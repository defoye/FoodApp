//
//  Firestore+Extension.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/1/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension CollectionReference {
    
    func getDocuments<T: Decodable>(_ type: T.Type, _ completion: @escaping (QuerySnapshot?) -> Void) {
        self.getDocuments { (snapshot, error) in
            if let error = error {
                print("[CollectionReference] - \(error.localizedDescription)")
            }
            
            completion(snapshot)
        }
    }
    
    func getDocuments(_ completion: @escaping (QuerySnapshot?) -> Void) {
        self.getDocuments { (snapshot, error) in
            if let error = error {
                print("[CollectionReference] - \(error.localizedDescription)")
            }
                        
            completion(snapshot)
        }
    }
    
    func getDocument(_ documentPath: String, _ completion: @escaping (DocumentSnapshot?) -> Void) {
        self.document(documentPath).getDocument { (snapshot, error) in
            if let error = error {
                print("[CollectionReference] - \(error.localizedDescription)")
            }
            
            completion(snapshot)
        }
    }
}

extension Firestore {
    func getDecodedCollectionDocumentsPaginated<T: Decodable>(_ collection: FirebaseCollection, _ type: T.Type, limit: Int, _ completion: @escaping ([T]) -> Void) {
        self.collection(collection.rawValue)
            .limit(to: limit)
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print(error.debugDescription)
                    return
                }

                guard let lastSnapshot = snapshot.documents.last else {
                    // The collection is empty.
                    return
                }

                // Construct a new query starting after this document
                let next = self.collection(collection.rawValue)
                    .start(afterDocument: lastSnapshot)

                // Use the query for pagination.
                // ...
                
                let models = snapshot.documents.compactMap { snapshot -> T? in
                    snapshot.data().decodedJSON(T.self)
                }
                
                completion(models)
            }
            
    }
    func getDecodedCollectionDocuments<T: Decodable>(_ collection: FirebaseCollection, _ type: T.Type, _ completion: @escaping ([T]) -> Void) {
    
        self.collection(collection.rawValue).getDocuments { snapshot in
            guard let snapshot = snapshot else {
                return
            }
            
            let models = snapshot.documents.compactMap { snapshot -> T? in
                snapshot.data().decodedJSON(T.self)
            }
            
            completion(models)
        }
    }
    
    func getDecodedCollectionDocument<T: Decodable>(_ collection: FirebaseCollection, documentPath: String, _ type: T.Type, _ completion: @escaping (T?) -> Void) {
        
        self.collection(collection.rawValue).getDocument(documentPath) { snapshot in
            guard let snapshot = snapshot else {
                return
            }
            
            let model = snapshot.data()?.decodedJSON(T.self)
            
            completion(model)
        }
    }
}
