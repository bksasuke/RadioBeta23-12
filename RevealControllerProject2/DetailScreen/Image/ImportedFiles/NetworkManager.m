//
//  NetworkManager.m
//  CGVAPP
//
//  Created by Nguyen Van Thanh on 12/7/15.
//  Copyright © 2015 DangDingCan. All rights reserved.
//

#import "NetworkManager.h"
#define BASE_URL @"https://www.mp3.zing.vn"
#import "TFHpple.h"
#import "PhimObj.h"


@interface NetworkManager()
@end

@implementation NetworkManager
+(instancetype)shareManager {
    static NetworkManager*shareManager = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        shareManager = [self new];
    });
    return shareManager;
}
-(id)init {
    if (self = [super init]) {
        
    }
    return self;
}
// Test trang CGV.vn
-(void)GetFilmFromLink:(NSString *)url OnComplete:(void (^)(NSArray *))completedMethod fail:(void (^)())failMethod{
    
    NSError * error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]
                                         options:NSDataReadingUncached
                                           error:&error];
    if (error) { failMethod();
    }
    NSMutableArray * allItems = [NSMutableArray new];
    
    TFHpple *tutorialPaser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialQueryString = @"//div[@class='category-products']/ul/li";
    NSArray *nodes = [tutorialPaser searchWithXPathQuery:tutorialQueryString];
    for (TFHppleElement * element in nodes) { // bắt đầu duyệt trong class "category ...
        
        TFHppleElement * element1 = [element firstChildWithClassName:@"product-poster"];  // Lấy thẻ div co class là product-poster
        TFHppleElement * element2 = [element1 firstChildWithTagName:@"a"];
        
        
        NSString *linkDetail = [element2 objectForKey:@"href"];
        //TFHppleElement *element3 = element2.children[1];
        
        TFHppleElement *element3 = [element2 firstChildWithTagName:@"img"];
        
        NSString *linkimage = [element3 objectForKey:@"src"];
        
        TFHppleElement * element4 = [element firstChildWithClassName:@"product-info"]; //tạo node chứa thẻ prdoduct info
        TFHppleElement *element20 = [element4 firstChildWithClassName:@"product-name"];
        TFHppleElement *element21 = [element20 firstChildWithTagName:@"a"];
        
        NSString *name = [element21 objectForKey:@"title"];
        TFHppleElement *element5 = [element4 firstChildWithClassName:@"movie-actress"]; // lấy thẻ movie
        TFHppleElement *element6 = [element5 firstChildWithClassName:@"std"]; // lấy thẻ có class std
        
        NSString *filmDuration = element6.content; // --> thời lượng film là content của element6
        
        TFHppleElement *element7 = [element4 firstChildWithClassName:@"movie-genre"]; // lấy thẻ movie-genere
        TFHppleElement *element8 = [element7 firstChildWithClassName:@"std"];
        
        NSString *filmType = element8.content ;
        NSString *trimmedString = [filmType stringByTrimmingCharactersInSet:
                                   [NSCharacterSet newlineCharacterSet]];
        trimmedString = [trimmedString stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]];
        filmType = trimmedString;
        TFHppleElement *element9 = [element4 firstChildWithClassName:@"movie-release"];
        TFHppleElement *element10 = [element9 firstChildWithClassName:@"std"];
        NSString *filmDateRealease = element10.content;
        
        PhimObj *phim = [[PhimObj alloc] initWithName:name
                                             catelogy:filmType
                                             duration:filmDuration
                                                 date:filmDateRealease
                                           linkDetail:linkDetail
                                             imageUrl:linkimage ];
        
        [allItems addObject:phim];
    }
    completedMethod(allItems);
}


-(void)GetMusicFromLink:(NSString *)urlmusic OnComplete:(void (^)(NSArray *))completedMethod fail:(void (^)())failMethod
{
    NSError * error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlmusic]
                                         options:NSDataReadingUncached
                                           error:&error];
    if (error) { failMethod();}
    NSMutableArray * allItems = [NSMutableArray new];
    
    TFHpple *tutorialPaser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialQueryString = @"//div[@class='zcontent']/div/div/div/div";
    NSArray *nodes = [tutorialPaser searchWithXPathQuery:tutorialQueryString];
    for (TFHppleElement * element in nodes) { // bắt đầu duyệt các phần tử trong class "zcontent"
        
        TFHppleElement * element1 = [element firstChildWithTagName:@"a"]; //Element 1 là thẻ a đầu tiên
        NSString *linkDetail = [element1 objectForKey:@"href"]; // Done link chi tiết
        
        TFHppleElement *element2 = [element1 firstChildWithTagName:@"img"];
        NSString *linkImage = [element2 objectForKey:@"src"];
    
        // Xong việc với thẻ tag "a" chứa 2 link trên, ta chuyển sang thẻ khác chứa các thông tin còn lại,
        TFHppleElement *element3 = [element firstChildWithClassName:@"description"];
        TFHppleElement *element4 = [element3 firstChildWithClassName:@"title-item ellipsis"];
        
        TFHppleElement *element5 = [element4 firstChildWithTagName:@"a"];
        NSString *tenbaihat = element5.content;
        // --> done !!
        
        TFHppleElement *element6 = [element3 firstChildWithClassName:@"inblock ellipsis"];
        TFHppleElement *element7 = [element6 firstChildWithClassName:@"title-sd-item"];
        TFHppleElement *element8 = [element7 firstChildWithTagName:@"a"];
        NSString *tencasi = element8.content;
        
        
        PhimObj *song =[[PhimObj alloc] initWithName:tenbaihat
                                            catelogy:tencasi
                                            duration:nil
                                                date:nil
                                          linkDetail:linkDetail
                                            imageUrl:linkImage];
        [allItems addObject:song];
        
    }
    completedMethod(allItems);
    
}

-(void)GetMp3Link:(NSString *)urlmp3 OnComplete:(void (^)(NSArray *))completedMethod fail:(void (^)())failMethod {
    
}

-(void)GetPlaylistFromLink:(NSString *)linkParent OnComplete:(void (^)(NSArray *))completedMethod fail:(void (^)())failMethod {

    NSError * error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:linkParent]
                                         options:NSDataReadingUncached
                                           error:&error];
    if (error) { failMethod();}
    NSMutableArray * allItems = [NSMutableArray new];
    
    TFHpple *tutorialPaser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialQueryString = @"//div[@class='zcontent']/div/div/div/div";
    NSArray *nodes = [tutorialPaser searchWithXPathQuery:tutorialQueryString];




}



@end
