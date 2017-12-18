//
//  PNTabViewController.swift
//  PicNRoll
//
//  Created by jordi on 16/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Material

class PNTabViewController: TabsController {

    open override func prepare() {
        super.prepare()
        tabBar.setLineColor(Color.orange.base, for: .selected) // or tabBar.lineColor = Color.orange.base
        tabBar.setTabItemsColor(Color.grey.base, for: .normal)
        tabBar.setTabItemsColor(Color.purple.base, for: .selected)
        tabBar.setTabItemsColor(Color.green.base, for: .highlighted)
        tabBar.setLineColor(Color.orange.base, for: .selected) // or tabBar.lineColor = Color.orange.base
        
        tabBar.setTabItemsColor(Color.grey.base, for: .normal)
        tabBar.setTabItemsColor(Color.purple.base, for: .selected)
        tabBar.setTabItemsColor(Color.green.base, for: .highlighted)
        
        tabBarAlignment = .top
        tabBar.tabBarStyle = .auto
        tabBar.dividerColor = nil
        tabBar.lineHeight = 5.0
        tabBar.lineAlignment = .bottom
        tabBar.backgroundColor = Color.blue.darken2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
