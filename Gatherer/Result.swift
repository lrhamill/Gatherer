//
//  Result.swift
//  Gatherer
//
//  Created by Liam Hamill on 11/06/2015.
//  Copyright (c) 2015 Liam Hamill. All rights reserved.
//

import Foundation
import CoreData

class Result: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var surveyResult: NSNumber

}
