//
//  ControlButtonType.swift
//  MyControl
//
//  Created by Joao Luiz Fernandes on 07/09/2018.
//  Copyright © 2018 Joao Luiz Fernandes. All rights reserved.
//

import Foundation

enum ButtonKeyType: String, CodingKey {
    case none = "none"
    case power = "icon_power"
    case pause = "icon_pause"
    case stop = "icon_stop"
    case play = "icon_play"
    case rewind = "icon_rewind"
    case forward = "icon_forward"
    case record = "icon_record"
    case search = "icon_search"
    case configs = "icon_configs"
    case home = "icon_home"
    case options = "icon_options"
    case up = "icon_up"
    case left = "icon_left"
    case right = "icon_right"
    case down = "icon_down"
    case ok = "icon_ok"
    case undo = "icon_undo"
    case source = "icon_source"
    case mute = "icon_mute"
    case volumeDown = "icon_volume_down"
    case volumeUp = "icon_volume_up"
    case channelDown = "icon_channel_down"
    case channelUp = "icon_channel_up"
    case exit = "icon_exit"
    
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    
    var isNumber: Bool! {
        get {
            return number != nil
        }
    }
    
    var buttonKey: String! {
        get {
            return self.stringValue.replacingOccurrences(of: "icon_", with: "")
        }
    }
    
    var number: Int! {
        get {
            return Int(stringValue)
        }
    }
}
