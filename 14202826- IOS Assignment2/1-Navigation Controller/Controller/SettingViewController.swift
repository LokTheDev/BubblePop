//
//  BlueViewController.swift
//  1-Navigation Controller
//
//  Created by Hua Zuo on 7/4/21.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var BubbleSlider: UISlider!
    //display Number
    @IBOutlet weak var bubbleTag: UILabel!
    @IBOutlet weak var TimeTag: UILabel!
    @IBOutlet weak var orientationLabel: UILabel!
    var playerNumber = 1
    override func viewDidLoad() {
        //ensure slider start from correct number
        timeSlider.value = 30
        BubbleSlider.value = 10
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    //Lock Screen Orientation by toggling Switch
    var mode: UIInterfaceOrientationMask = .portrait
    
    @IBAction func orientationSwitch(_ sender: UISwitch) {
        //if switch is toggle, lock screen landscape if it's landscape
        if(sender.isOn){
            mode = .landscape
            orientationLabel.text = "Landscape"
            viewWillAppear(true)
            UIViewController.attemptRotationToDeviceOrientation()
            
        }else{
            mode = .portrait
            orientationLabel.text = "Portrait"
            viewWillAppear(true)
            UIViewController.attemptRotationToDeviceOrientation()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = mode
    }
    
    
    //Show TimeSlider value in TimeTag Label.
    @IBAction func timeSet(_ sender: UISlider) {
        TimeTag.text = String(timeSlider.value.rounded(.awayFromZero))
        
        if(timeSlider.value == 0){
            TimeTag.text = "You Can't Play with 0 Second!!"
        }
    }
    
    //Show BubbleSlider value in BubbleTag Label.
    @IBAction func bubbleSet(_ sender: UISlider) {
        bubbleTag.text = String(BubbleSlider.value.rounded())
        if(BubbleSlider.value == 0){
            BubbleSlider.value = 0
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let VC = segue.destination as! GameViewController
            VC.name = nameTextField.text!
            VC.remainingTime = Int(timeSlider.value)
            //Add value to control bubble number
            VC.bubbleNumber = Int(BubbleSlider.value)
            //Lock GameView Screen when Game Started
            VC.Orientation = mode
        }
        
        
    }
    
}
