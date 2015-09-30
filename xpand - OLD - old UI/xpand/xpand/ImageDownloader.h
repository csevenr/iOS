#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Post;

@interface ImageDownloader : NSObject

@property (nonatomic, strong) Post *post;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
