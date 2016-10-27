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
        
        if sender.state == .began {
            
            
        } else if sender.state == .changed {
            messageImageView.frame.origin.x = CGFloat(messageOriginalX + translation.x)
            
            // default grey
            if messageImageView.frame.origin.x < 50 && messageImageView.frame.origin.x > -50 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageParentView.backgroundColor = UIColor.lightGray
                })
            
            // green check mark
            } else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 100 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageParentView.backgroundColor = UIColor.green
                })
            
            // yellow "later" action
            } else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x < -100 {
                
                UIView.animate(withDuration: 0.2, animations: { 
                    self.messageParentView.backgroundColor = UIColor.yellow
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
