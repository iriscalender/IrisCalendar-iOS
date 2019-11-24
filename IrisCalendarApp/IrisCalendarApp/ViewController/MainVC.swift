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
        setUpUI()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MenubarVC {
            controller.delegate = self
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        } else if let controller = segue.destination as? AddScheduleMenubarVC {
            controller.delegate = self
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        }
    }

    private func setUpUI() {
    }

}

extension MainVC: MenubarDelegate {
    func goWhere(destination: GoWhere) {
        switch destination {
        case .none: return
        case .FixScheduleVC:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: destination.rawValue) as! FixScheduleVC
            vc.scheduleStatus.onNext(.add)
            self.navigationController?.pushViewController(vc, animated: false)
        case .AutoScheduleVC:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: destination.rawValue) as! AutoScheduleVC
            vc.scheduleStatus.onNext(.add)
            self.navigationController?.pushViewController(vc, animated: false)
        default: self.goNextVC(identifier: destination.rawValue)
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

enum GoWhere: String {
    case none
    case TimeResettingVC
    case EditCategoryVC
    case AuthNC
    case FixScheduleVC
    case AutoScheduleVC
}
