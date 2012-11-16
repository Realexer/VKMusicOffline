//
//  AuthorizationViewController.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/28/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "AuthorizationViewController.h"

@interface AuthorizationViewController ()

@end

@implementation AuthorizationViewController

@synthesize webView;

-(void) viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];

    [webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oauth.vk.com/authorize?client_id=3098144&scope=audio&redirect_uri=oauth.vk.com/blank.html&response_type=token"]]];
}


-(void) webViewDidFinishLoad:(UIWebView *) _webView 
{
    
    NSMutableDictionary* user = [[NSMutableDictionary alloc] init];
    
    NSString *currentURL = self.webView.request.URL.absoluteString;
    NSRange textRange =[[currentURL lowercaseString] rangeOfString:[@"access_token" lowercaseString]];
    
    if(textRange.location != NSNotFound){
        //Ура, содержится, вытягиваем ее
        NSArray* data = [currentURL componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];		
        [user setObject:[data objectAtIndex:1] forKey:@"access_token"];
        [user setObject:[data objectAtIndex:3] forKey:@"expires_in"];
        [user setObject:[data objectAtIndex:5] forKey:@"user_id"];

        [self.navigationController popViewControllerAnimated:YES];
        
        [[VKAPIClient sharedInstance] saveUserAuthData:user];
    }
    else 
    {
        //
        textRange = [[currentURL lowercaseString] rangeOfString:[@"access_denied" lowercaseString]];
        if (textRange.location != NSNotFound) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ooops! something gonna wrong..." message:@"Check your internet connection and try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

-(void) dealloc 
{
    [super dealloc];
    [webView release];
}

@end
