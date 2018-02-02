//
//  ViewController.swift
//  HSVColorWheel
//
//  Created by ZhouJiatao on 2018.02.02.
//  Copyright © 2018 ZJT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let wheel = HSVColorWheel(frame: view.bounds)
        view.addSubview(wheel)
   }


}

