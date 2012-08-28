//
//  AuthorizationViewController.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/28/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKAPIClient.h"

@interface AuthorizationViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView* webView;

@end
