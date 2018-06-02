//
//  ViewController.swift
//  swift-slide-menu-sample
//
//  Created by devWill on 2018/06/02.
//  Copyright © 2018年 devWill. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Property
    var menuController = MenuViewController()
    
    // menuViewの幅
    var menuWidth: CGFloat = 0
    
    var isMenuExpanded: Bool = false
    let overlayView = UIView()
    
    // MARK: - IBAction
    @IBAction func tappedHamburegerMenu(_ sender: UIBarButtonItem) {
        toggleMenu()
    }
    @IBAction func panLeft(_ sender: UIScreenEdgePanGestureRecognizer) {
        let move:CGPoint = sender.translation(in: view)
        let x: CGFloat = -menuWidth
        let alpha:CGFloat = 0
        
        swipeAnimation(state: sender.state, move: move, x: x, alpha: alpha)
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // menuViewの幅を設定
        menuWidth = self.view.bounds.width * 2 / 3
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        self.navigationController?.view.addSubview(overlayView)
        
        // menuViewControllerの設定
        let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        menuController = menuStoryboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        self.menuController.view.frame = CGRect(x: -self.view.bounds.width, y: 0, width:self.view.bounds.width, height: UIScreen.main.bounds.height)
        self.navigationController?.view.addSubview(self.menuController.view)
        self.menuController.didMove(toParentViewController: self)
        
        configureGestures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        overlayView.frame = UIScreen.main.bounds
    }
    
    // メニューの表示/非表示
    func toggleMenu() {
        isMenuExpanded = !isMenuExpanded
        let x: CGFloat = (isMenuExpanded) ? 0.0 : -self.view.bounds.width
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.menuController.view.frame = CGRect(x: x, y: 0, width: self.menuWidth, height: UIScreen.main.bounds.height)
            self.overlayView.alpha = (self.isMenuExpanded) ? 0.5 : 0.0
        }, completion: nil)
        
    }
    
    // ジェスチャーの設定
    fileprivate func configureGestures() {
        let swipeLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(didSwipeLeft(sender:)))
        overlayView.addGestureRecognizer(swipeLeftGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    // OverlayViewスワイプ時
    @objc fileprivate func didSwipeLeft(sender: UIPanGestureRecognizer) {
        let move:CGPoint = sender.translation(in: view)
        let x: CGFloat = 0
        let alpha:CGFloat = 0.5
        
        swipeAnimation(state: sender.state, move: move, x: x, alpha: alpha)
    }
    
    // OverlayViewタップ時
    @objc fileprivate func didTapOverlay() {
        toggleMenu()
    }
    
    private func swipeAnimation(state: UIGestureRecognizerState, move: CGPoint, x: CGFloat, alpha: CGFloat) {
        // 移動量を取得する。
        var x: CGFloat = x
        var alpha: CGFloat = alpha
        
        // 画面表示を更新する。
        self.view.layoutIfNeeded()
        
        // 位置の制約に水平方向の移動量を加算する。
        x += move.x
        alpha += move.x / self.view.bounds.width * 2 / 3
        
        if(x > 0.0){
            x = 0.0
            alpha = 0.5
        }
        
        self.menuController.view.frame = CGRect(x: x, y: 0, width: menuWidth, height: UIScreen.main.bounds.height)
        overlayView.alpha = alpha
        
        // ドラッグ終了時の処理
        if(state == UIGestureRecognizerState.ended) {
            if(x < -view.frame.size.width * 2 / 5) {
                // ドラッグの距離が画面幅の2/5に満たない場合はビューを画面外に戻す。
                UIView.animate(withDuration: 0.3,animations: {
                    x = -self.view.bounds.width
                    self.menuController.view.frame = CGRect(x: x, y: 0, width: self.menuWidth, height: UIScreen.main.bounds.height)
                    self.overlayView.alpha = 0.0
                    self.isMenuExpanded = false
                },completion:nil)
            } else {
                // ドラッグの距離が画面幅の2/5以上の場合はそのままビューを表示する。
                UIView.animate(withDuration: 0.3,animations: {
                    x = 0.0
                    self.menuController.view.frame = CGRect(x: x, y: 0, width: self.menuWidth, height: UIScreen.main.bounds.height)
                    self.overlayView.alpha = 0.5
                    self.isMenuExpanded = true
                },completion:nil)
            }
        }
    }
}

