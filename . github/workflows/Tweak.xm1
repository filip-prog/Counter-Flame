#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// ====== OFFSET-URI DIN DUMP.CS ======
#define OFF_PLAYERCONTROLLER_MOVEMENT 0x40
#define OFF_PLAYERCONTROLLER_CAMERA   0x30
#define OFF_PLAYERCONTROLLER_PLAYER   0x90
#define OFF_PLAYERCONTROLLER_DEATH    0xA8
#define OFF_MOVEMENT_SELFROOT         0x188
#define OFF_PLAYER_ISLOCAL            0x1C
#define OFF_PLAYER_NICKNAME           0x20
#define OFF_GAMECONTROLLER_ALIVE      0x120

// Funcții memorie
template <typename T> T ReadMem(void* base, uint64_t offset) {
    if (!base) return T();
    return *(T*)((uint64_t)base + offset);
}

struct Vector3 { float x, y, z; };

// Variabile Globale
static void* g_GameController = nullptr;
static void* g_LocalPlayer = nullptr;
static void* g_MainCamera = nullptr;

// Setări Meniu
bool b_ESP = true;
bool b_Skeleton = true;
bool b_Aimbot = false;

// Hook GameController pentru lista de jucători
%hook GameController
- (void)Awake {
    %orig;
    g_GameController = (void*)self;
}
%end

// Hook PlayerController pentru jucătorul local și camera
%hook PlayerController
- (void)Awake {
    %orig;
    void* player = ReadMem<void*>(self, OFF_PLAYERCONTROLLER_PLAYER);
    if (player && ReadMem<bool>(player, OFF_PLAYER_ISLOCAL)) {
        g_LocalPlayer = (void*)self;
        g_MainCamera = ReadMem<void*>(self, OFF_PLAYERCONTROLLER_CAMERA);
    }
}
%end

// Meniu simplu si desenare (nefolosind ImGui deocamdată, ci UIKit direct pentru simplitate)
// Aici va veni partea de randare a liniilor (skeleton) și box-urilor.
// Vei adăuga un view transparent peste joc care să deseneze cu CAShapeLayer sau OpenGL.

// Pentru a porni tweak-ul, hookuim fereastra principală
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    // Aici se inițializează meniul plutitor
    NSLog(@"[CFMenu] Tweak încărcat cu succes!");
}
%end
