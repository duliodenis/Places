//
//  LocationAnnotationView.h
//  Places
//
//  Created by Dulio Denis on 7/27/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationAnnotationView : UIView

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *subtitle;

- (void)setupAnnotationView:(NSString *)title subtitle:(NSString *)subtitle;

@end
