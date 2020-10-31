//
//  Dictionary+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import Foundation

public extension Dictionary where Key: Hashable, Value: Any {
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

public extension Dictionary where Key: RawRepresentable, Key.RawValue: Hashable {
    
    func convertedToRawValues() -> [Key.RawValue: Value] {
        return self.reduce([:]) { (resultSoFar, pair) -> [Key.RawValue: Value] in
            let (key, value) = pair
            var resultSoFar = resultSoFar
            resultSoFar[key.rawValue] = value
            return resultSoFar
        }
    }
}
