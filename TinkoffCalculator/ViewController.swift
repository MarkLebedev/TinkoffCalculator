//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by lebedev on 2/19/24.
//

import UIKit

enum CalculationError: Error {
    case dividedByZero
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case divide = "/"
    case multiply = "x"
    
    func calculate (_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add: return number1 + number2
        case .substract: return number1 - number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        case .multiply: return number1 * number2
        }
    }
}

enum historyItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {

    var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        
        return formatter
    }()

    var history: [historyItem] = []
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        if label.text == "Error" {
            label.text = "0"
        }
        
        if buttonText == "," && label.text!.contains(",") { return }
        
        if label.text != "0" || buttonText == "," {
            label.text?.append(buttonText)
            return
        } else {
            label.text = buttonText
            return
        }
        
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard
            let buttonText = sender.currentTitle,
            let operation = Operation(rawValue: buttonText)
        else { return }
            
        guard
            let numberText = label.text,
            let number = formatter.number(from: numberText)?.doubleValue
        else { return }
        
        history.append(.number(number))
        history.append(.operation(operation))
        
        label.text = "0"
    }
    
    @IBAction func clearButtonPressed() {
        label.text = "0"
        history.removeAll()
    }
    
    @IBAction func equalsButtonPressed(_ sender: UIButton) {
        guard
            sender.currentTitle != nil
        else { return }
            
        guard
            let numberText = label.text,
            let number = formatter.number(from: numberText)?.doubleValue
        else { return }
        
        history.append(.number(number))
        
        do {
            let result = try calculate()
            
            label.text = formatter.string(from: NSNumber(value: result))
        } catch {
            print ("error caught")
            label.text = "Error"
        }
        
        history.removeAll()
    }
    
    func calculate() throws -> Double {
        guard
            case .number(var result) = history[0]
        else { return 0 }
        
        for i in stride(from: 1, through: history.count - 1, by: 2) {
            guard
                case .operation(let operation) = history[i],
                case .number(let number) = history[i+1]
            else { break }
            
            result = try operation.calculate(result, number)
        }
        
        return result
    }
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = "0"
    }
    

}

