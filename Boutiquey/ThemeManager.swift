//
//  ThemeManager.swift
//  MobikulMagento-2
//
//  Created by kunal on 22/06/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation



class ThemeManager{
    
  static  func applyTheme(bar:UINavigationBar){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().HexToColor(hexString: NAVIGATION_TINTCOLOR),NSAttributedString.Key.font: UIFont(name: BOLDFONT, size: 15)!]
        UINavigationBar.appearance().tintColor = UIColor().HexToColor(hexString: NAVIGATION_TINTCOLOR)
        var frameAndStatusBar: CGRect = bar.bounds
        frameAndStatusBar.size.height += 20
        UINavigationBar.appearance().setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: GRADIENTCOLOR), for: .default)
        UITabBar.appearance().barStyle = .default
        UISwitch.appearance().onTintColor = UIColor().HexToColor(hexString: BUTTON_COLOR).withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        UITabBar.appearance().tintColor =  UIColor().HexToColor(hexString: BUTTON_COLOR)
        activityIndicator.radius = 15
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.midX,y: UIScreen.main.bounds.midY);
        UIApplication.shared.keyWindow?.addSubview(activityIndicator)
        activityIndicator.cycleColors = [UIColor().HexToColor(hexString: BUTTON_COLOR), UIColor().HexToColor(hexString: ACCENT_COLOR)]
        activityIndicator.strokeWidth = 3
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).textColor = UIColor.white
        UITextField.appearance().tintColor = UIColor.black
        UIBarButtonItem.appearance().setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: REGULARFONT, size: 15)!], for: .normal)
    
    }
    
   

    
 
}

var ASTERISK = " ⃰"
var REDCOLOR = "FF4848"
var ORANGECOLOR = "FF9C05"
var EXTRALIGHTGREY = "ECEFF1"
var LIGHTGREY = "8E8E93";
var DARKGREY = "A0A0A0"
var ACCENT_COLOR = "511834";
var BUTTON_COLOR = "E60086";
var TEXTHEADING_COLOR = "000000";
var NAVIGATION_TINTCOLOR = "ffffff"
var LINK_COLOR = "000000"
var SHOW_COMPARE = false;
var GREEN_COLOR = "05C149"
var STAR_COLOR = "dc831a"
var GRADIENTCOLOR = [UIColor().HexToColor(hexString: ACCENT_COLOR),UIColor().HexToColor(hexString: BUTTON_COLOR)]
var STARGRADIENT = [UIColor().HexToColor(hexString: "93BC4B") , UIColor().HexToColor(hexString: "9ED836")]
var WIDTH = String(format:"%.0f", SCREEN_WIDTH * UIScreen.main.scale)

public var BOLDFONT = "AvenirNext-DemiBold";
public var REGULARFONT = "AvenirNext-Regular";
public var BOLDFONTMEDIUM = "AvenirNext-Medium";













