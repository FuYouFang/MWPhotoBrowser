//
//  MWPhotoProtocol.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notifications
#define MWPHOTO_LOADING_DID_END_NOTIFICATION @"MWPHOTO_LOADING_DID_END_NOTIFICATION"
#define MWPHOTO_PROGRESS_NOTIFICATION @"MWPHOTO_PROGRESS_NOTIFICATION"

// If you wish to use your own data models for photo then they must conform
// to this protocol. See instructions for details on each method.
// Otherwise you can use the MWPhoto object or subclass it yourself to
// store more information per photo.
//
// You can see the MWPhoto class for an example implementation of this protocol
//
@protocol MWPhoto <NSObject>

@required

/**
 *  返回下面一张图片用于展示
 *  如果这个图片不是能够立马获取到的（需要加载进内存，提供解压好的图片），或者需要从资源处加载（缓存，文件，网络，等等）
 *  重要：从其他资源获取图片时，不应该用这个方法去初始化
 *  这个方法返回为空时， photo browser  -loadUnderlyingImageAndNotify: 将会调用这个接口
 */
// Return underlying UIImage to be displayed
// Return nil if the image is not immediately available (loaded into memory, preferably
// already decompressed) and needs to be loaded from a source (cache, file, web, etc)
// IMPORTANT: You should *NOT* use this method to initiate
// fetching of images from any external of source. That should be handled
// in -loadUnderlyingImageAndNotify: which may be called by the photo browser if this
// methods returns nil.
@property (nonatomic, strong) UIImage *underlyingImage;

// Called when the browser has determined the underlying images is not
// already loaded into memory but needs it.
- (void)loadUnderlyingImageAndNotify;

// Fetch the image data from a source and notify when complete.
// You must load the image asyncronously (and decompress it for better performance).
// It is recommended that you use SDWebImageDecoder to perform the decompression.
// See MWPhoto object for an example implementation.
// When the underlying UIImage is loaded (or failed to load) you should post the following
// notification:
// [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
//                                                     object:self];
- (void)performLoadUnderlyingImageAndNotify;

// 当图片浏览决定不需要这个图片数据的时候，或者内存不足的时候，将会调用这个方法
// 只要图片可以重新加载，就应该释放掉放在下面的图片数据（比较大的，或者压缩的）
// This is called when the photo browser has determined the photo data
// is no longer needed or there are low memory conditions
// You should release any underlying (possibly large and decompressed) image data
// as long as the image can be re-loaded (from cache, file, or URL)
- (void)unloadUnderlyingImage;

@optional

// If photo is empty, in which case, don't show loading error icons
@property (nonatomic) BOOL emptyImage;

// Video
@property (nonatomic) BOOL isVideo;
- (void)getVideoURL:(void (^)(NSURL *url))completion;

// Return a caption string to be displayed over the image
// Return nil to display no caption
- (NSString *)caption;

// Cancel any background loading of image data
- (void)cancelAnyLoading;

@end