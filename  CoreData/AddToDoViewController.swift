//
//  AddToDoViewController.swift
//   CoreData
//
//  Created by Rafael M. Trasmontero on 1/5/18.
//  Copyright © 2018 GTTuts. All rights reserved.
//

import UIKit

class AddToDoViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView
        
        //Listen for Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(with:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    // MARK: Handle Keyboard & Stack View (Buttons&Segments Move Up)
    
    @objc func keyBoardWillShow(with notification:Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
        
        let keyboardheight = keyboardFrame.cgRectValue.height + 8 //<---* 8 Bottom Space
        
        bottomConstraint.constant = keyboardheight
        
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }

    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
    }
    


}
