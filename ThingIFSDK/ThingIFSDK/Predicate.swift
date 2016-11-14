//
//  Predicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 4/25/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

/** Protocol represents Predicate */
public protocol Predicate :  NSCoding {


    /** Get Predicate as NSDictionary instance

     - Returns: a NSDictionary instance
     */
    func toNSDictionary() -> NSDictionary

    /** Event source of this predicate.

     See `EventSource`
     */
    var eventSource: EventSource { get }
}


