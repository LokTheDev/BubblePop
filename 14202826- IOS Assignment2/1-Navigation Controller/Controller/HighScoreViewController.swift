//
//  HighScoreViewController.swift
//  1-Navigation Controller
//
//  Created by Hua Zuo on 7/4/21.
//

import UIKit

class HighScoreViewController: UIViewController {
    //get score label
    
    @IBOutlet weak var scoreName1: UILabel!
    @IBOutlet weak var score1: UILabel!
    
    @IBOutlet weak var scoreName2: UILabel!
    @IBOutlet weak var score2: UILabel!
    
    @IBOutlet weak var scoreName3: UILabel!
    @IBOutlet weak var score3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Retrieve Data From Local Storage
        if let scoreBoard = UserDefaults.standard.dictionary(forKey: "ranking") as! [String : Int]? {
            sortedScore = scoreBoard.sorted(by: {$0.value > $1.value})
            //prevent INDEX out of reach, and assign top three player records to scoreboard. (Can use for each if required dynamic, but not mentioned)
            if(sortedScore.count >= 1 ){
                scoreName1.text =  Array(sortedScore)[0].key
                score1.text = String(Array(sortedScore)[0].value)
                print(sortedScore)

            }
            if(sortedScore.count >= 2 ){
                scoreName2.text =  Array(sortedScore)[1].key
                score2.text = String(Array(sortedScore)[1].value)
            }
            
            if(sortedScore.count >= 3 ){
                scoreName3.text =  Array(sortedScore)[2].key
                score3.text = String(Array(sortedScore)[2].value)
            }
        }
        
    }
    
    
    @IBAction func returnMainPage(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
