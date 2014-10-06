//
//  BPRPullToRefreshTests.m
//  BobPullToRefresh
//
//  Created by Richard Martin on 04/10/2014.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BPRPullToRefresh.h"
#import "BPRRefreshView.h"
#import "BPRFakeScrollView.h"

SpecBegin(BPRPullToRefresh)

describe(@"bob pull to refresh initialisationg", ^{
    
    __block BPRPullToRefresh *sut;
    __block BPRFakeScrollView *scrollView;
    __block BPRRefreshView *refreshView;
    
    beforeEach(^{
        scrollView = [[BPRFakeScrollView alloc] init];
        refreshView = [[BPRRefreshView alloc] initWithLocationType:BPRRefreshViewLocationTypeFixedTop];
        sut = [[BPRPullToRefresh alloc] initWithRefreshView:refreshView scrollView:(id)scrollView actionHandler:nil];
    });
    
    it(@"should be enabled by default", ^{
        expect(sut.enabled).to.beTruthy;
    });
    
    it(@"should be idle on initialisation", ^{
        expect(sut.state).to.equal(BPRPullToRefreshStateIdle);
    });
    
});

describe(@"bob pull to refresh basic transitions", ^{
    
    __block BPRPullToRefresh *sut;
    __block BPRFakeScrollView *scrollView;
    __block BPRRefreshView *refreshView;
    
    beforeEach(^{
        scrollView = [[BPRFakeScrollView alloc] init];
        refreshView = [[BPRRefreshView alloc] initWithLocationType:BPRRefreshViewLocationTypeFixedTop];
        sut = [[BPRPullToRefresh alloc] initWithRefreshView:refreshView scrollView:(id)scrollView actionHandler:nil];
    });
    
    it(@"should transition to loading after crossing threshold", ^{
        [scrollView simulateToOffsetDragging:CGPointMake(0, -refreshView.thresholdHeight)];
        [scrollView simulateToOffsetNoDragging:CGPointMake(0, -refreshView.thresholdHeight)];
        
        expect(sut.state).to.equal(BPRPullToRefreshStateLoading);
    });
    
    it(@"should transition to tiggered when crossing threshold", ^{
        [scrollView simulateToOffsetDragging:CGPointMake(0, -refreshView.thresholdHeight)];
        
        expect(sut.state).to.equal(BPRPullToRefreshStateTriggered);
    });
    
    it(@"should not transition to tiggered when not crossing threshold", ^{
        [scrollView simulateToOffsetDragging:CGPointMake(0, -refreshView.thresholdHeight + 1)];
        
        expect(sut.state).to.equal(BPRPullToRefreshStateIdle);
    });

});

describe(@"bob pull to refresh view frames", ^{
    
    __block BPRPullToRefresh *sut;
    __block BPRFakeScrollView *scrollView;
    __block BPRRefreshView *refreshView;
    
    beforeEach(^{
        scrollView = [[BPRFakeScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, 280, 100);
        scrollView.bounds = CGRectMake(0, 0, 280, 100);
    });
   
    it(@"should set the starting frame for fixed top to 0 y and threshold height", ^{
        refreshView = [[BPRRefreshView alloc] initWithLocationType:BPRRefreshViewLocationTypeFixedTop];
        sut = [[BPRPullToRefresh alloc] initWithRefreshView:refreshView scrollView:(id)scrollView actionHandler:nil];
        
        expect(refreshView.frame).to.equal(CGRectMake(0, 0, 280, refreshView.thresholdHeight));
    });
    
    it(@"should set the starting frame for fixed bottom to -height y and threshold height", ^{
        refreshView = [[BPRRefreshView alloc] initWithLocationType:BPRRefreshViewLocationTypeFixedBottom];
        sut = [[BPRPullToRefresh alloc] initWithRefreshView:refreshView scrollView:(id)scrollView actionHandler:nil];
        
        expect(refreshView.frame).to.equal(CGRectMake(0, -refreshView.thresholdHeight, 280, refreshView.thresholdHeight));
    });
    
    it(@"should set the starting frame for fixed bottom to -height y and threshold height even with custom height", ^{
        refreshView = [[BPRRefreshView alloc] initWithLocationType:BPRRefreshViewLocationTypeFixedBottom];
        refreshView.thresholdHeight = 34;
        sut = [[BPRPullToRefresh alloc] initWithRefreshView:refreshView scrollView:(id)scrollView actionHandler:nil];
        
        expect(refreshView.frame).to.equal(CGRectMake(0, -34, 280, 34));
    });
    
    it(@"should set the starting frame for scale to 0", ^{
        refreshView = [[BPRRefreshView alloc] initWithLocationType:BPRRefreshViewLocationTypeScale];
        sut = [[BPRPullToRefresh alloc] initWithRefreshView:refreshView scrollView:(id)scrollView actionHandler:nil];
        
        expect(refreshView.frame).to.equal(CGRectMake(0, 0, 280, 0));
    });
    
    it(@"should set the frame for scale to match offset when dragging", ^{
        [scrollView simulateToOffsetDragging:CGPointMake(0, -90)];
        
        refreshView = [[BPRRefreshView alloc] initWithLocationType:BPRRefreshViewLocationTypeScale];
        sut = [[BPRPullToRefresh alloc] initWithRefreshView:refreshView scrollView:(id)scrollView actionHandler:nil];
        
        expect(refreshView.frame).to.equal(CGRectMake(0, -90, 280, 90));
    });
    
    it(@"should set the frame for fixed top to match offset when dragging", ^{
        [scrollView simulateToOffsetDragging:CGPointMake(0, -90)];
        
        refreshView = [[BPRRefreshView alloc] initWithLocationType:BPRRefreshViewLocationTypeFixedTop];
        sut = [[BPRPullToRefresh alloc] initWithRefreshView:refreshView scrollView:(id)scrollView actionHandler:nil];
        
        expect(refreshView.frame).to.equal(CGRectMake(0, -90, 280, refreshView.thresholdHeight));
    });

    it(@"should set the frame for fixed top to match offset when dragging", ^{
        [scrollView simulateToOffsetDragging:CGPointMake(0, -90)];
        
        refreshView = [[BPRRefreshView alloc] initWithLocationType:BPRRefreshViewLocationTypeFixedBottom];
        sut = [[BPRPullToRefresh alloc] initWithRefreshView:refreshView scrollView:(id)scrollView actionHandler:nil];
        
        expect(refreshView.frame).to.equal(CGRectMake(0, -refreshView.thresholdHeight, 280, refreshView.thresholdHeight));
    });
});


    
SpecEnd
