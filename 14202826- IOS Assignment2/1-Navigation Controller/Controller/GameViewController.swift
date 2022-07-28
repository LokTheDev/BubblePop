//
//  GameViewController.swift
//  1-Navigation Controller
//
//  Created by Hua Zuo on 7/4/21.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var recordScore: UILabel!
    @IBOutlet weak var comboTag: UILabel!
    var comboTime = 0;
    var comboSize = 20;
    var comboColor: UIColor = .black
    var name: String = "Random Player"
    var remainingTime = 60
    var timer = Timer()
    var userScore: Double = 0
    var previousBubbleValue: Int = 0
    //init a bubble class to obtain bubble number and value
    var bubble = Bubble()
    var bubbleNumber: Int = 10
    var bubbleCount = [Bubble]()
    var bubbleArray = [Bubble]()
    //int score
    var bestRocrd = 0
    var Orientation: UIInterfaceOrientationMask = .portrait
    var timeCounter = 4
    //RandomName for empty Name
    var playerNumber = 1
    
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameLabel.text = name
        remainingTimeLabel.text = String(remainingTime)
        
        
        // active timer, and generate bubble each second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            
            
            timer in
            
            if(self.timeCounter >= 1){
                self.startScreen(timeCount: self.timeCounter);
                self.timeCounter -= 1
            }
            
            if(self.timeCounter == 0){
                self.generateBubble()
                self.counting()
            }
            
        }
        
    }
    
    
    @objc func counting() {
        //Make Sure Record Update even if player didn't press
        if(sortedScore.count >= 1){
            if(Int(userScore) > Array(sortedScore)[0].value){
                bestRocrd = Int(userScore.rounded(.awayFromZero))
                recordScore.text = String(bestRocrd)
                recordScore.shake()
            }else if(Array(sortedScore)[0].value > Int(userScore)){
                recordScore.text = String(Array(sortedScore)[0].value)
            }
        }
        
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        
        //prevent player put 0 as game time
        if(remainingTime < 0){
            timer.invalidate()
            let vc = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
        }
        
        if remainingTime == 0 {
            timer.invalidate()
            
            
            //Add LastScore
            addScore(player: name, score: Int(userScore.rounded(.awayFromZero)))
            //saveHighScore()
            // show HighScore Screen
            let vc = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    @objc func startScreen(timeCount: Int){
        switch timeCount {
        case 4:
            comboTag.text = "3"
            comboTag.font = UIFont.systemFont(ofSize: CGFloat(50))
            comboTag.textColor = .red
            comboTag.shake(2)
        case 3:
            comboTag.text = "2"
            comboTag.font = UIFont.systemFont(ofSize: CGFloat(40))
            comboTag.textColor = .orange
            comboTag.shake(2)
        case 2:
            comboTag.text = "1"
            comboTag.font = UIFont.systemFont(ofSize: CGFloat(30))
            comboTag.textColor = .green
            comboTag.shake(2)
        case 1:
            comboTag.text = ""
        default:
            print("no")
        }
    }
    
    @objc func generateBubble() {
        //In here generate a random number to spawn bubble
        let bubbleSpawnNumber = arc4random_uniform(UInt32(bubbleNumber))
        
        if(bubbleSpawnNumber < bubbleNumber){
            for i in 0...bubbleSpawnNumber{
                bubble = Bubble();
                bubble.frame = CGRect(x:CGFloat(10 + arc4random_uniform(bubble.screenWidth - 150)), y: CGFloat(160 + arc4random_uniform(bubble.screenHeight - 250)), width: 50, height: 50)
                bubble.layer.cornerRadius = 0.5 * bubble.bounds.size.width
                
                if !xyIsValid(bubbleSpawn: bubble) {
                    bubble.addTarget(self, action: #selector(bubblePressed), for: UIControl.Event.touchUpInside)
                    self.view.addSubview(bubble)
                    bubble.animation()
                    bubble.bubbleMove()
                    bubbleNumber = bubbleNumber - 1
                    bubbleArray += [bubble]
                    
                    
                }
            }
        }else{
            print("Run Out Of Bubble: ",bubbleNumber)
        }
        
        
        
    }
    
    //Check New Bubble XY is not repeated, so no overlap
    func xyIsValid(bubbleSpawn: Bubble) -> Bool {
        for currentBubbles in bubbleArray {
            if bubbleSpawn.frame.intersects(currentBubbles.frame) {
                return true
            }
        }
        return false
    }
    
    //Handle Score, and Combo Effect, Also Trigger The Shrink Animation
    @IBAction func bubblePressed(_ sender: Bubble) {
        //Remove Bubble and Calculate Score (Includ same color strike)
        //if bubble.value == previous pressed bubble
        if(previousBubbleValue == sender.bubbleVal){
            //Combo Score Bonus
            userScore += Double(sender.bubbleVal) * 1.5
            //Combo Effect
            comboTime += 1
            comboTag.text = "🔥 Combo Streak! \(comboTime) 🔥"
            comboTag.font = UIFont.systemFont(ofSize: CGFloat(comboSize))
            //odd and even combo time show different effect (text color)
            if(comboTime % 2 == 0){
                comboColor = .red
                comboTag.shake(2)
            }else{
                comboColor = .blue
                comboTag.shake(2)
            }
            comboTag.textColor = comboColor
            comboSize += 5
            print("Bonus Score!")
        }else{
            //No combo, normal score
            userScore += Double(sender.bubbleVal)
            //Reset all Combo Effect Value
            comboTime = 0
            comboSize = 20
            comboColor = .white
            comboTag.text = ""
        }
        //record current value as prev value
        previousBubbleValue = sender.bubbleVal
        //round it up
        scoreLabel.text = String(userScore.rounded(.awayFromZero))
        //allow new bubble appear
        bubbleNumber = bubbleNumber + 1
        //Trigger Animation
        sender.shrink(btn: sender)
        
        
        //only work when no record, assign first gameplay record = highest
        if(sortedScore.count == 0){
            if(Int(userScore) > bestRocrd){
                recordScore.text = String(userScore.rounded(.awayFromZero))
                bestRocrd = Int(userScore.rounded(.awayFromZero))
                recordScore.shake()
            }
        }
        
        //work when records found, if records exist...
        if(sortedScore.count >= 1){
            //if userScore > records best score
            if(Int(userScore) > Array(sortedScore)[0].value){
                bestRocrd = Int(userScore.rounded(.awayFromZero))
                recordScore.text = String(bestRocrd)
                recordScore.shake()
            }else if(Array(sortedScore)[0].value > Int(userScore)){
                recordScore.text = String(Array(sortedScore)[0].value)
            }
        }
        
        
        
    }
    
}


//Extension for UIView item to shake!!
extension UIView {
    func shake(_ duration: Double? = 0.4) {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: duration ?? 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
