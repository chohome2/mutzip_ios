//
//  DetailViewController.h
//  mutzip
//
//  Created by taeho.cho on 14. 5. 13..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DetailViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSDictionary *shopDict;
@property (nonatomic, strong) NSDictionary *nowImageDict;

@property(nonatomic, strong)UIDocumentInteractionController *docFile;
@end
