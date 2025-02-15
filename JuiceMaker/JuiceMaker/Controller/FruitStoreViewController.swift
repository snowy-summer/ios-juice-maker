//
//  FruitStoreViewController.swift
//  JuiceMaker
//
//  Created by 최승범 on 2023/09/14.
//

import UIKit

final class FruitStoreViewController: UIViewController {
    weak var fruitStore: FruitStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configStepperAndLabel()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
   
    @IBOutlet weak var storeStrawberryLabel: UILabel!
    
    @IBOutlet weak var storeBananaLabel: UILabel!
    
    @IBOutlet weak var storePineappleLabel: UILabel!
    
    @IBOutlet weak var storeKiwiLabel: UILabel!
    
    @IBOutlet weak var storeMangoLabel: UILabel!
    
    
    //MARK: - Stepper
    @IBOutlet weak var strawberryStepper: UIStepper!
    
    @IBOutlet weak var bananaStepper: UIStepper!
    
    @IBOutlet weak var pineappleStepper: UIStepper!
    
    @IBOutlet weak var kiwiStepper: UIStepper!
    
    @IBOutlet weak var mangoStepper: UIStepper!
    
    @IBAction func goToJuiceMakerView(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func fruitStockStepper(_ sender: UIStepper) {
        do {
            guard let stepperTag = StepperTag(rawValue: sender.tag) else { return }
            
            guard let fruitStore = fruitStore else { return }
            
            guard let fruit = fruitStore.fruitList.filter({$0.name == stepperTag.fruitName}).first else { return }
            
    
            try fruitStore.addFruitStock(inputFruit: fruit, count: Int(sender.value))
            
            try updateUI()
            
        } catch {
            showingSystemAlert(error: error)
        }
    }
    
}


//MARK: - Method
extension FruitStoreViewController {
    
    private func initStepper() throws {
        guard let fruitStore = fruitStore else {throw MessageLog.ErrorCase.failedOptionalBinding}
        
        strawberryStepper.value = Double(try fruitStore.takeFruitStock(fruitName: "딸기"))
        bananaStepper.value = Double(try fruitStore.takeFruitStock(fruitName: "바나나"))
        pineappleStepper.value = Double(try fruitStore.takeFruitStock(fruitName: "파인애플"))
        kiwiStepper.value = Double(try fruitStore.takeFruitStock(fruitName: "키위"))
        mangoStepper.value = Double(try fruitStore.takeFruitStock(fruitName: "망고"))
    }
    
    private func updateUI() throws {
        guard let fruitStore = fruitStore else {throw MessageLog.ErrorCase.failedOptionalBinding}
        
        storeStrawberryLabel.text = String(try fruitStore.takeFruitStock(fruitName: "딸기"))
        storeBananaLabel.text = String(try fruitStore.takeFruitStock(fruitName: "바나나"))
        storePineappleLabel.text = String(try fruitStore.takeFruitStock(fruitName: "파인애플"))
        storeKiwiLabel.text = String(try fruitStore.takeFruitStock(fruitName: "키위"))
        storeMangoLabel.text = String(try fruitStore.takeFruitStock(fruitName: "망고"))
    }
    
  
    
    private func configStepperAndLabel() {
        do {
            try initStepper()
            try updateUI()
        } catch {
            showingSystemAlert(error: error)
        }
    }
    
    
    //MARK: - Alert
    private func showingSystemAlert(error: Error) {
        let systemAlert =  UIAlertController(title: nil, message: "\(error))", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        systemAlert.addAction(confirmAction)
        
        present(systemAlert, animated: true)
    }
}

extension FruitStoreViewController {
    
    private enum StepperTag: Int {
        case strawberryStepperTag = 0
        case bananaStepperTag = 1
        case pineappleStepperTag = 2
        case kiwiStepperTag = 3
        case mangoStepperTag = 4
        
        var fruitName: String {
            switch self {
            case .strawberryStepperTag:
                return "딸기"
            case .bananaStepperTag:
                return "바나나"
            case .pineappleStepperTag:
                return "파인애플"
            case .kiwiStepperTag:
                return "키위"
            case .mangoStepperTag:
                return "망고"
            }
        }
        
    }
}
