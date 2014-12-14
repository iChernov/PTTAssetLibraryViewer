//
//  PTTAssetViewDataSource.m
//  PTTAssetLibraryViewer
//
//  Created by Ivan Chernov on 14.12.14.
//  Copyright (c) 2014 iC. All rights reserved.
//

#import "PTTAssetViewDataSource.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>


@interface PTTAssetViewDataSource () 

@property (strong, nonatomic) NSMutableArray *assets;

@end

@implementation PTTAssetViewDataSource

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setupAssets];
    }
    
    return self;
}

- (void)setupAssets
{
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        return;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
    {
        if (asset)
        {
            [_assets addObject:asset];
        }
    };
    
    void (^enumerate)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos)
        {
            NSLog(@"Camera roll");
            [group enumerateAssetsUsingBlock:resultsBlock];
        }
    };
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:enumerate
                         failureBlock:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.assets.count;
    }
    else
        return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:CTAssetsViewCellIdentifier
                                              forIndexPath:indexPath];
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:shouldEnableAsset:)])
        cell.enabled = [self.picker.delegate assetsPickerController:self.picker shouldEnableAsset:asset];
    else
        cell.enabled = YES;
    
    if ([self.picker.selectedAssets containsObject:asset])
    {
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    [cell bind:asset];
    
    return cell;
}


@end
