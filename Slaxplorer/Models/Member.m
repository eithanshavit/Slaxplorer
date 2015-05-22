#import "Member.h"
#import <FastImageCache/FICUtilities.h>

@interface Member ()

// Private interface goes here.

@end

@implementation Member

- (NSString *)UUID {
  CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString(self.id);
  NSString *UUID = FICStringWithUUIDBytes(UUIDBytes);
  
  return UUID;
}

- (NSString *)sourceImageUUID {
  CFUUIDBytes sourceImageUUIDBytes = FICUUIDBytesFromMD5HashOfString(self.image192URL);
  NSString *sourceImageUUID = FICStringWithUUIDBytes(sourceImageUUIDBytes);
  return sourceImageUUID;
  
  return sourceImageUUID;
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName {
  if ([formatName isEqualToString:@"com.eithanshavit.Slaxplorer.FICFormatNameProfilePhotoFull"]) {
    return [NSURL URLWithString:self.image192URL];
  } else {
    return [NSURL URLWithString:self.image48URL];
  }
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName {
  FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef context, CGSize contextSize) {
    CGRect contextBounds = CGRectZero;
    contextBounds.size = contextSize;
    CGContextClearRect(context, contextBounds);
    
    // Clear background
    CGContextClearRect(context,contextBounds);
    
    // Clip to a rounded rect
    CGPathRef path = createCirclePath(contextBounds);
    CGContextAddPath(context, path);
    CFRelease(path);
    CGContextEOClip(context);
    
    UIGraphicsPushContext(context);
    [image drawInRect:contextBounds];
    UIGraphicsPopContext();
  };
  
  return drawingBlock;
}

#pragma mark - Image Helper Functions

static CGMutablePathRef createCirclePath(CGRect rect) {
  CGMutablePathRef path = CGPathCreateMutable();
  CGFloat radius = CGRectGetHeight(rect) / 2;
  
  CGFloat minX = CGRectGetMinX(rect);
  CGFloat midX = CGRectGetMidX(rect);
  CGFloat maxX = CGRectGetMaxX(rect);
  CGFloat minY = CGRectGetMinY(rect);
  CGFloat midY = CGRectGetMidY(rect);
  CGFloat maxY = CGRectGetMaxY(rect);
  
  CGPathMoveToPoint(path, NULL, minX, midY);
  CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, radius);
  CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, midY, radius);
  CGPathAddArcToPoint(path, NULL, maxX, minY, midX, minY, radius);
  CGPathAddArcToPoint(path, NULL, minX, minY, minX, midY, radius);
  
  return path;
}


@end
