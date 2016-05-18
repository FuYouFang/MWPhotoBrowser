//
//  Menu.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 21/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Photos/Photos.h>
#import "Menu.h"
#import "SDImageCache.h"
#import "MWCommon.h"

@implementation Menu

#pragma mark -
#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		self.title = @"MWPhotoBrowser";
        
        // Clear cache for testing
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Push", @"Modal", nil]];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_segmentedControl];
        self.navigationItem.rightBarButtonItem = item;
        // 1.设置导航返回的title
        // 2.返回的 Item 的taget 和 action 都是空
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];

        [self loadAssets];
        
    }
    return self;
}

- (void)segmentChange {
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Test toolbar hiding
//    [self setToolbarItems: @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil]]];
//    [[self navigationController] setToolbarHidden:NO animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 9;
    @synchronized(_assets) {
        if (_assets.count) rows++;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// Create
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = _segmentedControl.selectedSegmentIndex == 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;

    // Configure
	switch (indexPath.row) {
		case 0: {
            cell.textLabel.text = @"Single photo";
            cell.detailTextLabel.text = @"with caption, no grid button";
            break;
        }
		case 1: {
            cell.textLabel.text = @"Multiple photos and video";
            cell.detailTextLabel.text = @"with captions";
            break;
        }
		case 2: {
            cell.textLabel.text = @"Multiple photo grid";
            cell.detailTextLabel.text = @"showing grid first, nav arrows enabled";
            break;
        }
		case 3: {
            cell.textLabel.text = @"Photo selections";
            cell.detailTextLabel.text = @"selection enabled";
            break;
        }
		case 4: {
            cell.textLabel.text = @"Photo selection grid";
            cell.detailTextLabel.text = @"selection enabled, start at grid";
            break;
        }
		case 5: {
            cell.textLabel.text = @"Web photos";
            cell.detailTextLabel.text = @"photos from web";
            break;
        }
        case 6: {
            cell.textLabel.text = @"Web photo grid";
            cell.detailTextLabel.text = @"showing grid first";
            break;
        }
        case 7: {
            cell.textLabel.text = @"Single video";
            cell.detailTextLabel.text = @"with auto-play";
            break;
        }
        case 8: {
            cell.textLabel.text = @"Web videos";
            cell.detailTextLabel.text = @"showing grid first";
            break;
        }
		case 9: {
            cell.textLabel.text = @"Library photos and videos";
            cell.detailTextLabel.text = @"media from device library";
            break;
        }
		default: break;
	}
    return cell;
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Browser
	NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo, *thumb;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
	switch (indexPath.row) {
		case 0:
            // Photos
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2" ofType:@"jpg"]]];
            photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
			[photos addObject:photo];
            // Options
            enableGrid = NO;
			break;
		case 1: {
            // Local Photos and Videos
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo5" ofType:@"jpg"]]];
            photo.caption = @"Fireworks";
			[photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2" ofType:@"jpg"]]];
            photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
			[photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo3" ofType:@"jpg"]]];
            photo.caption = @"York Floods";
            [photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video_thumb" ofType:@"jpg"]]];
            photo.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
            photo.caption = @"Big Buck Bunny";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo4" ofType:@"jpg"]]];
            photo.caption = @"Campervan";
			[photos addObject:photo];
            // Options
            enableGrid = NO;
			break;
        }
		case 2: {
            // Photos
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo5" ofType:@"jpg"]]];
            photo.caption = @"White Tower";
			[photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2" ofType:@"jpg"]]];
            photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
			[photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo3" ofType:@"jpg"]]];
            photo.caption = @"York Floods";
			[photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo4" ofType:@"jpg"]]];
            photo.caption = @"Campervan";
			[photos addObject:photo];
            // Thumbs
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo5t" ofType:@"jpg"]]];
			[thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo2t" ofType:@"jpg"]]];
			[thumbs addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo3t" ofType:@"jpg"]]];
			[thumbs addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo4t" ofType:@"jpg"]]];
			[thumbs addObject:photo];
            // Options
            startOnGrid = YES;
            displayNavArrows = YES;
			break;
        }
		case 3:
		case 4: {
            // Photos
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo4" ofType:@"jpg"]]];
			[photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo1" ofType:@"jpg"]]];
			[photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2" ofType:@"jpg"]]];
			[photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo3" ofType:@"jpg"]]];
			[photos addObject:photo];
            // Thumbs
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo4t" ofType:@"jpg"]]];
			[thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo1t" ofType:@"jpg"]]];
			[thumbs addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2t" ofType:@"jpg"]]];
			[thumbs addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo3t" ofType:@"jpg"]]];
			[thumbs addObject:photo];
            // Options
            displayActionButton = NO;
            displaySelectionButtons = YES;
            startOnGrid = indexPath.row == 4;
            enableGrid = NO;
			break;
        }
		case 5:
            // Photos
			[photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3567/3523321514_371d9ac42f_b.jpg"]]];
			[photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3629/3339128908_7aecabc34b_b.jpg"]]];
			[photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3364/3338617424_7ff836d55f_b.jpg"]]];
			[photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b_b.jpg"]]];
			[photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm3.static.flickr.com/2449/4052876281_6e068ac860_b.jpg"]]];
            // Thumbs
			[thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3567/3523321514_371d9ac42f_q.jpg"]]];
			[thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3629/3339128908_7aecabc34b_q.jpg"]]];
			[thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3364/3338617424_7ff836d55f_q.jpg"]]];
			[thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b_q.jpg"]]];
			[thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm3.static.flickr.com/2449/4052876281_6e068ac860_q.jpg"]]];
            // Options
			break;
		case 6:
            // Photos & thumbs
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3779/9522424255_28a5a9d99c_b.jpg"]];
            photo.caption = @"Tube";
            [photos addObject:photo];
            [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3779/9522424255_28a5a9d99c_q.jpg"]]];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3777/9522276829_fdea08ffe2_b.jpg"]];
            photo.caption = @"Flat White at Elliot's";
            [photos addObject:photo];
            [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3777/9522276829_fdea08ffe2_q.jpg"]]];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm9.static.flickr.com/8379/8530199945_47b386320f_b.jpg"]];
            photo.caption = @"Woburn Abbey";
            [photos addObject:photo];
            [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm9.static.flickr.com/8379/8530199945_47b386320f_q.jpg"]]];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm9.static.flickr.com/8364/8268120482_332d61a89e_b.jpg"]];
            photo.caption = @"Frosty walk";
            [photos addObject:photo];
            [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm9.static.flickr.com/8364/8268120482_332d61a89e_q.jpg"]]];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm8.static.flickr.com/7109/7604416018_f23733881b_b.jpg"]];
            photo.caption = @"Jury's Inn";
            [photos addObject:photo];
            [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm8.static.flickr.com/7109/7604416018_f23733881b_q.jpg"]]];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm7.static.flickr.com/6002/6020924733_b21874f14c_b.jpg"]];
            photo.caption = @"Heavy Rain";
            [photos addObject:photo];
            [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm7.static.flickr.com/6002/6020924733_b21874f14c_q.jpg"]]];
            
            // Options
            startOnGrid = YES;
			break;
        case 7: {
            
            // Single video
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video_thumb" ofType:@"jpg"]]];
            photo.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
            [photos addObject:photo];
            enableGrid = NO;
            autoPlayOnAppear = YES;
            break;
            
        }
		case 8: {
            
            // Videos
            
            photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xpt1/t51.2885-15/e15/11192696_824079697688618_1761661_n.jpg"]];
            photo.videoURL = [[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xpa1/t50.2886-16/11200303_1440130956287424_1714699187_n.mp4"];
            [photos addObject:photo];
            thumb = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xpt1/t51.2885-15/s150x150/e15/11192696_824079697688618_1761661_n.jpg"]];
            thumb.isVideo = YES;
            [thumbs addObject:thumb];

            photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11240463_963135443745570_1519872157_n.jpg"]];
            photo.videoURL = [[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xfa1/t50.2886-16/11237510_945154435524423_2137519922_n.mp4"];
            [photos addObject:photo];
            thumb = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s150x150/e15/11240463_963135443745570_1519872157_n.jpg"]];
            thumb.isVideo = YES;
            [thumbs addObject:thumb];
            
            photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11313531_1625089227727682_169403963_n.jpg"]];
            photo.videoURL = [[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xfa1/t50.2886-16/11336249_1783839318509644_116225363_n.mp4"];
            [photos addObject:photo];
            thumb = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:@"https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s150x150/e15/11313531_1625089227727682_169403963_n.jpg"]];
            thumb.isVideo = YES;
            [thumbs addObject:thumb];
            
            // Options
            startOnGrid = YES;
            break;
        }
		case 9: {
            @synchronized(_assets) {
                NSMutableArray *copy = [_assets copy];
                if (NSClassFromString(@"PHAsset")) { // NS_CLASS_AVAILABLE_IOS(8_0) @interface PHAsset
                    // Photos library
                    UIScreen *screen = [UIScreen mainScreen];
                    CGFloat scale = screen.scale;
                    // Sizing is very rough... more thought required in a real implementation
                    CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
                    CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
                    CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale);
                    for (PHAsset *asset in copy) {
                        [photos addObject:[MWPhoto photoWithAsset:asset targetSize:imageTargetSize]];
                        [thumbs addObject:[MWPhoto photoWithAsset:asset targetSize:thumbTargetSize]];
                    }
                } else {
                    // Assets library
                    for (ALAsset *asset in copy) { // NS_CLASS_DEPRECATED_IOS(4_0, 9_0)
                        MWPhoto *photo = [MWPhoto photoWithURL:asset.defaultRepresentation.url];
                        [photos addObject:photo];
                        MWPhoto *thumb = [MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.thumbnail]];
                        [thumbs addObject:thumb];
                        // 对视频的的处理
                        if ([asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
                            photo.videoURL = asset.defaultRepresentation.url;
                            thumb.isVideo = true;
                        }
                    }
                }
            }
			break;
        }
		default: break;
	}
    self.photos = photos;
    self.thumbs = thumbs;
	
	// Create browser
	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];
    
    // Test custom selection images
//    browser.customImageSelectedIconName = @"ImageSelected.png";
//    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Reset selections
    // 重置选中的 photos
    if (displaySelectionButtons) {
        _selections = [NSMutableArray new];
        for (int i = 0; i < photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    // Show
    if (_segmentedControl.selectedSegmentIndex == 0) {
        // Push
        [self.navigationController pushViewController:browser animated:YES];
    } else {
        self.modalPresentationStyle = UIModalPresentationPageSheet;
        // Modal
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        // 弹出的方式是相互融合
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    }
    
    // Release
	
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Test reloading of data after delay
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
//        // Test removing an object
//        [_photos removeLastObject];
//        [browser reloadData];
//    
//        // Test all new
//        [_photos removeAllObjects];
//        [_photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo3" ofType:@"jpg"]]];
//        [browser reloadData];
//    
//        // Test changing photo index
//        [browser setCurrentPhotoIndex:9];
    
//        // Test updating selections
//        _selections = [NSMutableArray new];
//        for (int i = 0; i < [self numberOfPhotosInPhotoBrowser:browser]; i++) {
//            [_selections addObject:[NSNumber numberWithBool:YES]];
//        }
//        [browser reloadData];
        
    });

}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Load Assets

- (void)loadAssets {
    if (NSClassFromString(@"PHAsset")) {
        
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self performLoadAssets];
        }
        
    } else {
        
        // Assets library
        [self performLoadAssets];
        
    }
}

- (void)performLoadAssets {
    
    // Initialise
    _assets = [NSMutableArray new];
    
    // Load
    if (NSClassFromString(@"PHAsset")) {
        
        // Photos library iOS >= 8
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
            [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_assets addObject:obj];
            }];
            if (fetchResults.count > 0) {
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        });
        
    } else {
        
        // Assets Library iOS < 8
        _ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Run in the background as it takes a while to get all assets from the library
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
            NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
            
            // Process assets
            void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto] || [assetType isEqualToString:ALAssetTypeVideo]) {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url = result.defaultRepresentation.url;
                        [_ALAssetsLibrary assetForURL:url
                                          resultBlock:^(ALAsset *asset) {
                                              if (asset) {
                                                  @synchronized(_assets) {
                                                      [_assets addObject:asset];
                                                      if (_assets.count == 1) {
                                                          // Added first asset so reload data
                                                          [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                                      }
                                                  }
                                              }
                                          }
                                         failureBlock:^(NSError *error){
                                             NSLog(@"operation was not successfull!");
                                         }];
                        
                    }
                }
            };
            
            // Process groups
            void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                    [assetGroups addObject:group];
                }
            };
            
            // Process!
            [_ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                            usingBlock:assetGroupEnumerator
                                          failureBlock:^(NSError *error) {
                                              NSLog(@"There is an error");
                                          }];
            
        });
        
    }
    
}

@end

