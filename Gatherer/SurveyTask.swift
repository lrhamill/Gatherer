//
//  SurveyTask.swift
//  
//
//  Created by Liam Hamill on 09/06/2015.
//
//

import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Survey"
    instructionStep.text = "Please honestly answer the following questions about your feelings over the past week. Remember that your responses are anonymous."
    
    steps += [instructionStep]
    
    let weeklyNegativeAnswers = [
        ORKTextChoice(text:"Rarely or None of the Time", value: 4),
        ORKTextChoice(text:"Some or a Little of the Time", value: 3),
        ORKTextChoice(text:"Occasionally or a Moderate Amount of the Time", value: 2),
        ORKTextChoice(text:"Most or All of the Time", value: 1),
    ]
    
    let weeklyPositiveAnswers = [
        ORKTextChoice(text:"Rarely or None of the Time", value: 1),
        ORKTextChoice(text:"Some or a Little of the Time", value: 2),
        ORKTextChoice(text:"Occasionally or a Moderate Amount of the Time", value: 3),
        ORKTextChoice(text:"Most or All of the Time", value: 4),
    ]
    
    let negativeAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: weeklyNegativeAnswers)
    
    let positiveAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: weeklyPositiveAnswers)
    
    
    let weeklyQuestions = [
        
        ORKQuestionStep(identifier: "Survey Question", title: "I was bothered by things that don't usually bother me.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I did not feel like eating; my appetite was poor.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I felt that I could not shake off the blues even with help from my family and friends.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I felt that I was just as good as other people.", answer: positiveAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I had trouble keeping my mind on what I was doing.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I felt depressed.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I felt that everything I did was an effort.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I felt hopeful about the future.", answer: positiveAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I thought my life had been a failure.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I felt fearful.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "My sleep was restless.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I was happy.", answer:positiveAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I talked less than usual.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I felt lonely.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "People were unfriendly.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I enjoyed life.", answer: positiveAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I had crying spells.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I felt sad.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I felt that people dislike me.", answer: negativeAnswerFormat),
        ORKQuestionStep(identifier: "Survey Question", title: "I I could not get 'going'.", answer: negativeAnswerFormat),
        
    ]
    
    // Add questions to survey in a randomised order
    
    var indexArray = [Int]()
    indexArray += 0...19
    
    while indexArray.count > 0 {
        
        let rand = Int(arc4random_uniform(UInt32(indexArray.count)))
        let index = indexArray.removeAtIndex(rand)
        
        steps += [weeklyQuestions[index]]
        
    }
    
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Thank You"
    summaryStep.text = "Thank you for completing this week's survey. Remember to come back next week."
    steps += [summaryStep]
    
    
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}