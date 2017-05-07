//
//  EventDetailsViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 02.12.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var sliderView: UIView!
   
    @IBOutlet weak var aboutVenueLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UIButton!
    
    @IBOutlet weak var locationLabel: UIButton!
   
    var event:Event?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initEventData()
        createPageViewController()
        setupPageControl()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initEventData(){
       
        
        aboutVenueLabel.text = event?.partyName
        dateTimeLabel.setTitle(event?.date?.string(format: "h:mm a dd.MM.yyyy"), for: .normal);
        locationLabel.setTitle(event?.location, for: .normal);
    }
    
    
    fileprivate var pageViewController: UIPageViewController?
    
    // Initialize it right away here
//    fileprivate let contentImages:[String] = ["nature_pic_1",
//         "nature_pic_2",
//         "nature_pic_3",
//         "nature_pic_4"]
    
    
    
    fileprivate func createPageViewController() {
        
        
        
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "EventPageController") as! EventPageViewController
        pageController.dataSource = self
        
        if event?.photos?.count ?? 0 > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers = [firstController]
            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        pageViewController?.view.frame = sliderView.bounds;
        addChildViewController(pageViewController!)
        sliderView.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
    }
    
    fileprivate func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
        appearance.isUserInteractionEnabled = false
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //
        //        let itemController = viewController as! PageItemController
        //
        //        if itemController.itemIndex > 0 {
        //            return getItemController(itemController.itemIndex-1)
        //        }
        //
        //        return nil
        
        let pageContent: PageItemController? = viewController as? PageItemController
        guard var index = pageContent?.itemIndex else
        {
            return nil;
        }
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1;
        return getItemController(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let pageContent: PageItemController? = viewController as? PageItemController
        guard var index = pageContent?.itemIndex else{
            return nil;
        }
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1;
        if (index ==  event?.photos?.count)
        {
            return nil;
        }
        return getItemController(index)
        
        
        
    }
    
    fileprivate func getItemController(_ itemIndex: Int) -> PageItemController? {
        
        if itemIndex < event?.photos?.count ?? 0 {
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemController") as! PageItemController
            pageItemController.itemIndex = itemIndex
             //pageItemController.imageName = contentImages[0]
            
            
            if let urlStr = event?.photos?[itemIndex].url {
                pageItemController.imageUrl = urlStr;
            }
            
            
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return event?.photos?.count ?? 0;
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Additions
    
    //    func currentControllerIndex() -> Int {
    //
    //        let pageItemController = self.currentController()
    //
    //        if let controller = pageItemController as? PageItemController {
    //            return controller.itemIndex
    //        }
    //
    //        return -1
    //    }
    //
    //    func currentController() -> UIViewController? {
    //
    //        if self.pageViewController?.viewControllers?.count > 0 {
    //            return self.pageViewController?.viewControllers![0]
    //        }
    //
    //        return nil
    //    }
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        switch segue.destination {
        case is BuyLiquorViewController:
        let buyLiq = segue.destination as? BuyLiquorViewController
        if let bottles = event?.bottles{
             buyLiq?.eventId = event?.id
             buyLiq?.ticket = event?.tickets?.first
             buyLiq?.bottles = bottles
        }
            break
        case is BookTableViewController:
            let bookTab = segue.destination as? BookTableViewController
            if let tables = event?.tables{
                
                bookTab?.eventId = event?.id
                bookTab?.ticket = event?.tickets?.first
                bookTab?.tables = tables
            }
            break

        default:
            break
        }
     }
 
    
}
