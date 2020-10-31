//
//  Array+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import Foundation

public extension Array {
    struct CurrPrevPair {
        let curr: Element
        let prev: Element
    }
    
    func currPrevPairArray() -> [CurrPrevPair] {
        let z = zip(self.dropFirst(), self.dropLast())
        
        return z.map { (pair) -> CurrPrevPair in
            return CurrPrevPair(curr: pair.0, prev: pair.1)
        }
    }
    
    func currPrevPairIterator() -> IndexingIterator<[Array.CurrPrevPair]> {
        IndexingIterator(_elements: currPrevPairArray())
    }
}
