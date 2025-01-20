//
//  ViewController.swift
//  Donmani
//
//  Created by 문종식 on 1/20/25.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "Dev Environment Setting"
        label.textColor = .black
        label.sizeToFit()
        label.center = view.center
        view.addSubview(label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

