//
//  ViewController.swift
//  MultipleSelection
//
//  Created by Giancarlo on 02.06.18.
//  Copyright © 2018 Giancarlo Buenaflor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(PickerCell.self)
        tv.backgroundColor = UIColor(red:0.09, green:0.08, blue:0.08, alpha:1.0)
        tv.tableFooterView = UIView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()
    
    lazy var selectedTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(SelectedCell.self)
        tv.backgroundColor = UIColor(red:0.09, green:0.08, blue:0.08, alpha:1.0)
        tv.tableFooterView = UIView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()
    
    
    let scrollIndicator: UIView = {
        let iv = UIView()
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 3
        return iv
    }()
    
    let testView = UIView()
    
    var smallTableViewWidth: NSLayoutConstraint?
    var tableViewWidth: NSLayoutConstraint?
    var selectedViewWidth: NSLayoutConstraint?
    
    var selectedMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.05, green:0.03, blue:0.03, alpha:1.0)
        
        tableViewWidth = tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.78)
        smallTableViewWidth = tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        selectedViewWidth = selectedTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        
        guard let tableViewWidth = tableViewWidth, let selectedViewWidth = selectedViewWidth else { return }
        
        view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor),
            tableViewWidth
            ]}
        
        
        testView.backgroundColor = UIColor(red:0.09, green:0.08, blue:0.08, alpha:1.0)
        
        view.add(subview: scrollIndicator) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: tableView.trailingAnchor),
            v.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            v.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.01)
            ]}

        view.add(subview: selectedTableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: tableView.topAnchor),
            v.leadingAnchor.constraint(equalTo: scrollIndicator.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            selectedViewWidth
            ]}
        
        let dragGestureRec = UIPanGestureRecognizer(target: self, action: #selector(didDragTableView(sender:)))
        dragGestureRec.cancelsTouchesInView = false
        view.addGestureRecognizer(dragGestureRec)
    }
    
    @objc func didDragTableView(sender: UIPanGestureRecognizer) {
        let tvTranslation = sender.translation(in: tableView)
        let selectedTranslation = sender.translation(in: testView)
        let indicatorTranslation = sender.translation(in: scrollIndicator)
        
        print(indicatorTranslation.x)
        print(view.frame.size.width)
        
//        tableViewWidth?.constant = tvTranslation.x
//        selectedViewWidth?.constant = -selectedTranslation.x
        
        if sender.state == .ended {
            
            if indicatorTranslation.x <= -(view.frame.size.width / 4) {
                animateSelectedState()
            }
            else {
                animateDefaultState()
            }
            
            tableView.reloadData()
            selectedTableView.reloadData()
        }
    }
    
    func animateDefaultState() {
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.selectedViewWidth?.constant = 0
            self.tableViewWidth?.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        self.selectedMode = false
    }
    
    func animateSelectedState() {
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.selectedViewWidth?.constant = (self.view.frame.size.width * 0.60)
            self.tableViewWidth?.constant = -(self.view.frame.size.width * 0.60)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        self.selectedMode = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(PickerCell.self, for: indexPath)
            
            cell.setViews(selectedMode: selectedMode)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(SelectedCell.self, for: indexPath)
            
            cell.setViews(selectedMode: selectedMode)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if selectedMode {
                animateDefaultState()
            }
            else {
                
            }
        }
        else {
            if !selectedMode {
                animateSelectedState()
            }
        }
        
        self.tableView.reloadData()
        selectedTableView.reloadData()
    }
}

class PickerCell: UITableViewCell {
    
    let containerView = UIView()
    
    let titleLabel: Label = {
        let lbl = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
        lbl.alpha = 0
        return lbl
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "latest")
        iv.alpha = 0
        return iv
    }()
    
    func setViews(selectedMode activated: Bool) {
        if activated {
            
//            titleLabel.removeFromSuperview()
//
//            UIView.animate(withDuration: 0.25) {
//                self.iconImageView.alpha = 1
//            }
            
//            containerView.add(subview: iconImageView) { (v, p) in [
//                v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
//                v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
//                v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.6),
//                v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.6)
//                ]}
            
            titleLabel.text = "03:50"
    
        }
        else {
            
            
            iconImageView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.alpha = 1
            }
            
            containerView.add(subview: titleLabel) { (v, p) in [
                v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
                v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
                ]}
            
            titleLabel.text = "model"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        selectionStyle = .none
        
        containerView.backgroundColor = UIColor(red:0.09, green:0.08, blue:0.08, alpha:1.0)
        
        add(subview: containerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 1),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 3),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -3),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -1)
            ]}
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SelectedCell: UITableViewCell {
    let containerView = UIView()
    
    let titleLabel: Label = {
        let lbl = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
        lbl.alpha = 0
        return lbl
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "latest")
        iv.alpha = 0
        return iv
    }()
    
    func setViews(selectedMode activated: Bool) {
        if activated {
            
            
            iconImageView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.alpha = 1
            }
            
            containerView.add(subview: titleLabel) { (v, p) in [
                v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
                v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
                ]}
            
            titleLabel.text = "selected"
        }
        else {
            titleLabel.removeFromSuperview()
            
            UIView.animate(withDuration: 0.25) {
                self.iconImageView.alpha = 1
            }
            
            containerView.add(subview: iconImageView) { (v, p) in [
                v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
                v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
                v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.6),
                v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.6)
                ]}
        }
        
        print(activated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        selectionStyle = .none
        
        containerView.backgroundColor = UIColor(red:0.09, green:0.08, blue:0.08, alpha:1.0)
        
        add(subview: containerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 1),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 3),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -3),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -1)
            ]}
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




