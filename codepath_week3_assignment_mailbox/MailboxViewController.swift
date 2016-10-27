//
//  MailboxViewController.swift
//  codepath_week3_assignment_mailbox
//
//  Created by StudyBlue on 10/26/16.
//  Copyright © 2016 myself. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    
    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageParentView: UIView!
    @IBOutlet weak var laterImageView: UIImageView!
    
    var messageOriginalX: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        messageOriginalX = messageImageView.frame.origin.x
        
        rescheduleImageView.alpha = 0
        listImageView.alpha = 0
        
        feedScrollView.contentSize = CGSize(width: 375, height: 1634)
        
    }
    
    
    @IBAction func didPanMessage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        var tXNegative = convertValue(inputValue: translation.x, r1Min: -50, r1Max: -100, r2Min: 0, r2Max: 1)
        
        if sender.state == .began {
            // 'began' code here
            laterImageView.alpha = 0.3
            
        } else if sender.state == .changed {
            
            messageImageView.frame.origin.x = CGFloat(messageOriginalX + translation.x)
            
            print ("Translation x: \(translation.x)")
            print ("tXNegative: \(tXNegative)")
            
            laterImageView.alpha = tXNegative > 0.3 ? tXNegative : 0.3
            
            print ("laterImageView.alpha: \(laterImageView.alpha)")
            
            // grey, default
            if messageImageView.frame.origin.x < 50 && messageImageView.frame.origin.x > -50 {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.lightGray
                })
                
            // yellow, "later" action
            } else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -200 {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.yellow
                })
   
            // orange, list
            } else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -375 {
             
                UIView.animate(withDuration: 0.5, animations: { 
                    self.messageParentView.backgroundColor = UIColor.brown
                })
                
            // green, check mark
            } else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 200 {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.green
                })
                
            // red, x delete
            } else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 375 {

                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.red
                })
                
            }
            
            
        } else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: {
                self.messageImageView.frame.origin.x = self.messageOriginalX
                self.messageParentView.backgroundColor = UIColor.lightGray
                }, completion: { (Bool) in
            })
            
        }
        
    }
    
    
    
}
