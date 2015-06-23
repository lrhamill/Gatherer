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
            
            
            // If the user has come from the consent form, update consent info & HK authentication
            if !consented {
                consented = true
                
                taskViewController.dismissViewControllerAnimated(true, completion: authHealthkit)
                return

            }

            
        
            // Otherwise, if the user has come from the survey task,
            // save the results using Core Data
            
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
                taskViewController.dismissViewControllerAnimated(true, completion: nil)
                
            }

            
        default:
            // Exit without saving
            
            taskViewController.dismissViewControllerAnimated(true, completion: nil)
            return
            
        }
        
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var HKCheck: UILabel!
    
    var manager = HealthManager()
    
    var consented = false {
        didSet {
            
            println("Consented: \(consented)")
            
            // Save changes to consented status
            
            if let path = NSBundle.mainBundle().pathForResource("ConsentStatus", ofType: "plist") {
                    if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, Bool> {
                        
                        var newDict = dict
                        newDict["Consented"] = consented
                        
                        ([newDict] as NSArray).writeToFile(path, atomically: false)
                        println("Saved successfully.")
                    
                    
                }
            }
        }
    }
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    func authHealthkit() {
        
        let authStatus = manager.store.authorizationStatusForType(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning))
        
        switch authStatus {
        case .SharingAuthorized:
            HKCheck.text = "Welcome. When you are ready, tap on the survey button."
            return
            
        case .NotDetermined:
            println("Not determined")
            
            println("Trying to authorise...")
            manager.authoriseHK { (success,  error) -> Void in
                
                if success {
                    self.HKCheck.text = "Welcome. When you are ready, tap on the survey button."
                    return
                }
                else {
                    println("HealthKit authorization denied!")
                        var HKwarning = UIAlertController(title: "HealthKit Authorisation", message: "You must authorise HealthKit to continue.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        HKwarning.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                        
                        self.presentViewController(HKwarning, animated: true, completion: nil)
                        self.HKCheck.text = "You must authorize HealthKit before you can take a survey."
                
                }
            }
            
        case .SharingDenied:
            println("Denied")
            self.HKCheck.text = "You must authorize HealthKit before you can take a survey."
            return
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HKCheck.lineBreakMode = .ByWordWrapping
        HKCheck.numberOfLines = 0
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let path = NSBundle.mainBundle().pathForResource("ConsentStatus", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                
                let plist = dict["Consented"] as! Bool
                println("plist says: \(plist)")
                
                consented = dict["Consented"] as! Bool
                
            }
        }
        
        if !consented {
            
            println(consented)
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
        
        println("Launch consent: \(consented)")
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
        
        var warning = UIAlertController(title: "Withdrawing consent", message: "Are you sure you want to withdraw from the study?", preferredStyle: UIAlertControllerStyle.Alert)
        
        warning.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        
        warning.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                self.consented = false
                self.launchConsent()
        
            default:
                println("cancel")

            }
        }))
        
        self.presentViewController(warning, animated: true, completion: nil)

    }


}

