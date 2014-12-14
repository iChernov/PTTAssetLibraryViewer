//
//  PTTAssetViewController.m
//  PTTAssetLibraryViewer
//
//  Created by Ivan Chernov on 14.12.14.
//  Copyright (c) 2014 iC. All rights reserved.
//

#import "PTTAssetViewController.h"
#import "PTTAssetViewDataSource.h"

@interface PTTAssetViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (strong, nonatomic) PTTAssetViewDataSource *dataSource;

@end

@implementation PTTAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.collectionViewLayout)
    {
        self.collectionView.collectionViewLayout = self.collectionViewLayout;
    }
    else
    {
        _collectionViewLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    //Add height constraint for collectionView (this cannot be done in storyboard, because it conflicts with the simulated size)
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.collectionViewContainer
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:layout.itemSize.height];
    [self.collectionViewContainer addConstraint:heightConstraint];
    
    self.collectionView.dataSource = (id <UICollectionViewDataSource>)self.dataSource;
    self.collectionView.delegate = self;
    [self dataSourceDidUpdate:self.dataSource];
}

- (void)dataSourceDidUpdate:(id <UICollectionViewDataSource>)dataSource
{
    [self.collectionView performBatchUpdates:^{
        NSUInteger currentNumberOfItems = (NSUInteger)[self.collectionView numberOfItemsInSection:0];
        
        if (currentNumberOfItems < [dataSource count])
        {
            // add new items
            NSMutableArray *indexPaths = [NSMutableArray array];
            
            for (NSUInteger row = currentNumberOfItems; row < [dataSource.data count]; row++)
            {
                [indexPaths addObject:[NSIndexPath indexPathForRow:(NSInteger)row inSection:0]];
            }
            
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
        }
        else if (currentNumberOfItems > [dataSource.data count])
        {
            // remove items
            NSMutableArray *indexPaths = [NSMutableArray array];
            
            for (NSUInteger row = [dataSource.data count]; row < currentNumberOfItems; row++)
            {
                [indexPaths addObject:[NSIndexPath indexPathForRow:(NSInteger)row inSection:0]];
            }
            
            [self.collectionView deleteItemsAtIndexPaths:indexPaths];
        }
    }
                                  completion:^(BOOL finished) {
                                      [self.collectionView reloadData];
                                  }];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataSource:(PTTAssetViewDataSource *)dataSource
{
    _dataSource = dataSource;
    self.collectionView.dataSource = (id <UICollectionViewDataSource>)dataSource;
    self.collectionView.contentOffset = CGPointZero;
}

-(void)dealloc
{
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
