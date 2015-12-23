//
//  DetailScreen.m
//  [Exp2]RadioVN
//
//  Created by tuan.suke on 12/22/15.
//
//

#import "DetailScreen.h"
#import "FrontViewController.h"
#import "TFHpple.h"
#import "PhimObj.h"
#import "NetworkManager.h"
#import "ShowDetailScreen.h"


@interface DetailScreen () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, weak) NSString *desLink ;
@property (nonatomic,strong) NSString *linkFrontView;
@property (nonatomic,strong) ShowDetailScreen *showDetailScreen;
@end

@implementation DetailScreen



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.linkFrontView == nil) {
        
        self.linkFrontView = @"http://mp3.zing.vn/the-loai-album.html";
    }
    
    else;
    
    [self loadHTML];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = NSLocalizedString(self.stringHeader, nil);
    
    
}

- (void) viewDidLayoutSubviews // Layout màn hình theo tỉ lệ 1:2
{
    [super viewWillLayoutSubviews];
    
    
    CGFloat statusNavigationBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.stringLinkImage]];
    _image.image = [UIImage imageWithData: imageData];
    _image.frame = CGRectMake(10, statusNavigationBarHeight+10, self.view.bounds.size.width-20, (self.view.bounds.size.height-20)/3
                              );
    
    [self.view addSubview:_image ];
    self.tableView.frame = CGRectMake(10, (self.view.bounds.size.height-20)/3+10, self.view.bounds.size.width-20, (self.view.bounds.size.height-20)*2/3);
    
}
-(void) loadHTML{
    [[NetworkManager shareManager] GetMusicFromLink:self.stringLinkDetail
                                         OnComplete:^(NSArray *items) {
                                             self.arr_data = [[NSMutableArray alloc] initWithArray:items];
                                             
                                         } fail:^{
                                             NSLog(@"loi");
                                         }];
    
}

#pragma mark - Tableview configure


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.stringHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"Cell"];
    }
    
    
    cell.textLabel.text = self.stringLinkDetail;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.stringLinkImage]];
    cell.imageView.image = [UIImage imageWithData:data];
    //    cell.detailTextLabel.text = self.stringLinkImage;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    //    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    return cell ;}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.showDetailScreen) {
        self.showDetailScreen = [ShowDetailScreen new];
    }
//    PhimObj *phim = [ PhimObj new];
//
//    phim = self.arr_data[indexPath.row];
    self.showDetailScreen.linkMp3 = @"http://mp3.zing.vn/xml/song-xml/LmJHTkHaplHdFSxyZvcyFGLm";
    [self.navigationController pushViewController:self.showDetailScreen animated:YES];

}
@end
