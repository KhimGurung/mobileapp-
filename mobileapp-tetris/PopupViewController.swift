//
//  PopupViewController.swift
//  mobileapp-tetris
//
//  Created by Khim Bahadur Gurung on 29.01.18.
//  Copyright © 2018 Khim Bahadur Gurung. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBAction func popupTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
