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
    @IBOutlet weak var archiveImageView: UIImageView!
    
    var messageOriginalX: CGFloat!
    var laterImageViewOriginalX: CGFloat!
    var archiveImageViewOriginalX: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        messageOriginalX = messageImageView.frame.origin.x
        laterImageViewOriginalX = laterImageView.frame.origin.x
        archiveImageViewOriginalX = archiveImageView.frame.origin.x
        
        rescheduleImageView.alpha = 0
        listImageView.alpha = 0
        
        feedScrollView.contentSize = CGSize(width: 375, height: 1634)
        
    }
    
    
    @IBAction func didPanMessage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // swiping messageImageView left: map negative translation.x to a positive value between 0 and 1 to assign to the alpha
        var tXLeftForAlpha = convertValue(inputValue: translation.x, r1Min: -20, r1Max: -100, r2Min: 0.2, r2Max: 1)
        
        // swiping messageImageView right: map translation.x to a value between 0 and 1 to assign to the alpha
        var txRightForAlpha = convertValue(inputValue: translation.x, r1Min: 20, r1Max: 100, r2Min: 0.2, r2Max: 1)
        

        if sender.state == .began {
            
            // set initial alpha for the reschedule icon
            laterImageView.alpha = 0.2
            archiveImageView.alpha = 0.2
            
            laterImageView.image = UIImage(named: "later_icon")
            archiveImageView.image = UIImage(named: "archive_icon")
            messageParentView.backgroundColor = UIColor.lightGray

            
        } else if sender.state == .changed {
            
            // track the message with the pan position
            messageImageView.frame.origin.x = CGFloat(messageOriginalX + translation.x)
            
            // fade in the later icon
            laterImageView.alpha = tXLeftForAlpha
            
            //fade in the archive icon
            archiveImageView.alpha = txRightForAlpha
            
            // grey, default
            if messageImageView.frame.origin.x < 60 && messageImageView.frame.origin.x > -60 {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.lightGray
                })
                
            // yellow, "later" action
            } else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -260 {
                
                archiveImageView.alpha = 0
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.yellow
                })
                
                laterImageView.image = UIImage(named: "later_icon")
                laterImageView.frame.origin.x = laterImageViewOriginalX + (translation.x + 60)
                
            // brown, list
            } else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -375 {
                
                archiveImageView.alpha = 0
             
                UIView.animate(withDuration: 0.5, animations: { 
                    self.messageParentView.backgroundColor = UIColor.brown
                })
                
                laterImageView.image = UIImage(named: "list_icon")
                laterImageView.frame.origin.x = laterImageViewOriginalX + (translation.x + 60)
                
            // green, archive
            } else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 260 {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.green
                })
                
                archiveImageView.image = UIImage(named: "archive_icon")
                archiveImageView.frame.origin.x = archiveImageViewOriginalX + (translation.x - 60)
                
                
            // red, x delete
            } else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 375 {

                UIView.animate(withDuration: 0.3, animations: {
                    self.messageParentView.backgroundColor = UIColor.red
                })
                
                archiveImageView.image = UIImage(named: "delete_icon")
                archiveImageView.frame.origin.x = archiveImageViewOriginalX + (translation.x - 60)
                
            }
            
            
        } else if sender.state == .ended {
            
            // when the user chooses nothing, reset everything
            if messageImageView.frame.origin.x < 60 && messageImageView.frame.origin.x > -60 {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: {
                    self.messageImageView.frame.origin.x = self.messageOriginalX
                    self.laterImageView.frame.origin.x = self.laterImageViewOriginalX
                    self.archiveImageView.frame.origin.x = self.archiveImageViewOriginalX
                    }, completion: { (Bool) in
                })
                
            // user chooses yellow, later icon
            }  else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -260 {
                
                // animate the message out, then return
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageImageView.frame.origin.x -= 300
                    self.laterImageView.frame.origin.x -= 300
                    }, completion: {(Bool) in
                        UIView.animate(withDuration: 0.2, delay:0.3, animations: {
                            self.messageImageView.frame.origin.x = self.messageOriginalX
                            self.laterImageView.frame.origin.x = self.laterImageViewOriginalX
                        })
                        
                })
                
                // delay, then animate the reschedule image in. On completion, bring the message back to position
                UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                    self.rescheduleImageView.alpha = 1
                    }, completion: { (Bool) in
                        self.messageImageView.frame.origin.x = self.messageOriginalX
                })
                
            // user chooses brown, list icon
            } else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -375 {
                
                // animate the message out
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageImageView.frame.origin.x -= 200
                    self.laterImageView.frame.origin.x -= 200
                    }, completion: {(Bool) in
                        UIView.animate(withDuration: 0.2, delay:0.3, animations: {
                            self.messageImageView.frame.origin.x = self.messageOriginalX
                            self.laterImageView.frame.origin.x = self.laterImageViewOriginalX
                        })
                        
                })
                
                // delay, then animate the list image in. On completion, bring the message back to position
                UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                    self.listImageView.alpha = 1
                    }, completion: { (Bool) in
                        self.messageImageView.frame.origin.x = self.messageOriginalX
                })
                
                
            // user chooses green, archive icon
            }  else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 260 {
                
                print ("Archive: Keep the empty space green Make the message fly off to the right. Make all the other messages move up to close the gap.")
            
            // user chooses red, x delete icon
            }  else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 375 {
                print ("Delete: Keep the empty space red. Make the message fly off to the right. Make all the other messages move up to close the gap.")
            }
            
        }
        
    }
    
    @IBAction func didTapReschedule(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.rescheduleImageView.alpha = 0
            }) { (Bool) in
                // finish the hide animation
        }
    // end didTapReschedule
    }
    
    
    @IBAction func didTapListImage(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.listImageView.alpha = 0
        }) { (Bool) in
            // finish the hide animation
        }
    // end didTapListImage
    }
}
