//
//  ModelHelper.m
//

#import "ModelHelper.h"

@implementation ModelHelper

+ (NSEntityDescription *) createNewObjectForEntityName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:MOC];
}
    
+ (BOOL) saveManagedObjectContext
{
    NSLog(@"Running on %@ thread", [NSThread currentThread]);
	NSError *error = nil;
	if (![MOC save:&error]) {
		NSLog(@"Core Data Save Error: %@, %@", error, [error userInfo]);
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Data Save Failure", @"The application failed to save data to the database") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"BUTTON: OK") otherButtonTitles: nil];

        [errorAlertView show];
		return NO;
	}
    //NSLog(@"CORE DATA SAVED");
    
	return YES;
}

+ (void)rollBack {
    NSLog(@"CORE DATA ROLLED BACK");
    [MOC rollback];
}

@end