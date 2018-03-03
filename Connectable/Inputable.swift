//
//  Inputable.swift
//  Connectable
//
//  Created by Atsushi Miyake on 2018/03/03.
//  Copyright © 2018年 Atsushi Miyake. All rights reserved.
//

import Foundation

public struct InputSpace<Definer> {
    let definer: Definer
    init(_ definer: Definer) {
        self.definer = definer
    }
}

public protocol Inputable {
    static var `in`: InputSpace<Self>.Type { get }
    var `in`: InputSpace<Self> { get }
}

extension Inputable {
    
    public static var `in`: InputSpace<Self>.Type {
        return InputSpace<Self>.self
    }
    
    public var `in`: InputSpace<Self> {
        return InputSpace(self)
    }
}
