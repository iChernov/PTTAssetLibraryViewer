//
//  PTTAssetCollectionViewCell.h
//  PTTAssetLibraryViewer
//
//  Created by Ivan Chernov on 14.12.14.
//  Copyright (c) 2014 iC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTTAssetCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
