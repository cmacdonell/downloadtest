//
//  JSONViewController.m
//  downloadtest
//
//  Created by Cameron Macdonell on 2015-03-17.
//  Copyright (c) 2015 Cameron Macdonell. All rights reserved.
//

#import "JSONViewController.h"

@interface JSONViewController ()

@end

@implementation JSONViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    labeltwo.text = @"All done!";
    NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [docpaths lastObject];
    NSString *jsonPath = [filePath stringByAppendingPathComponent:@"data/protocols.json"];
    //    NSLog(@"%@", filePath);
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    //    NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
    //    NSLog(@"%@", newStr);
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@", json);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
