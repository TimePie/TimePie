//
//  MainScreenViewController.h
//  TimePie
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreenViewController : UIViewController
{
    IBOutlet UIButton *personal;
    IBOutlet UIButton *stats;
    IBOutlet UIButton *create;
}



- (IBAction)personal_btn_clicked:(id)sender;
- (IBAction)stats_btn_clicked:(id)sender;
- (IBAction)create_btn_clicked:(id)sender;


@end
