//
//  AliasAction.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Action with an alias. */
open class AliasAction: NSCoding {

    /** Name of an alias. */
    open let alias: String
    /** Action of this alias. */
    open let action: [String : Any]

    public init(_ alias: String, action: [String : Any]) {
        fatalError("TODO: implement me.")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    public func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }
}
