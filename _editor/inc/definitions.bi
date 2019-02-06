#ifndef NULL
	const NULL as any ptr = 0
#endif

#ifndef getPixelAddress
    #define getPixelAddress(img,row,col) cast(any ptr,img) + _
        sizeof(FB.IMAGE) + (img)->pitch * (row) + (img)->bpp * (col)
#endif

'define and consts______________________________________________________
#define APP_NAME 				"A Love letter to Freebasic Level Editor by Pitto"
#define APP_VERSION 			"Version 0.0.1"
#define SCR_W 					1024			
#define SCR_H 					600
#define TILE_W					32
#define TILE_H					24
#define GUI_X_START_ICONS		SCR_W - TILE_W*16
#define TILE_FIELD_MAX_VALUE	255



'old code
#define MIN_SNAP_DIST			15
#define MIN_SNAP_TO_SNAP_DIST	5
#define MIN_EDGE_SNAP_DIST		20
#define RANDOM_POLYGONS_QTY		200
#define MAX_POLYGONS_NODES		10
#define BTN_W					90 'GUI standard button width
#define BTN_H					12 'GUI standard button heigth

#define KEYBOARD_PX_INCREMENTS	1


'colors
#define C_BLACK			&h000000
#define C_WHITE			&hFFFFFF
#define C_GRAY 			&h7F7F7F
#define C_DARK_GRAY		&h202020
#define C_RED			&hFF0000
#define C_BLUE 			&h0000FF
#define C_GREEN			&h00FF00
#define C_YELLOW		&hFFFF00
#define C_CYAN 			&h00FFFF
#define C_LILIAC		&h7F00FF
#define C_ORANGE		&hFF7F00
#define C_PURPLE		&h7F007F
#define C_DARK_RED 		&h7F0000
#define C_DARK_GREEN	&h005500
#define C_DARK_BLUE		&h00007F

const as double _PI = 4*atn(1)
const as double _2PI = 2*_PI


#DEFINE ENEMY_TYPE_GREEN_ROBOT				0
#DEFINE ENEMY_TYPE_BLACK_BALL				1
#DEFINE ENEMY_TYPE_GREEN_GUY				2
#DEFINE ENEMY_TYPE_EYEGLASS_GUY				3
#DEFINE ENEMY_TYPE_FLYING_ROBOT				4
#DEFINE ENEMY_TYPE_FLOOR_SPIDER				5
#DEFINE ENEMY_TYPE_PROGRAMMER				6
#DEFINE ENEMY_TYPE_CHARLES_BRONSON			7
#DEFINE ENEMY_TYPE_JASC						8

#DEFINE ENEMY_GREEN_ROBOT_SPEED				0.5
#DEFINE ENEMY_BLACK_BALL_SPEED				2.5
#DEFINE ENEMY_GREEN_GUY_SPEED				1
#DEFINE ENEMY_EYEGLASS_GUY_SPEED			3.5
#DEFINE ENEMY_FLYING_ROBOT_SPEED			2.5
#DEFINE ENEMY_TYPE_FLOOR_SPIDER_SPEED		2.5
#DEFINE ENEMY_TYPE_PROGRAMMER_SPEED			2
#DEFINE ENEMY_TYPE_CHARLES_BRONSON_SPEED	3
#DEFINE ENEMY_TYPE_JASC_SPEED				6
