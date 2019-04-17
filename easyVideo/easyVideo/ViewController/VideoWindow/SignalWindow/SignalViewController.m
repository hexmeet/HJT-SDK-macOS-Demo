//
//  SignalViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/10.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "SignalViewController.h"

@interface SignalViewController ()<NSTableViewDelegate, NSTableViewDataSource>
{
    NSTableView * _tableView;
    NSMutableArray * _dataArray;
    AppDelegate *appDelegate;
    dispatch_source_t _timer;
    
    NSArray *sgnalArr;
    NSMutableArray *codecsArr;
    NSMutableArray *rateArr;
    NSMutableArray *fblArr;
    NSMutableArray *loseArr;
    NSMutableArray *loseNum;
}

@end

@implementation SignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    appDelegate = APPDELEGATE;
    
    [self getData];
    
    [self creatTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSESIGNLWINDOW object:nil];
    
}

- (void)viewDidLayout
{
    [super viewDidLayout];
    NSArray *statarr = [appDelegate.evengine getStats];
    EVStreamStats *stats = statarr[0];
    if (stats.is_encrypted) {
        self.view.window.title = [NSString stringWithFormat:@"%@(%@)", localizationBundle(@"home.signl.title"), localizationBundle(@"video.statistics.column.encrypted")];
    }else {
        self.view.window.title = [NSString stringWithFormat:@"%@(%@)", localizationBundle(@"home.signl.title"), localizationBundle(@"video.statistics.column.unencrypted")];
    }
}

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSESIGNLWINDOW object:nil];
    
    dispatch_source_cancel(_timer);
}

- (void)getData
{
    codecsArr    = [NSMutableArray arrayWithCapacity:1];
    rateArr      = [NSMutableArray arrayWithCapacity:1];
    fblArr       = [NSMutableArray arrayWithCapacity:1];
    loseArr      = [NSMutableArray arrayWithCapacity:1];
    loseNum      = [NSMutableArray arrayWithCapacity:1];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);

    dispatch_source_set_event_handler(_timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->sgnalArr = [self->appDelegate.evengine getStats];
            
            [self->codecsArr removeAllObjects];
            [self->rateArr removeAllObjects];
            [self->fblArr removeAllObjects];
            [self->loseArr removeAllObjects];
            [self->loseNum removeAllObjects];
            [self->_dataArray removeAllObjects];
            
            for (EVStreamStats *stats in self->sgnalArr) {
                
                NSString *typeStr = @"";
                if (stats.type == EVStreamAudio) {
                    if (stats.dir == EVStreamUpload) {
                        typeStr = localizationBundle(@"video.statistics.column.thisEnd.audio");
                    }else {
                        typeStr = localizationBundle(@"video.statistics.column.farEnd.audio");
                    }
                }else if (stats.type == EVStreamVideo) {
                    if (stats.dir == EVStreamUpload) {
                        typeStr = localizationBundle(@"video.statistics.column.thisEnd.video");
                    }else {
                        typeStr = localizationBundle(@"video.statistics.column.farEnd.video");
                    }
                }else {
                    if (stats.dir == EVStreamUpload) {
                        typeStr = localizationBundle(@"video.statistics.column.thisEnd.content");
                    }else {
                        typeStr = localizationBundle(@"video.statistics.column.farEnd.content");
                    }
                }
                [self->_dataArray addObject:typeStr];
                [self->codecsArr addObject:stats.payload_type];
                [self->rateArr addObject:[NSString stringWithFormat:@"%.2f", stats.real_bandwidth]];
                if (stats.type == EVStreamAudio) {
                    [self->fblArr addObject:@"-"];
                }else {
                    [self->fblArr addObject:[NSString stringWithFormat:@"%dx%d (%d)", stats.resolution.width, stats.resolution.height, (int)stats.fps]];
                }
                [self->loseArr addObject:[NSString stringWithFormat:@"%d", (int)stats.packet_loss_rate]];
                [self->loseNum addObject:[NSString stringWithFormat:@"%d", (int)stats.cum_packet_loss]];
            }
            [self->_tableView reloadData];
        });
        
    });
    
    // 开启定时器
    dispatch_resume(_timer);
}

- (void)creatTableView
{
    _dataArray = [NSMutableArray array];
    
    NSScrollView * scrollView    = [[NSScrollView alloc] init];
    scrollView.hasVerticalScroller  = YES;
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    NSArray *dTitle = @[localizationBundle(@"video.statistics.column.name"),
                        localizationBundle(@"video.statistics.codec"),
                        localizationBundle(@"video.statistics.rate"),
                        localizationBundle(@"video.statistics.resolution"),
                        localizationBundle(@"video.statistics.pktLossRate"),
                        ];
    _tableView = [[NSTableView alloc]initWithFrame:self.view.bounds];
    for (int i = 0; i<5; i++) {
        NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:[NSString stringWithFormat:@"%dcolumn",i]];
        column.title = dTitle[i];
        column.editable = NO;
        column.width = self.view.frame.size.width/5;
        [_tableView addTableColumn:column];
    }
    _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    _tableView.usesAlternatingRowBackgroundColors = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    scrollView.contentView.documentView = _tableView;
}

- (void)closeWindow
{
    [self.view.window close];
}

#pragma mark - NSTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return _dataArray.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([tableColumn.identifier isEqualToString:@"0column"]) {
        return _dataArray[row];
    }else if ([tableColumn.identifier isEqualToString:@"1column"]) {
        return codecsArr[row];
    }else if ([tableColumn.identifier isEqualToString:@"2column"]) {
        return rateArr[row];
    }else if ([tableColumn.identifier isEqualToString:@"3column"]) {
        return fblArr[row];
    }else {
        return [NSString stringWithFormat:@"(%@)%@%%", loseNum[row], loseArr[row]];
    }
}

@end
