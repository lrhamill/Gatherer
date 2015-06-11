//
//  ViewController.swift
//  Gatherer
//
//  Created by Liam Hamill on 04/06/2015.
//  Copyright (c) 2015 Liam Hamill. All rights reserved.
//

import UIKit
import ResearchKit
import CoreData


extension ViewController : ORKTaskViewControllerDelegate {
    

    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
        //Handle results with taskViewController.result
        
        println("Test: \(taskViewController.result)")
        
        switch reason {
        
        case .Completed:
            
            if let resultArray = taskViewController.result.results {
                
                var thisResult = 0
                for item in resultArray {
                    let results = item.results as! [ORKChoiceQuestionResult]
                    
                    if results.count > 0 {
                        if let answer = results[0].choiceAnswers as? [Int] {
                            thisResult += answer[0]
                        }
                    }
                }
                
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("Result", inManagedObjectContext: self.context!) as! Result
                newItem.date = NSDate()
                newItem.surveyResult = thisResult
                
                println("\(newItem.date): \(newItem.surveyResult)")
                
            }

            
        default:
            // Exit without saving
            
            taskViewController.dismissViewControllerAnimated(true, completion: nil)
            return
            
        }
            if let resultArray = taskViewController.result.results {
                
                var thisResult = 0
                for item in resultArray {
                    let results = item.results as! [ORKChoiceQuestionResult]
                    
                    if results.count > 0 {
                        if let answer = results[0].choiceAnswers as? [Int] {
                            thisResult += answer[0]
                        }
                    }
                }
                
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("Result", inManagedObjectContext: self.context!) as! Result
                newItem.date = NSDate()
                newItem.surveyResult = thisResult
                
                println("\(newItem.date): \(newItem.surveyResult)")
                
            }
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

class ViewController: UIViewController {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Result", inManagedObjectContext: self.context!) as! Result
        
        newItem.date = NSDate()
        newItem.surveyResult = 17
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Create a new fetch request
        let fetchRequest = NSFetchRequest(entityName: "Result")
        
        // Cast the results to an array
        if let fetchResults = context!.executeFetchRequest(fetchRequest, error: nil) as? [Result] {
                //TODO: handle saved results
        }
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
    
//    func ViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
//        
//        let taskResult = taskViewController.result
//        
//        println("Test: \(taskResult.results)")
//        //You could do something with the result here
//        
//        taskViewController.dismissViewControllerAnimated(true, completion: nil)
//    }

}

