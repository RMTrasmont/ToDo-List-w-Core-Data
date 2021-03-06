//
//  AddToDoViewController.swift
//   CoreData
//
//  Created by Rafael M. Trasmontero on 1/5/18.
//  Copyright © 2018 GTTuts. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController {

    //MARK: Core Data Properties
    var managedContext: NSManagedObjectContext!
    var todo: ToDo?
    
    //MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Highlights place-holder text to be replaced/cleared
        self.textView.clearsOnInsertion = true
        
        //Listen for Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(with:)), name: .UIKeyboardWillShow, object: nil)
        
        //Show Keyboard Right Away
        textView.becomeFirstResponder()
        
        //If an instance of a ToDo already exists(editing), show it on textfield
        if let todo = todo{
            textView.text = todo.title
            textView.text = todo.title   //<--Bug*
            segmentControl.selectedSegmentIndex = Int(todo.priority)
        }
    
    }
    
    // MARK: Methods
    
    //Handle Keyboard & Stack View (Buttons&Segments Move Up)
    
    @objc func keyBoardWillShow(with notification:Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
        
        let keyboardheight = keyboardFrame.cgRectValue.height + 8 //<---* 8 Bottom Space
        
        bottomConstraint.constant = keyboardheight
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }

    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
        
        //Hide Keyboard
        textView.resignFirstResponder()
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        guard let theTitle = textView.text, !theTitle.isEmpty else {return}
        
        //Check if ToDo already exists, then update, if not create one
        if let todo = self.todo {
            todo.title = theTitle
            todo.priority = Int16(segmentControl.selectedSegmentIndex)
        } else {
            let todo = ToDo(context: managedContext)
            todo.title = theTitle
            todo.priority = Int16(segmentControl.selectedSegmentIndex)
            todo.date = NSDate()
        }
        //Save ManagedContext
        do{
            try managedContext.save()
            dismiss(animated: true)
            textView.resignFirstResponder()
        } catch let err{
            print("ERROR SAVING TO CRE DATA:",err.localizedDescription)
        }
        
    }
    


}
