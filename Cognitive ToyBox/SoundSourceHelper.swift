//
//  SoundSourceHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/7/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import SpriteKit
import AVFoundation

/* helper class finding sound file */
public class SoundSourceHelper: NSObject, ConfigurableSoundSourceHelper, AVAudioPlayerDelegate {
  
  private class InterruptibleAVAudioPlayer: AVAudioPlayer {
    var interrupt = false
    var shouldPlay = true
    var shouldRecoverBGM = true
    
    func doVolumeFade (completion: () -> () = {}) {
      if self.shouldPlay {
        return
      }
      
      if self.volume > 0.1 {
        self.volume -= 0.1
        let delay = 0.1 * Double(NSEC_PER_SEC)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay)), dispatch_get_main_queue()) {
          [weak self] in
          if self != nil {
            self!.doVolumeFade(completion: completion)
          }
        }
      } else {
        // Stop and get the sound ready for playing again
        self.stop()
        self.volume = 1.0;
        completion()
      }
    }
    
    private override func play() -> Bool {
      self.shouldPlay = true
      return super.play()
    }
  }
  
  public var rewardSoundName: RewardSoundName.RawValue = ""
  public var errorSoundName: ErrorSoundName.RawValue = ""
  public var playtimeSongName: PlaytimeSongName.RawValue = ""
  
  private var bgmPlayer:InterruptibleAVAudioPlayer! = nil
  private var playOncePlayers: [InterruptibleAVAudioPlayer] = []
  private var isPlayingInitialSong = false
  private var isPlayingPlaytimeSong = false
  private var isPlayingTrophySound = false
  private var volume:Float = 1
  
  override private init() {
    super.init()
    
    GlobalConfiguration.addSoundHelper(self)
  }
  
  override public func isEqual(object: AnyObject?) -> Bool {
    return super.isEqual(object) && self===object
  }
  
  public func mute (boolValue:Bool) {
    self.volume = boolValue ? 0:1
    if let bgmPlayer = self.bgmPlayer {
      bgmPlayer.volume = volume
    }
//    if let playOncePlayer = self.playOncePlayer {
    for playOncePlayer in playOncePlayers {
      playOncePlayer.volume = volume
    }
  }
  
  
  public func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
    var playOncePlayer:AVAudioPlayer? = nil
    var index:Int = 0
    for p in playOncePlayers {
      if p===player {
        playOncePlayer = p
        break
      }
      index++
    }
    
    if flag && bgmPlayer != nil {
      if let interruptiblePlayer = playOncePlayer as? InterruptibleAVAudioPlayer {
        if interruptiblePlayer.interrupt && interruptiblePlayer.shouldRecoverBGM {
          bgmPlayer.play()
        }
      }
      
    }
    
    if playOncePlayer != nil {
      playOncePlayers.removeAtIndex(index)
    }
  }
  
  /* Singleton pattern */
  class var sharedInstance: SoundSourceHelper {
    get {
      struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: SoundSourceHelper? = nil
      }
      
      dispatch_once(&Static.onceToken) {
        Static.instance = SoundSourceHelper()
      }
      
      return Static.instance!
  }
  }
  
  public class var soundExtension: String {
    get {
      return "caf"
  }
  }
  
  public class var songExtension: String {
    get {
      return "aif"
  }
  }
  
  private class func soundPath (#name: String, withExtension: String) -> String {
    return name.stringByAppendingPathExtension(withExtension)!
  }
  
  private class func soundActionWithName (name: String) -> SKAction {
    var playOncePlayer = self.playSoundOnce(name, startImmediately: false, interrupt: false)
    
    if let player = playOncePlayer {
      var durAction = SKAction.waitForDuration(player.duration)
      var playAction = SKAction.runBlock { () -> Void in
        player.play()
        return
      }
      return SKAction.group([durAction, playAction])
    }
    return SKAction()
//    return SKAction.playSoundFileNamed(soundPath(name: name, withExtension: self.soundExtension), waitForCompletion: true)
  }
  private class func songActionWithName (name: String) -> SKAction {
    self.playSongOnce(name, startImmediately: false, interrupt: false)
    var durAction = SKAction.waitForDuration(self.sharedInstance.bgmPlayer.duration)
    var playAction = SKAction.runBlock() {
      self.sharedInstance.bgmPlayer.play()
      return
    }
    return SKAction.group([durAction, playAction])
//    return SKAction.playSoundFileNamed(soundPath(name: name, withExtension: self.songExtension), waitForCompletion: true)
  }
  
  public class func soundIdentify (#name : String) -> SKAction {
    // this is a name
    let randomNumber = arc4random_uniform(3) + 1
    return self.soundActionWithName("\(name)_identify_\(randomNumber)")
  }
  
  public class func soundFind (#name : String) -> SKAction {
    // where is the other name
    let randomNumber = arc4random_uniform(3) + 1
    return self.soundActionWithName("\(name)_find_\(randomNumber)")
  }
  
  public class func soundReward () -> SKAction {
    // you found the name
    return self.soundActionWithName(RewardSoundName(rawValue: self.sharedInstance.rewardSoundName)!.rawValue)
//    return "\(name)_found"
  }
  
  public class func soundCorrect (#name : String) -> SKAction {
    // where is the other name
//    return self.soundActionWithName("\(name)_correct")
    let randomNumber = arc4random_uniform(3) + 1
    return self.soundActionWithName("goodjob\(randomNumber)")
  }
  
  public class func soundError () -> SKAction {
    return self.soundActionWithName(ErrorSoundName(rawValue: self.sharedInstance.errorSoundName)!.rawValue)
  }
  
  public class func soundTryAgain (index: Int) -> SKAction {
    // please try again
//    return self.soundActionWithName("try_again")
//    return self.soundActionWithName("\(name)_wrong")
    return self.soundActionWithName("tryagain\(index)")
  }
  
  public class func soundReminder (#name: String) -> SKAction {
    return self.soundActionWithName("\(name)_reminder")
  }
  
  public class func soundMultiple (#name: String) -> SKAction {
    return self.soundActionWithName("\(name)_multiple")
  }
  
  public class func soundTap (#name: String) -> SKAction {
    return self.soundActionWithName("\(name)_tap")
  }
  
  public class func soundPut (#name: String) -> SKAction {
    return self.soundActionWithName("put_\(name)")
  }
  
  public class func soundTimeToPlay (#name: String) -> SKAction {
    // time to play
//    return self.soundActionWithName("time_to_play")
    return self.soundActionWithName("\(name)_look")
  }
  
  public class func soundBlop () -> SKAction {
    return self.soundActionWithName("Blop")
  }
  
  public class func soundBear () -> SKAction {
    // where is the other name
    //    return self.soundActionWithName("\(name)_correct")
    let randomNumber = arc4random_uniform(6)
    var bearSoundString:String
    switch randomNumber {
    case 0:
      bearSoundString = "hello"
    case 1:
      bearSoundString = "ho"
    case 2:
      bearSoundString = "hoho"
    case 3:
      bearSoundString = "uhoh"
    case 4:
      bearSoundString = "wee"
    case 5:
      bearSoundString = "yay"
    default:
      bearSoundString = ""
    }
    return self.soundActionWithName(bearSoundString)
  }
  
//  public class func soundPlaytime () -> SKAction {
//    return self.songActionWithName(PlaytimeSongName.fromRaw(self.sharedInstance.playtimeSongName)!.toRaw())
//  }
  
  public class func soundTouch () -> SKAction {
    // randoml pick a sound effect
    var touchSound = TouchSoundName.getRandom()
    return self.soundActionWithName(touchSound.rawValue)
  }
  
  public class func soundFirstOne () -> SKAction {
    return self.soundActionWithName("isitthisone")
  }
  
  public class func soundSecondOne () -> SKAction {
    return self.soundActionWithName("orisitthisone")
  }
  
  public class func stopBGM (completion: () -> () = {}) {
    if self.sharedInstance.bgmPlayer != nil {
      self.sharedInstance.bgmPlayer.shouldPlay = false
      self.sharedInstance.bgmPlayer.doVolumeFade(completion: completion)
//      self.sharedInstance.bgmPlayer.stop()
    }
    self.sharedInstance.isPlayingInitialSong = false
    self.sharedInstance.isPlayingPlaytimeSong = false
    self.sharedInstance.isPlayingTrophySound = false
  }
  
  private func loadURL (songName: String, withExtension: String = "aif") {
    var error: NSErrorPointer = nil
    var bgmURL:NSURL = NSBundle.mainBundle().URLForResource(songName, withExtension: withExtension)!
    bgmPlayer = InterruptibleAVAudioPlayer(contentsOfURL: bgmURL, error: error)
    ErrorLogger.logError(error, message: "Cannot play background music")
    bgmPlayer.numberOfLoops = -1
    bgmPlayer.volume = volume
    bgmPlayer.prepareToPlay()
  }
  
  public class func playInitialSong () {
    if !self.sharedInstance.isPlayingInitialSong {
      self.sharedInstance.loadURL("01 SMALL TOWN INSTRUMENTAL", withExtension: self.songExtension)
      self.sharedInstance.bgmPlayer.play()
      self.sharedInstance.isPlayingInitialSong = true
      self.sharedInstance.isPlayingPlaytimeSong = false
      self.sharedInstance.isPlayingTrophySound = false
    }
  }
  
  public class func playPlaytimeSong () {
    if !self.sharedInstance.isPlayingPlaytimeSong {
      self.sharedInstance.loadURL(GlobalConfiguration.playtimeSongName.rawValue, withExtension: self.songExtension)
      self.sharedInstance.bgmPlayer.play()
      self.sharedInstance.isPlayingInitialSong = false
      self.sharedInstance.isPlayingPlaytimeSong = true
      self.sharedInstance.isPlayingTrophySound = false
    }
  }
  
  public class func playTrophySound () {
    if !self.sharedInstance.isPlayingTrophySound {
      self.sharedInstance.loadURL(RewardSoundName.RightToneTwo.rawValue, withExtension: self.soundExtension)
      self.sharedInstance.bgmPlayer.play()
      self.sharedInstance.isPlayingInitialSong = false
      self.sharedInstance.isPlayingPlaytimeSong = false
      self.sharedInstance.isPlayingTrophySound = true
    }
  }
  
  public class func playSoundOnce (soundName: String, startImmediately: Bool = true, interrupt: Bool = true) -> AVAudioPlayer? {
    var instance = self.sharedInstance
    var playOncePlayer:InterruptibleAVAudioPlayer
    var shouldRecoverBGM:Bool = true
    
    if interrupt {
      instance.playOncePlayers.removeAll(keepCapacity: false)
      if instance.bgmPlayer != nil {
        if !instance.bgmPlayer.playing {
          shouldRecoverBGM = false
        }
        instance.bgmPlayer.pause()
      }
    }
    
    var error: NSErrorPointer = nil
    if let url:NSURL = NSBundle.mainBundle().URLForResource(soundName, withExtension: self.soundExtension) {
      instance.playOncePlayers.append(InterruptibleAVAudioPlayer(contentsOfURL: url, error: error))
      playOncePlayer = instance.playOncePlayers.last!
      ErrorLogger.logError(error, message: "Cannot play sound")
      
      playOncePlayer.delegate = instance
      playOncePlayer.numberOfLoops = 0
      playOncePlayer.prepareToPlay()
      playOncePlayer.volume = instance.volume
      playOncePlayer.interrupt = interrupt
      playOncePlayer.shouldRecoverBGM = shouldRecoverBGM
      if startImmediately {
        playOncePlayer.play()
      }
      return playOncePlayer
    }
    
    return nil
    
    
    
    
  }
  
  public class func playSongOnce (songName: String, startImmediately: Bool = true, interrupt: Bool = true) -> AVAudioPlayer? {
    var instance = self.sharedInstance
    var playOncePlayer:InterruptibleAVAudioPlayer
    var shouldRecoverBGM:Bool = true
    
    if interrupt {
      instance.playOncePlayers.removeAll(keepCapacity: false)
      if instance.bgmPlayer != nil {
        if !instance.bgmPlayer.playing {
          shouldRecoverBGM = false
        }
        instance.bgmPlayer.pause()
      }
    }
    
    var error: NSErrorPointer = nil
    if let url:NSURL = NSBundle.mainBundle().URLForResource(songName, withExtension: self.songExtension) {
      instance.playOncePlayers.append(InterruptibleAVAudioPlayer(contentsOfURL: url, error: error))
      playOncePlayer = instance.playOncePlayers.last!
      ErrorLogger.logError(error, message: "Cannot play sound")
      
      playOncePlayer.delegate = instance
      playOncePlayer.numberOfLoops = 0
      playOncePlayer.prepareToPlay()
      playOncePlayer.volume = instance.volume
      playOncePlayer.interrupt = interrupt
      playOncePlayer.shouldRecoverBGM = shouldRecoverBGM
      if startImmediately {
        playOncePlayer.play()
      }
      return playOncePlayer
    }
    
    return nil
  }

}
