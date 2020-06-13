//
//  QuestionViewController.swift
//  QuizEmoji
//
//  Created by Роман Захаров on 13.06.2020.
//  Copyright © 2020 Роман Захаров. All rights reserved.
//

import UIKit
/* Шаблон структуры класса

MARK: перед классом перечисления и структуры
 
MARK: IBOutlets - аутлеты
MARK: Public properties - публичные переменные и константы
MARK: Private properties - приватные переменные и константы
MARK: Initializers - инициализаторы класса
MARK: Override Methods - переопределенные методы
 MARK: Life Cycles Methods  - отдельные типы переопределенных методов
 MARK: Navigation - переопределяемые методы для навигации
  Если же вы работаете с вью контроллером, то переопределенные методы идут сразу после свойств класса
MARK: IBActions - методы связанные с пользовательским интерфейсом
MARK: Public Methods - публичные методы класса
MARK: Private Methods - приватные методы класса
MARK: Extensions после класса
 
*/

class QuestionViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var questionEmojiTextStackView: UIStackView!
    @IBOutlet weak var answersBattonsStackView: UIStackView!
    
    @IBOutlet weak var questionEmojiLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    
    @IBOutlet var answersButtons: [UIButton]!
    
    @IBOutlet weak var answerTextLabel: UILabel!
    
    // MARK: - Public properties
    var level = Level.one
    var category = Category.auto
    // заменить когда будет вызов
    //var level: Level!
    //var category: Category!
    
    //MARK: - Private properties
    private var questions = [Question]()
    private var questionIndex = 0
    private var currentQuestion: Question?
    private var answersChoosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    private var currentAnswer: Answer?
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        questions = Question.getQuestions(level: level, category: category)
        //currentQuestion = questions.first!
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("\(level.rawValue) \(category.rawValue)")
        //navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem?.title = "Прервать"
        showCurrentQuestion()
    }
    
    // MARK: - IB Actions
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        guard let answerIndex = answersButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[answerIndex]
        answersChoosen.append(currentAnswer)
        showCurrentAnswer(with: currentAnswer)
    }
    
    @IBAction func nextQuestionBarButtonItem(_ sender: UIBarButtonItem) {
        nextQuestion()
    }
}


    


//    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
//        guard let answerIndex = answersButtons.firstIndex(of: sender) else { return }
//        let currentAnswer = currentAnswers[answerIndex]
//        answersChoosen.append(currentAnswer)
//        nextQuestion()
//    }
//
//    @IBAction func multipleAnswerButtonPressed() {
//        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
//            if multipleSwitch.isOn {
//                answersChoosen.append(answer)
//            }
//        }
//
//        nextQuestion()
//    }
//
//    @IBAction func rangedAnswerButtonPressed() {
//        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
//        let currentAnswer = currentAnswers[index]
//        answersChoosen.append(currentAnswer)
//        nextQuestion()
//    }
//
//    deinit {
//        print("QuestionsViewController was been dealocated")
//    }

// MARK: - Private Methods
extension QuestionViewController {
    
    private func showCurrentQuestion() {
        // Hide everything in Answer
        for item in [answerTextLabel] {
            item?.isHidden = true
        }
        for item in [questionEmojiTextStackView, answersBattonsStackView] {
            item?.isHidden = false
        }
        // Get current question and
        currentQuestion = questions[questionIndex]
        //currentAnswers = currentQuestion.answers
            
        // Set current question UI
        questionEmojiLabel.text = currentQuestion?.emoji
        questionTextLabel.text = currentQuestion?.text

        // Calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)

        // Set progress for progress view
        progressView.setProgress(totalProgress, animated: true)

        // Set navigation title
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"

        showAnswersButtons(with: currentAnswers)
    }
    
    private func showCurrentAnswer(with currentAnswer: Answer) {
        // Hide everything in Question
        for item in [questionEmojiTextStackView, answersBattonsStackView] {
            item?.isHidden = true
        }
        answerTextLabel.isHidden = false
        answerTextLabel.text = currentAnswer.text
    }
    
    private func showAnswersButtons(with answers: [Answer]) {

        for (button, answer) in zip(answersButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
//        multipleStackView.isHidden = false
//
//        for (label, answer) in zip(multipleLabels, answers) {
//            label.text = answer.text
//        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
//        rangedStackView.isHidden = false
//
//        rangedLabels.first?.text = answers.first?.text
//        rangedLabels.last?.text = answers.last?.text
    }
}

// MARK: - Navigation
extension QuestionViewController {
    
    private func nextQuestion() {
        questionIndex += 1
        if questionIndex < questions.count {
            showCurrentQuestion()
        } else {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "resultSegue" else { return }
        let resultViewController = segue.destination as! ResultViewController
        resultViewController.result = "Здесь должен быть результат"
    }
    
}
