//
//  MailboxViewController.swift
//  codepath_week3_assignment_mailbox
//


import UIKit

class MailboxViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // Message to pan
    @IBOutlet weak var messageParentView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    
    
    // Icons
    @IBOutlet weak var laterImageView: UIImageView!
    @IBOutlet weak var archiveImageView: UIImageView!
    
    
    // Feed items
    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!

    
    // "reschedule" and "list" screens
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    
    @IBOutlet weak var menuImageView: UIImageView!
    

    var messageOriginalX: CGFloat!
    var laterImageViewOriginalX: CGFloat!
    var archiveImageViewOriginalX: CGFloat!
    var feedScrollViewOriginalX: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Establish initial values
        
        messageOriginalX = messageImageView.frame.origin.x
        
        laterImageViewOriginalX = laterImageView.frame.origin.x
        archiveImageViewOriginalX = archiveImageView.frame.origin.x
        
        feedScrollViewOriginalX = feedScrollView.frame.origin.x
        
        rescheduleImageView.alpha = 0
        listImageView.alpha = 0
        
        menuImageView.alpha = 0
        
        feedScrollView.contentSize = CGSize(width: 375, height: 2500)
        
        
        // Set up Screen Edge Pan Gesture Recognizer
        
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didPanFeedScrollView(sender:)))
        
        edgePanGestureRecognizer.edges = UIRectEdge.left
        
        
        feedScrollView.isUserInteractionEnabled = true
        feedScrollView.addGestureRecognizer(edgePanGestureRecognizer)
        
        edgePanGestureRecognizer.delegate = self
        
    }
    
    
    @IBAction func didPanMessage(_ sender: UIPanGestureRecognizer) {
        
        ////////////////////////////////
        ////// Message Pan Setup ///////
        ////////////////////////////////
        
        let translation = sender.translation(in: view)
        
        // Left pan -> later_icon.alpha: map negative translation.x to a value between 0.2 and 1, for assigning to the "later" icon alpha
        let tXLeftForAlpha = convertValue(inputValue: translation.x, r1Min: -20, r1Max: -100, r2Min: 0.2, r2Max: 1)
        
        // Right pan -> archive_icon.alpha: map positive translation.x to a value between 0.2 and 1, for assigning to the "archive" icon alpha
        let txRightForAlpha = convertValue(inputValue: translation.x, r1Min: 20, r1Max: 100, r2Min: 0.2, r2Max: 1)

        if sender.state == .began {
            
            // set initial states
            laterImageView.alpha = 0.2
            archiveImageView.alpha = 0.2
            
            laterImageView.image = UIImage(named: "later_icon")
            archiveImageView.image = UIImage(named: "archive_icon")
            
            messageParentView.backgroundColor = UIColor.lightGray
            
            
        } else if sender.state == .changed {
            
            // move the message with the pan position
            messageImageView.frame.origin.x = CGFloat(messageOriginalX + translation.x)
            
            // prepare to fade in the "later" icon
            laterImageView.alpha = tXLeftForAlpha
            
            //prepare to fade in the "archive" icon
            archiveImageView.alpha = txRightForAlpha
            
            ///////////////////////////////
            ////// Message Pan Left ///////
            ///////////////////////////////
            
            // grey, default. -60 < x < 60
            if messageImageView.frame.origin.x < 60 && messageImageView.frame.origin.x > -60 {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.lightGray
                })
            }
                
            // yellow, "later" action. -260 < x < 0
            else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -260 {
                
                archiveImageView.alpha = 0
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.yellow
                })
                
                laterImageView.image = UIImage(named: "later_icon")
                laterImageView.frame.origin.x = laterImageViewOriginalX + (translation.x + 60)
                
            }
            
            // brown, list icon. -375 < x < -260
            else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -375 {
                
                archiveImageView.alpha = 0
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.brown
                })
                
                laterImageView.image = UIImage(named: "list_icon")
                laterImageView.frame.origin.x = laterImageViewOriginalX + (translation.x + 60)
                
                
            }
                
            ////////////////////////////////
            ////// Message Pan Right ///////
            ////////////////////////////////
                
            // green, archive. 0 < x < 260
            else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 260 {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.messageParentView.backgroundColor = UIColor.green
                })
                
                archiveImageView.image = UIImage(named: "archive_icon")
                archiveImageView.frame.origin.x = archiveImageViewOriginalX + (translation.x - 60)
            }
            
            // red, x delete. 260 < x < 375
            else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 375 {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageParentView.backgroundColor = UIColor.red
                })
                
                archiveImageView.image = UIImage(named: "delete_icon")
                archiveImageView.frame.origin.x = archiveImageViewOriginalX + (translation.x - 60)
                
            }
            
            
        } else if sender.state == .ended {
            
            ///////////////////////////////////////////
            ////// Message Pan Ended: No Action ///////
            ///////////////////////////////////////////
            
            // when the user chooses nothing, reset everything
            if messageImageView.frame.origin.x < 60 && messageImageView.frame.origin.x > -60 {
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: {
                    
                    self.messageImageView.frame.origin.x = self.messageOriginalX
                    self.laterImageView.frame.origin.x = self.laterImageViewOriginalX
                    self.archiveImageView.frame.origin.x = self.archiveImageViewOriginalX
                    })
                
            //////////////////////////////////////
            ////// Message Pan Ended: Left ///////
            //////////////////////////////////////
                
            // LATER: user chooses yellow, later icon. -260 < x < 0
            }  else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -260 {
                
                // animate the message to the side
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.messageImageView.frame.origin.x = -(self.messageImageView.frame.width * 0.7)
                    self.laterImageView.frame.origin.x = ((self.laterImageViewOriginalX + 60) - (self.messageImageView.frame.width * 0.7))
                })
                
                // delay, then animate the Reschedule image in
                UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                    self.rescheduleImageView.alpha = 1
                })
                
            // LIST: user chooses brown, list icon. -375 < x < -260
            } else if messageImageView.frame.origin.x < 0 && messageImageView.frame.origin.x > -375 {
                
                // animate the message to the side
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.messageImageView.frame.origin.x = -(self.messageImageView.frame.width * 0.8)
                    self.laterImageView.frame.origin.x = ((self.laterImageViewOriginalX + 60) - (self.messageImageView.frame.width * 0.8))
                })
                
                // delay, then animate the List image in
                UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                    self.listImageView.alpha = 1
                })
                
            ///////////////////////////////////////
            ////// Message Pan Ended: Right ///////
            ///////////////////////////////////////
                
            // ARCHIVE: user chooses green, archive icon. 0 < x < 260
            }  else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 260 {
                
                // animate the message out
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.messageImageView.frame.origin.x = self.messageOriginalX + self.messageImageView.frame.width
                    
                    self.archiveImageView.frame.origin.x = ((self.archiveImageViewOriginalX - 60) + self.messageImageView.frame.width)
                })
                
                // move the feed up to close the gap
                UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [], animations: {
                    self.feedImageView.frame.origin.y -= self.messageImageView.frame.height
                })
                
                
            // DELETE: user chooses red, x delete icon. 260 < x < 375
            }  else if messageImageView.frame.origin.x > 0 && messageImageView.frame.origin.x < 375 {
                
                // animate the message out
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.messageImageView.frame.origin.x = self.messageOriginalX + self.messageImageView.frame.width
                    
                    self.archiveImageView.frame.origin.x = ((self.archiveImageViewOriginalX - 60) + self.messageImageView.frame.width)
                })
                
                // move the feed up to close the gap
                UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [], animations: {
                    self.feedImageView.frame.origin.y -= self.messageImageView.frame.height
                })
                
            }
            
        }
        
    }
    
    // dismiss the Reschedule view
    @IBAction func didTapReschedule(_ sender: UITapGestureRecognizer) {
        
        // Fade out the Reschedule view
        UIView.animate(withDuration: 0.3, animations: {
            self.rescheduleImageView.alpha = 0
            
        }) { (Bool) in
            // and then complete the message slide-out animation
            UIView.animate(withDuration: 0.2, animations: {
                
                self.messageImageView.frame.origin.x -= self.messageImageView.frame.width * 0.3
                self.laterImageView.frame.origin.x -= self.messageImageView.frame.width * 0.3
            })
        }
        
        // move up the feed to close the gap
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [], animations: {
            self.feedImageView.frame.origin.y -= self.messageImageView.frame.height
        })
    
    } // end didTapReschedule
    
    
    @IBAction func didTapListImage(_ sender: UITapGestureRecognizer) {
        
        // fade out the List view
        UIView.animate(withDuration: 0.3, animations: {
            
            self.listImageView.alpha = 0
            
        }) { (Bool) in
            // and then complete the message slide-out animation
            UIView.animate(withDuration: 0.2, animations: {
                
                self.messageImageView.frame.origin.x -= self.messageImageView.frame.width * 0.2
                self.laterImageView.frame.origin.x -= self.messageImageView.frame.width * 0.2
            })
        }
        
        // move up the feed to close the gap
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [], animations: {
            self.feedImageView.frame.origin.y -= self.messageImageView.frame.height
        })
        
    } // end didTapReschedule
    
    
    // allow multiple gestures to affect feedScrollView
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // swipe from the edge to reveal the menu
    func didPanFeedScrollView (sender: UIScreenEdgePanGestureRecognizer) {
        
        let location = sender.location(in: view)
        
        if sender.state == .began {
            
            menuImageView.alpha = 1
            
        } else if sender.state == .changed {
            
            feedScrollView.frame.origin.x = feedScrollViewOriginalX + location.x
            
        } else if sender.state == .ended {
            
            // snap back if not panned far enough
            if location.x < 150 {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                    
                    self.feedScrollView.frame.origin.x = self.feedScrollViewOriginalX
                }) { (Bool) in
                    self.menuImageView.alpha = 0
                }
            }
                
            // snap to the right if they did pan far enough
            else {

                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                    
                    self.feedScrollView.frame.origin.x = self.feedScrollViewOriginalX + (self.feedScrollView.frame.width * 0.93)
                })
            }
            
        }
        
    } // end didPanMenuHider
    
    
}
