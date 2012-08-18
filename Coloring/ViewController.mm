//
//  ViewController.m
//  Coloring
//
//  Created by Macbook on 8/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GraphicsCommon.h"
#import "ImageHelper.h"
#import "Context.h"
@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(UIImage *)customImage: (UIImage *) image
{

    // load image

    CGImageRef imageRef = image.CGImage;
    NSData *data        =  (__bridge NSData *)CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    char *pixels        = (char *)[data bytes];
    
    CGFloat red, green, blue, alpha;
    [[UIColor whiteColor] getRed:&red green:&green blue:&blue alpha:&alpha ];
    // this is where you manipulate the individual pixels
    // assumes a 4 byte pixel consisting of rgb and alpha
    // for PNGs without transparency use i+=3 and remove int a
    int l = [data length];
    for(int i = 0; i < [data length]-4; i += 4)
    {
        int r = i;
        int g = i+1;
        int b = i+2;
        int a = i+3;
        
        char ir = pixels[r];
        char ig = pixels[g];
        char ib = pixels[b];
        char ia = pixels[a];
        
        pixels[r]   = red; // eg. remove red
        pixels[g]   = green;
        pixels[b]   = blue;
        pixels[a]   = pixels[a];
    }
    
    // create a new image from the modified pixel data
    size_t width                    = CGImageGetWidth(imageRef);
    size_t height                   = CGImageGetHeight(imageRef);
    size_t bitsPerComponent         = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel             = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow              = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorspace      = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo         = CGImageGetBitmapInfo(imageRef);
    CGDataProviderRef provider      = CGDataProviderCreateWithData(NULL, pixels, [data length], NULL);
    
    CGImageRef newImageRef = CGImageCreate (
                                            width,
                                            height,
                                            bitsPerComponent,
                                            bitsPerPixel,
                                            bytesPerRow,
                                            colorspace,
                                            bitmapInfo,
                                            provider,
                                            NULL,
                                            false,
                                            kCGRenderingIntentDefault
                                            );
    // the modified image
    UIImage *newImage   = [UIImage imageWithCGImage:newImageRef];
    
    // cleanup
    free(pixels);
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorspace);
    CGDataProviderRelease(provider);
    CGImageRelease(newImageRef);
    return newImage;
}
-(UIImage *)loadImageWithName: (NSString *)fileName
{
    UIImage *img = [UIImage imageNamed:fileName];
    int width = img.size.width;
	int height = img.size.height;
	
	// Create a bitmap
	unsigned char *bitmap = [ImageHelper convertUIImageToBitmapRGBA8:img];
    
    for (int i = 0; i<width*height*4; i+=4)
    {
        bitmap[i]= 255;
        bitmap[i+1] = 0;
        bitmap[i+2]= 255;
        bitmap[i+3] = 255;
        
    }
    
    Color3D *colorOut = new Color3D[width * height];
    ConvertImageRGBA8ToColor3d(bitmap, colorOut, width, height);

    
    
    // **NOTE:** Test Print the colors using a c++ code to check transparency
    /*
        for(int i = 0; i < width * height; ++i) {
            std::cout << colorOut[i] << std::endl;
        }
     */
    
    UIImage *imageCopy = [ImageHelper convertBitmapRGBA8ToUIImage:bitmap withWidth:width withHeight:height];
	
    
	// Cleanup
    
	if(bitmap) {
		free(bitmap);	
		bitmap = NULL;
	}

    return imageCopy;

}
-(void)loadView
{
    CGRect rec = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIView *mainView = [[UIView alloc]initWithFrame:rec];
    
    //image = [ImageHelper imageWithImage: [UIImage imageNamed:@"Demo.png"]  scaledToSize:CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)] ;//[self loadImageWithName:@"Image.png"];
    image = [UIImage imageNamed:@"demofit.png"];
    
    
    imageView = [[UIImageView alloc]initWithFrame:rec];
    [imageView setImage:image];
    
    [mainView addSubview:imageView];
    
    self.view = mainView;
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray* const t = [[event touchesForView: self.view] allObjects];
    CGPoint p = [[t objectAtIndex: 0] locationInView: self.view];
    
    Context *context = [Context getInstance];
    [context setImg:image];
    
    [context setColorFill:[UIColor blueColor]];
    [context setColorBoundary:[UIColor blackColor]];
    [context setColorStart:[UIColor whiteColor]];
    
    [context AlgorithmFillX:p.x  withY:p.y];
    NSLog(@"Finish");
    image = [[Context getInstance] bitmap];
    [imageView setImage:image];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
