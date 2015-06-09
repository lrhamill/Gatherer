//
//  ViewController.swift
//  Gatherer
//
//  Created by Liam Hamill on 04/06/2015.
//  Copyright (c) 2015 Liam Hamill. All rights reserved.
//

import UIKit
import ResearchKit

extension ViewController : ORKTaskViewControllerDelegate {
    
    
    
    
    
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        //Handle results with taskViewController.result
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

class ViewController: UIViewController {
    
    
    

    @IBAction func consentTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    }

}

