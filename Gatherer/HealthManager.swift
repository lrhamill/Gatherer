//
//  HealthManager.swift
//  Gatherer
//
//  Created by Liam Hamill on 16/06/2015.
//  Copyright (c) 2015 Liam Hamill. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    
    let store: HKHealthStore = HKHealthStore()

    func authoriseHK(completion: ((success:Bool, error:NSError!) -> Void)!) {
        

        if !HKHealthStore.isHealthDataAvailable() {
            
            let error = NSError(domain: "com.lrhamill.gatherer", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
            
        }
        
        store.requestAuthorizationToShareTypes(nil, readTypes: Set(arrayLiteral: [HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)])) { (success, error) -> Void in
            
            if( completion != nil )
            {
                completion(success:success,error:error)
            }
        }
        

    }
}