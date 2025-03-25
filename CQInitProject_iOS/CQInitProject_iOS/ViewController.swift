//
//  ViewController.swift
//  CQInitProject_iOS
//
//  Created by qian on 2025/3/25.
//

import UIKit
import Flutter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.setTitle("打开Flutter页面", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(openFlutterPage), for: .touchUpInside)
        view.addSubview(button)
    }

    
    @IBAction func openFlutterPage() {
        let flutterViewController = FlutterViewController(engine: (UIApplication.shared.delegate as! AppDelegate).flutterEngine, nibName: nil, bundle: nil)
        flutterViewController.modalPresentationStyle = .fullScreen
        present(flutterViewController, animated: true, completion: nil)
    }
}

