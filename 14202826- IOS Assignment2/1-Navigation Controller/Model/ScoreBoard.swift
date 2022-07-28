//
//  ScoreBoard.swift
//  1-Navigation Controller
//
//  Created by Lok on 21/4/22.
//

import Foundation

var scoreBoard = [String : Int]()
var sortedScore = [(key: String, value: Int)]()

func addScore(player: String, score: Int){
    
    scoreBoard.updateValue(Int(score), forKey: "\(player)")
        UserDefaults.standard.set(scoreBoard, forKey: "ranking")

}

