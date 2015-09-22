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
    
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor colorWithWhite:0 alpha:0.5]];
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

    NSMutableArray *views = [NSMutableArray new];
    
    
    InstructionViewController *firstView = [InstructionViewController new];
    firstView.title = @"Hello";
//    [firstView.view setBackgroundColor:[UIColor redColor]];
    [views addObject:firstView];
    
    InstructionViewController *secondView = [InstructionViewController new];
    secondView.title = @"Good Afternoon";
//    [secondView.view setBackgroundColor:[UIColor orangeColor]];
    [views addObject:secondView];
    
    InstructionViewController *thirdView = [InstructionViewController new];
    thirdView.title = @"Good night";
//    [thirdView.view setBackgroundColor:[UIColor yellowColor]];
    [views addObject:thirdView];
    
    
    self.instructionViews = views;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UIPageViewControllerDataSource

//- (UIViewController*) viewControllerAtIndex:(NSUInteger)index {
//    return (index >= 0 && index < self.instructionViews.count) ? [self.instructionViews objectAtIndex:index] :;
//}

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
    return 0;
//    return [self.instructionViews indexOfObject:pageViewController];;
}

@end
