//
//  SchedulePredicate.swift
//  ThingIFSDK
//
//  Created by syahRiza on 5/10/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation

/** Class represents SchedulePredicate. */
open class SchedulePredicate: NSObject, Predicate {
    /** Specified schedule. (cron tab format) */
    open let schedule: String

    open let eventSource: EventSource = EventSource.schedule

    /** Instantiate new SchedulePredicate.

     -Parameter schedule: Specify schedule. (cron tab format)
     */
    public init(_ schedule: String) {
        self.schedule = schedule
    }

    public required init?(coder aDecoder: NSCoder) {
        self.schedule = aDecoder.decodeObject(forKey: "schedule") as! String;

    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.schedule, forKey: "schedule");
    }

}
