//
//  MainVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 23/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import FSCalendar
import BubbleTransition
import RxSwift
import RxCocoa

class MainVC: UIViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var addScheduleBtn: UIButton!
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var todayDateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthNC") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MenubarVC {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        } else if let controller = segue.destination as? AddScheduleMenubarVC {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        }
    }

}

extension MainVC: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.bubbleColor = UIColor.white.withAlphaComponent(0.5)
        if presented as? MenubarVC != nil { transition.startingPoint = CGPoint(x: 0, y: 0) }
        if presented as? AddScheduleMenubarVC != nil { transition.startingPoint = CGPoint(x: view.frame.width, y: 0) }
        return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.bubbleColor = UIColor.white.withAlphaComponent(0.5)
        if dismissed as? MenubarVC != nil { transition.startingPoint = CGPoint(x: 0, y: 0) }
        if dismissed as? AddScheduleMenubarVC != nil { transition.startingPoint = CGPoint(x: view.frame.width, y: 0) }
        return transition
    }
}

class TodayScheduleListCell: UITableViewCell {
    @IBOutlet weak var categoryView: RoundView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
}
