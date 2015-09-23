//
//  InstructionsViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "InstructionsViewController.h"
#import "InstructionViewController.h"

@interface InstructionsViewController ()

@property (strong, nonatomic) NSArray *instructionViews;
@property (strong, nonatomic) UIPageViewController *pageController;

@end

@implementation InstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor gravityPurple]];
    
    [self generateInstructionViews];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.pageController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    NSArray *initialInstructionView = @[self.instructionViews.firstObject];
    [self.pageController setViewControllers:initialInstructionView direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageController.dataSource = self;
    
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.2]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.9]];
    [[UIPageControl appearance] setBackgroundColor:[UIColor clearColor]];

    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) generateInstructionViews {
    
    InstructionViewController *firstView = [InstructionViewController new];
    [firstView setTitleText:@"Hello"];
    [firstView setCaptionText:@"Ready to get weighing?"];
    [firstView setBottomButtonText:@"I'm listening"];
    [firstView setButtonAction:^{
        [self advancePage];
    }];
    
    InstructionViewController *secondView = [InstructionViewController new];
    [secondView setTitleText:@"Good Afternoon"];
    [secondView setCaptionText:@"First you gotta stop being such a basket case. How are we going to fix that you ask? Simple. We're going to build a basket."];
    [secondView setBottomButtonText:@"Let's test it!"];
    [secondView setButtonAction:^{
        [self advancePage];
    }];
    
    InstructionViewController *thirdView = [InstructionViewController new];
    [thirdView setTitleText:@"Buenas Noches"];
    [thirdView setCaptionText:@"Alright, you look confused and ready to go! Let's get weighing!"];
    [thirdView setBottomButtonText:@"Let's weigh!"];
    [thirdView setButtonAction:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:InstructionsCompleted];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }];
    
    self.instructionViews = @[firstView, secondView, thirdView];
}


- (void) advancePage {
    NSUInteger currentIndex = [self.instructionViews indexOfObject:[[self.pageController viewControllers] firstObject]];
    
    if (currentIndex <= (self.instructionViews.count - 1)) {
        NSArray *nextInstructionView = @[[self.instructionViews objectAtIndex:(currentIndex+1)]];
        [self.pageController setViewControllers:nextInstructionView direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

#pragma mark UIPageViewControllerDataSource

- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [self.instructionViews indexOfObject:viewController];
    return (currentIndex > 0) ? [self.instructionViews objectAtIndex:(currentIndex - 1)] : nil;
}

- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [self.instructionViews indexOfObject:viewController];
    return (currentIndex < (self.instructionViews.count-1)) ? [self.instructionViews objectAtIndex:(currentIndex + 1)] : nil;
}

- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.instructionViews count];
}

// Note: this is only used the first time the page views are manually set (that's why it makes sense to return 0)
- (NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    UIViewController *currentVC = pageViewController.viewControllers.firstObject;
    return [self.instructionViews indexOfObject:currentVC];
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
