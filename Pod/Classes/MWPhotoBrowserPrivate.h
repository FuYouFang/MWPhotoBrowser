//
//  MWPhotoBrowser_Private.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MWGridViewController.h"
#import "MWZoomingScrollView.h"
#import <AVKit/AVKit.h>

// Declare private methods of browser
@interface MWPhotoBrowser () {
    
	// Data
    NSUInteger _photoCount;
    NSMutableArray *_photos;
    NSMutableArray *_thumbPhotos;
	NSArray *_fixedPhotosArray; // Provided via init
	
	// Views
	UIScrollView *_pagingScrollView;
	
	// Paging & layout
    /** MWZoomingScroolView */
    NSMutableSet *_visiblePages;
    NSMutableSet*_recycledPages;
	NSUInteger _currentPageIndex;
    // 更换图片时的上一张图片
    NSUInteger _previousPageIndex;
    CGRect _previousLayoutBounds;
    /** 发生旋转之前的 Index */
	NSUInteger _pageIndexBeforeRotation;
	
	// Navigation & controls
	UIToolbar *_toolbar;
	NSTimer *_controlVisibilityTimer;
	UIBarButtonItem *_previousButton, *_nextButton, *_actionButton, *_doneButton;
    MBProgressHUD *_progressHUD;
    
    // Grid
    MWGridViewController *_gridController;
    UIBarButtonItem *_gridPreviousLeftNavItem;
    UIBarButtonItem *_gridPreviousRightNavItem;
    
    // Appearance
    BOOL _previousNavBarHidden;
    BOOL _previousNavBarTranslucent;
    UIBarStyle _previousNavBarStyle;
    /** 上一个 Controller 的 statusBarStyle 的样式 */
    UIStatusBarStyle _previousStatusBarStyle;
    UIColor *_previousNavBarTintColor;
    UIColor *_previousNavBarBarTintColor;
    /** 上个控制器返回按钮，（可能会改掉，所有要保留） */
    UIBarButtonItem *_previousViewControllerBackButton;
    UIImage *_previousNavigationBarBackgroundImageDefault;
    UIImage *_previousNavigationBarBackgroundImageLandscapePhone;
    

    // Video
    // NS_DEPRECATED_IOS(3_2, 9_0, "Use AVPlayerViewController in AVKit.")
    MPMoviePlayerViewController *_currentVideoPlayerViewController;
    NSUInteger _currentVideoIndex;
    // NS_CLASS_AVAILABLE_IOS(2_0)
    UIActivityIndicatorView *_currentVideoLoadingIndicator;
    
    // Misc
    BOOL _hasBelongedToViewController;
    BOOL _isVCBasedStatusBarAppearance;
    BOOL _statusBarShouldBeHidden;
    BOOL _displayActionButton;
    // 上一个 Controller 是否是隐藏的
    BOOL _leaveStatusBarAlone;
    /** 是否正在设置界面信息 */
	BOOL _performingLayout;
	BOOL _rotating;
    BOOL _viewIsActive; // active as in it's in the view heirarchy
    // 是否保存了上个 navbar 的样式
    BOOL _didSavePreviousStateOfNavBar;
    BOOL _skipNextPagingScrollViewPositioning;
    /** view 是否显示完成 */
    BOOL _viewHasAppearedInitially;
    CGPoint _currentGridContentOffset;
    
}

// Properties
@property (nonatomic) UIActivityViewController *activityViewController;

// Layout
- (void)layoutVisiblePages;
- (void)performLayout;
- (BOOL)presentingViewControllerPrefersStatusBarHidden;

// Nav Bar Appearance
- (void)setNavBarAppearance:(BOOL)animated;
- (void)storePreviousNavBarAppearance;
- (void)restorePreviousNavBarAppearance:(BOOL)animated;

// Paging
- (void)tilePages;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (MWZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index;
- (MWZoomingScrollView *)pageDisplayingPhoto:(id<MWPhoto>)photo;
- (MWZoomingScrollView *)dequeueRecycledPage;
- (void)configurePage:(MWZoomingScrollView *)page forIndex:(NSUInteger)index;
- (void)didStartViewingPageAtIndex:(NSUInteger)index;

// Frames
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;
- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index;
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation;
- (CGRect)frameForCaptionView:(MWCaptionView *)captionView atIndex:(NSUInteger)index;
- (CGRect)frameForSelectedButton:(UIButton *)selectedButton atIndex:(NSUInteger)index;

// Navigation
- (void)updateNavigation;
- (void)jumpToPageAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)gotoPreviousPage;
- (void)gotoNextPage;

// Grid
- (void)showGrid:(BOOL)animated;
- (void)hideGrid;

// Controls
- (void)cancelControlHiding;
- (void)hideControlsAfterDelay;
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent;
- (void)toggleControls;
- (BOOL)areControlsHidden;

// Data
- (NSUInteger)numberOfPhotos;
- (id<MWPhoto>)photoAtIndex:(NSUInteger)index;
- (id<MWPhoto>)thumbPhotoAtIndex:(NSUInteger)index;
- (UIImage *)imageForPhoto:(id<MWPhoto>)photo;
- (BOOL)photoIsSelectedAtIndex:(NSUInteger)index;
- (void)setPhotoSelected:(BOOL)selected atIndex:(NSUInteger)index;
- (void)loadAdjacentPhotosIfNecessary:(id<MWPhoto>)photo;
- (void)releaseAllUnderlyingPhotos:(BOOL)preserveCurrent;

@end

