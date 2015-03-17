//
//  ViewController.m
//  downloadtest
//
//  Created by Cameron Macdonell on 2015-03-17.
//  Copyright (c) 2015 Cameron Macdonell. All rights reserved.
//

#import "ViewController.h"
#import "SSZipArchive.h"
#import "JSONViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURLSession *session = [NSURLSession sharedSession];
    //
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"http://192.168.1.24/foo/foo.txt"] completionHandler:^(NSData *data,NSURLResponse *response, NSError * error){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        labelone.text = [NSString stringWithFormat:@"Version %@", [json objectForKey:@"version"]];
        int version = [[json objectForKey:@"version"] intValue];
        NSLog(@"%@", [NSString stringWithFormat:@"Version %d", version]);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        int prevVer = [[defaults objectForKey:@"version"] intValue];
        
        if (version > prevVer) {
            NSLog(@"Oooh, we need to update %d %d", prevVer, version);
            [defaults setInteger:version forKey:@"version"];
            [defaults synchronize];
            [self updateDocPack:version withSession:session];
        } else {
            NSLog(@"All good");
            JSONViewController * controller = (JSONViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"JSONViewController"];
            [self presentViewController:controller animated:YES completion:nil];

        }
    }];
    
    [dataTask resume];
    labelone.text = [NSString stringWithFormat:@"Version ?"];
}

- (void)updateDocPack:(int)newVer withSession:(NSURLSession *)session {

    NSLog(@"Updating to %d", newVer);
    NSString *urlToZip = [NSString stringWithFormat:@"http://192.168.1.24/foo/ver%d.zip",newVer];
    NSURLSessionDataTask *zipTask = [session dataTaskWithURL:[NSURL URLWithString:urlToZip] completionHandler:^(NSData *data,NSURLResponse *response, NSError * error){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
        
        NSLog(@"Storing file to %@", zipPath);
        [data writeToFile:zipPath options:0 error:&error];
        NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *destinationPath= [docpaths lastObject];
        NSLog(@"Unzipping to %@", destinationPath);
        [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
        
        JSONViewController * controller = (JSONViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"JSONViewController"];
        [self presentViewController:controller animated:YES completion:nil];
    }];
    [zipTask resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
