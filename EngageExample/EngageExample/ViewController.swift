//
//  ViewController.swift
//  EngageExample
//
//  Created by Kari Bengs on 15/02/2019.
//  Copyright © 2019 Adeprimo. All rights reserved.
//

import UIKit
import TuloEngageTracker

class ViewController: UIViewController {
    
    var startTime = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TuloEngageTracker.shared.setUser(userId: "123456", persist: true)
        TuloEngageTracker.shared.setContent(state: "test", articleId: "123")
        TuloEngageTracker.shared.trackPageView(url: "/start")
       
    }

    @IBAction func onClick(_ sender: UIButton) {
        TuloEngageTracker.shared.setProductId(productId: "PEIWEI")
        TuloEngageTracker.shared.trackArticleInteraction(type: "related_article")
        TuloEngageTracker.shared.trackArticleActiveTime(startTime: startTime, endTime: Date())
        TuloEngageTracker.shared.trackEvent(name: "test", customData: "{\"data\": {\"first\": 1}}")
    }
    
    @IBAction func onNextClick(_ sender: UIButton) {
        TuloEngageTracker.shared.setProductId(productId: "TEST_PEIWEI")
        TuloEngageTracker.shared.setContent(state: "new content")
        TuloEngageTracker.shared.trackEventWithContentData(name: "app:click", url: "/next")
    }
    
    @IBAction func onFirstClick(_ sender: UIButton) {
        TuloEngageTracker.shared.setContent(state: "new content")
        TuloEngageTracker.shared.trackEventWithContentData(name: "app:click", url: "/start")
    }
    
}

