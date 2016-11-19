//
//  Utility.m
//  MusicSearch
//
//  Created by Krunal on 11/19/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (UIAlertController*)createAlertView {
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Operation could not be completed because of connection problem." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alerController addAction:okAction];
    return alerController;
}


@end
