//
//  ShowDetailScreen.m
//  FunnyFood
//
//  Created by hoangdangtrung on 10/23/15.
//  Copyright © 2015 hoangdangtrung. All rights reserved.
//

#import "ShowDetailScreen.h"
#import "DetailScreen.h"
#import "NetworkManager.h"
#import "PhimObj.h"
//@import AVFoundation;
@interface ShowDetailScreen ()

@property (weak, nonatomic) IBOutlet UILabel *labelFoodName;

@property (nonatomic, strong) PhimObj *song;
@property (nonatomic, strong) NSMutableArray *arr_data,*arr_data2;
@end

@implementation ShowDetailScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    PhimObj *song = self.arr_data2[0];
    self.title = song.theLoai;
 
//    self.labelPrice.text = self.stringPrice;
//    self.labelSaleOff.text = self.stringSaleOff;
    [self.view addSubview:self.labelFoodName];
    [self.view reloadInputViews];
    [self getXml];
    [self getMp3];
    [self addItem2Screen];
    
    
    
}


-(void) getXml{
    [[NetworkManager shareManager] GetXmlFromDetailLink:self.linkMp3
                                            OnComplete:^(NSArray *items) {
                                                self.arr_data = [[NSMutableArray alloc] initWithArray:items];
                                                
                                            } fail:^{
                                                NSLog(@"loi");
                                            }];
    
}
-(void) getMp3 {
    [[NetworkManager shareManager] GetMp3FromXml:self.arr_data[0]
                                             OnComplete:^(NSArray *items) {
                                                 self.arr_data2 = [[NSMutableArray alloc] initWithArray:items];
                                                 
                                             } fail:^{
                                                 NSLog(@"loi");
                                             }];
    
}

-(void) addItem2Screen {
    
    NSLog(@"%@",self.song.tenPhim);
}

@end
