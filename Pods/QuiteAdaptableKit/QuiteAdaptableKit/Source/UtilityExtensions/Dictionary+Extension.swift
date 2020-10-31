//
//  Dictionary+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import Foundation

extension Dictionary where Key: Hashable, Value: Any {
    func decodedJSON<T: Decodable>(_ type: T.Type) -> T? {
        let jsonData = self
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            return decodedData
        } catch {
            print("[Dictionary+Extension] - decodedJSON<T: Decodable>(:) - \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func merged(with dict: [Key: Value]) -> [Key: Value] {
        var newDict: [Key: Value] = [:]
        
        dict.forEach { (key, value) in
            newDict[key] = value
        }
        self.forEach { (key, value) in
            newDict[key] = value
        }
        
        return newDict
    }
}
