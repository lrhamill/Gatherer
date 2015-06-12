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
        
        
        switch reason {
        
        case .Completed:
            
            
            // If the user has come from the consent form, end without saving.
            println(consented)
            if !consented {
                consented = true
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
    
    var consented = false
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("ConsentStatus", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                
                consented = dict["Consented"] as! Bool
                
            }
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !consented {
            
            launchConsent()
            
        }
        
        // Create a new fetch request
        let fetchRequest = NSFetchRequest(entityName: "Result")
        
        // Cast the results to an array
        if let fetchResults = context!.executeFetchRequest(fetchRequest, error: nil) as? [Result] {
                //TODO: handle saved results
        }
    }
    
    func launchConsent() {
        
        var userConsent = ConsentTask
        let taskViewController = ORKTaskViewController(task: userConsent, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)

    }
    
    
    @IBAction func surveyTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    }

    @IBAction func withdrawTapped(sender : AnyObject) {
        consented = false
        launchConsent()
    }


}

