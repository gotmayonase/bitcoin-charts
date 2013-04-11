//
//  ViewController.h
//  bitcoin-charts
//
//  Created by Mike Mayo on 4/10/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"

@interface ViewController : UIViewController <SocketIODelegate>

@property (nonatomic, strong) IBOutlet UILabel *lagLabel;

@end
