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
        println(taskViewController.result)
        taskViewController.result
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

class ViewController: UIViewController {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    @IBAction func surveyTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    }

    @IBAction func consentTapped(sender : AnyObject) {
        var userConsent = ConsentTask
        let taskViewController = ORKTaskViewController(task: userConsent, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    }

}

