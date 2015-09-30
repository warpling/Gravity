//
//  InstructionsViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "InstructionsViewController.h"
#import "InstructionViewController.h"
#import "TitleViewController.h"
#import "Track.h"

@interface InstructionsViewController ()

@property (strong, nonatomic) NSArray *instructionViews;
@property (strong, nonatomic) UIPageViewController *pageController;

@end

@implementation InstructionsViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [self.pageController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.pageController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor gravityPurple]];
    
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.2]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.9]];
    [[UIPageControl appearance] setBackgroundColor:[UIColor clearColor]];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Track instructionsViewed];
}

- (void) setupWithCalibrationViewController:(CalibrationViewController*)calibrationViewController {
    InstructionViewController *preView   = [self titleInstructionViewController];
    InstructionViewController *firstView = [self firstInstructionViewController];
    InstructionViewController *thirdView = [self thirdInstructionViewController];
    
    [calibrationViewController setOnCalibrationFinished:^{
        [self advancePage];
    }];

    
    self.instructionViews = @[preView, firstView, calibrationViewController, thirdView];

    NSArray *initialInstructionView = @[self.instructionViews.firstObject];
    [self.pageController setViewControllers:initialInstructionView direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    self.pageController.dataSource = self;
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (InstructionViewController*) titleInstructionViewController {
    TitleViewController *titleView = [TitleViewController new];
    [titleView setContinueButtonAction:^{
        [self advancePage];
    }];
    return titleView;
}

- (InstructionViewController*) firstInstructionViewController {
    UIFont *normalCaptionFont = [UIFont fontWithName:AvenirNextMedium size:22];
    UIFont *boldCaptionFont = [UIFont fontWithName:AvenirNextDemiBold size:22];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    InstructionViewController *firstView = [InstructionViewController new];
    NSMutableAttributedString *attributedTextCaption1 = [[NSMutableAttributedString alloc] initWithString:@"Before the fun begins we need to calibrate your device using a few common household items\n\n"
                                                                                               attributes:@{
                                                                                                            NSFontAttributeName: boldCaptionFont,
                                                                                                            NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                            NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                            }];
    
    [attributedTextCaption1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"You'll need:\n\n• a flat surface\n• a metal spoon\n• 4 quarters\n\n"
                                                                                          attributes:@{
                                                                                                       NSFontAttributeName: normalCaptionFont,
                                                                                                       NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                       NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                       }]];
    [firstView.contentTextView setAttributedText:attributedTextCaption1];
    
    [firstView setContinueButtonText:@"Begin"];
    [firstView setContinueButtonAction:^{
        [self advancePage];
    }];
    
    return firstView;
}

- (InstructionViewController*) thirdInstructionViewController {
    UIFont *smallerCaptionFont = [UIFont fontWithName:AvenirNextRegular size:18];
    UIFont *boldCaptionFont = [UIFont fontWithName:AvenirNextDemiBold size:22];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    InstructionViewController *thirdView = [InstructionViewController new];
    NSMutableAttributedString *attributedTextCaption3 = [[NSMutableAttributedString alloc] initWithString:@"Nice work!\n\nYou're ready to start weighing objects on your iPhone.\n\nIf you use a different spoon don't forget to recalibrate!\n\n"
                                                                                               attributes:@{
                                                                                                            NSFontAttributeName: boldCaptionFont,
                                                                                                            NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                            NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                            }];
    
    [attributedTextCaption3 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"(accuracy up to ±3g)"
                                                                                          attributes:@{
                                                                                                       NSFontAttributeName: smallerCaptionFont,
                                                                                                       NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                       NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                       }]];
    [thirdView.contentTextView setAttributedText:attributedTextCaption3];
    [thirdView setContinueButtonText:@"Start"];
    [thirdView setContinueButtonAction:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:Gravity_InstructionsCompleted];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }];
    
    return thirdView;
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
