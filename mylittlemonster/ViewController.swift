//
//  ViewController.swift
//  mylittlemonster
//
//  Created by David Clare on 2/18/16.
//  Copyright © 2016 David Clare. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    
    @IBOutlet weak var monsterImg: monsterimg!
    @IBOutlet weak var heroImg: heroimg!
    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    
    @IBOutlet weak var dynamiteImg: DragImg!
    
    
    @IBOutlet weak var penalty1Img: UIImageView!
    
    @IBOutlet weak var penalty2Img: UIImageView!
    
    @IBOutlet weak var penalty3Img: UIImageView!
    
    
    @IBOutlet weak var restartBtn: UIButton!
    
    @IBOutlet weak var gigaLbl: UILabel!
    @IBOutlet weak var golemBtn: UIButton!
    @IBOutlet weak var heroBtn: UIButton!
    
    
    @IBOutlet weak var livesPanelImg: UIImageView!
    
    @IBOutlet weak var livesStackImg: UIStackView!
    
    @IBOutlet weak var attributesStack: UIStackView!
    
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    
    var monsterHappy = false
    var currentItem:UInt32 = 0
    
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxExplosion: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        /*
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        dynamiteImg.dropTarget = monsterImg
        
*/
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do{
            
            let resourcePath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            
            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            try sfxExplosion = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("explosion", ofType: "wav")!))
            
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxExplosion.prepareToPlay()
            
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject){
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        dynamiteImg.alpha = DIM_ALPHA
        dynamiteImg.userInteractionEnabled = false
        
        if currentItem == 0{
            sfxHeart.play()
        }
        else if currentItem == 1
        {
            sfxExplosion.play()
        }
        else
        {
            sfxBite.play()
        }
        
    }
    
    func startTimer()
    {
        if timer != nil{
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState(){
        
        
        
        if !monsterHappy{
            
            
            penalties++
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
                // penalty3Img.alpha = DIM_ALPHA
            }
            else if penalties == 2
            {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            }
            else if penalties >= 3 {
                penalty3Img.alpha = OPAQUE
            }
            else
            {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
            
        }
        
        let rand = arc4random_uniform(3) // 0 1 2
        
        if rand == 0
        {
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
            dynamiteImg.alpha = DIM_ALPHA
            dynamiteImg.userInteractionEnabled = false
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
        }
        else if rand == 1
        {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            dynamiteImg.alpha = OPAQUE
            dynamiteImg.userInteractionEnabled = true
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
        }
        else
        {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            dynamiteImg.alpha = DIM_ALPHA
            dynamiteImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver()
    {
        timer.invalidate()
        
        if heroImg.hidden == true
        {
            sfxDeath.play()
            
            monsterImg.playDeathAnimation()
        }
        else
        {
            sfxDeath.play()
            
            heroImg.playDeathAnimation()
        }
        restartBtn.hidden = false
        
        
    }
    
    func restartGame()
    {
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        penalties = 0
        
        if heroImg.hidden == true{
        
            monsterImg.playIdleAnimation()
        }
        else
        {
            heroImg.playIdleAnimation()
        }
        
        startTimer()
        
        restartBtn.hidden = true
        
        
    }
    
    func revealStacks(){
        livesPanelImg.hidden = false
        livesStackImg.hidden = false
        attributesStack.hidden = false
        
    }
    
   
    @IBAction func onRestartPressed(sender: AnyObject) {
        restartGame()
        
    }

    @IBAction func onHeroPressed(sender: AnyObject) {
        
        
        golemBtn.userInteractionEnabled = false
        golemBtn.hidden = true

        heroBtn.hidden = true
        heroBtn.userInteractionEnabled = true
        
        gigaLbl.hidden = true
        heroImg.hidden = false
        
        backgroundImg.image = UIImage(named: "launchbg.png")
        
        foodImg.dropTarget = heroImg
        heartImg.dropTarget = heroImg
        dynamiteImg.dropTarget = heroImg
        
        startTimer()
        
        
        
        revealStacks()
        
    }

    @IBAction func onGolemPressed(sender: AnyObject) {
        
        heroBtn.userInteractionEnabled = false
        heroBtn.hidden = true
        
        golemBtn.hidden = true
        golemBtn.userInteractionEnabled = true
        
        gigaLbl.hidden = true
        monsterImg.hidden = false
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        dynamiteImg.dropTarget = monsterImg
        startTimer()
        
        
        
        revealStacks()
    }
}

