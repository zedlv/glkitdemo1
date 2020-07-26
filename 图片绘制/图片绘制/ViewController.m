//
//  ViewController.m
//  图片绘制
//
//  Created by lvAsia on 2020/7/25.
//  Copyright © 2020 yazhou lv. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>


@interface ViewController (){
    EAGLContext *context;
    GLKBaseEffect * eEffect;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.OpenGL ES 相关初始化
    [self setUpConfig];
    
     //2.加载顶点/纹理坐标数据
    [self setUpVertexData];
    //3.加载纹理数据(使用GLBaseEffect)
    [self setUpTexture];
}

-(void)setUpConfig
{
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if (!context) {
           NSLog(@"Create ES context Failed");
       }
    
    [EAGLContext setCurrentContext:context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
}

- (void)setUpVertexData{
    
     //准备数据
    
    GLfloat vertexData[] = {
        
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5,  0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    };
    
    GLuint bufferID;
    glGenTextures(1, &bufferID);
    
    glBindTexture(GL_ARRAY_BUFFER, bufferID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
      glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
}

- (void)setUpTexture{
    
    //NSString *filePath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"jpg"];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"jpg"];
    
    //NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    
     NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    eEffect = [[GLKBaseEffect alloc] init];
    eEffect.texture2d0.enabled = GL_TRUE;
    eEffect.texture2d0.name = textureInfo.name;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    [eEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
}
@end
