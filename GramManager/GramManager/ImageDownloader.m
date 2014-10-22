#import "ImageDownloader.h"
#import "Post.h"

#define kAppIconSize 48

@interface ImageDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@end


#pragma mark -

@implementation ImageDownloader

// -------------------------------------------------------------------------------
//	startDownload
// -------------------------------------------------------------------------------
- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.post.thumbnailURL]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

// -------------------------------------------------------------------------------
//	cancelDownload
// -------------------------------------------------------------------------------
- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark - NSURLConnectionDelegate

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
	{
        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.post.thumbnailImg = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.post.thumbnailImg = image;
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
    {
        self.completionHandler();
    }
}

@end

