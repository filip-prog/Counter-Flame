#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define OFF_PLAYERCONTROLLER_MOVEMENT 0x40
#define OFF_PLAYERCONTROLLER_CAMERA   0x30
#define OFF_PLAYERCONTROLLER_PLAYER   0x90
#define OFF_PLAYERCONTROLLER_DEATH    0xA8
#define OFF_MOVEMENT_SELFROOT         0x188
#define OFF_MOVEMENT_CURR_POS         0x268
#define OFF_PLAYER_ISLOCAL            0x1C
#define OFF_PLAYER_NICKNAME           0x20
#define OFF_GAMECONTROLLER_ALIVE      0x120

template <typename T> T ReadMem(void* base, uint64_t offset) {
    if (!base) return T();
    return *(T*)((uint64_t)base + offset);
}

struct Vector3 { float x, y, z; };

static void* g_GameController = nullptr;
static void* g_LocalPlayer = nullptr;
static void* g_MainCamera = nullptr;

bool b_ESP = true;
bool b_Skeleton = true;
bool b_Aimbot = false;

%hook GameController
- (void)Awake {
    %orig;
    g_GameController = (__bridge void*)self;
}
%end

%hook PlayerController
- (void)Awake {
    %orig;
    void* selfPtr = (__bridge void*)self;
    void* player = ReadMem<void*>(selfPtr, OFF_PLAYERCONTROLLER_PLAYER);
    if (player && ReadMem<bool>(player, OFF_PLAYER_ISLOCAL)) {
        g_LocalPlayer = selfPtr;
        g_MainCamera = ReadMem<void*>(selfPtr, OFF_PLAYERCONTROLLER_CAMERA);
    }
}
%end

%hook PlayerMovement
- (void)LateUpdate {
    %orig;
    // Aici se va apela desenarea ESP-ului si logica de Aimbot
}
%end
