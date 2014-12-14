//
//  PTTAssetCollectionViewCell.m
//  PTTAssetLibraryViewer
//
//  Created by Ivan Chernov on 14.12.14.
//  Copyright (c) 2014 iC. All rights reserved.
//

#import "PTTAssetCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface PTTAssetCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ALAsset *asset;
@end

@implementation PTTAssetCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setPhoto:(ALAsset *)photoAsset {
    if (_asset != photoAsset)
    {
        [self setImage:nil];
        _asset = photoAsset;
        __block __typeof(&*self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
            ALAssetRepresentation *rep = [photoAsset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            if (iref) {
                [weakSelf setImage: [UIImage imageWithCGImage:iref]];
            }
        });
    }
}

- (void)setImage:(UIImage *)image {
    if (image)
        _imageView.image = image;
    else
        _imageView.image = [UIImage imageNamed:@"sticker_placeholder"];
}

@end
