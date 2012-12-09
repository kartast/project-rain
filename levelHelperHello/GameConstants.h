//
//  GameConstants.h
//  levelHelperHello
//
//  Created by karta on 13/11/12.
//  Copyright (c) 2012 karta. All rights reserved.
//

#ifndef levelHelperHello_GameConstants_h
#define levelHelperHello_GameConstants_h

// Goal frame, from sad -> neutral -> happy
//static int GOAL_FAIL_FRAME_INDEX    = 0;
 
static int GOAL_NEUTRAL_FRAME_INDEX = 4;
static int GOAL_SUCCESS_FRAME_INDEX = 8;

static int GOAL_TARGET_COUNT = 30;
static const float gravityMult = 0.6;
static const float spawnVelMax = 7.5;
static const float fAmplifyMult = 0.02;
static const float fDampMult = 0.6;

static const float fStepTimeMult = 1.1;

static const char* szDefaultLevel = "Levels/level04";

#define GOAL_COLOR          @"goal_color"
#define GOAL_COLOR_YELLOW   @"goal_color_yellow"
#define GOAL_COLOR_RED      @"goal_color_red"
#define GOAL_COLOR_BLUE     @"goal_color_blue"
#define GOAL_COLOR_GREEN    @"goal_color_green"
#define GOAL_COLOR_BLACK    @"goal_color_black"

#define BALL_TYPE_NORMAL    @"normal"
#define BALL_TYPE_BOOST     @"boost"

#endif
