#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>

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

static void* g_GameController = nullptr;
static void* g_LocalPlayer = nullptr;
static void* g_MainCamera = nullptr;

// Metoda care va fi apelata in locul celei originale
void (*orig_GameController_Awake)(id, SEL);
void my_GameController_Awake(id self, SEL _cmd) {
    g_GameController = (__bridge void*)self;
    if (orig_GameController_Awake) orig_GameController_Awake(self, _cmd);
}

void (*orig_PlayerController_Awake)(id, SEL);
void my_PlayerController_Awake(id self, SEL _cmd) {
    void* selfPtr = (__bridge void*)self;
    void* player = ReadMem<void*>(selfPtr, OFF_PLAYERCONTROLLER_PLAYER);
    if (player && ReadMem<bool>(player, OFF_PLAYER_ISLOCAL)) {
        g_LocalPlayer = selfPtr;
        g_MainCamera = ReadMem<void*>(selfPtr, OFF_PLAYERCONTROLLER_CAMERA);
    }
    if (orig_PlayerController_Awake) orig_PlayerController_Awake(self, _cmd);
}

// Functia care hookuieste o metoda
void HookMethod(Class targetClass, SEL targetSelector, void *replacement, void **original) {
    Method targetMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (targetMethod) {
        *original = method_getImplementation(targetMethod);
        method_setImplementation(targetMethod, (IMP)replacement);
    }
}

// Se executa cand tweak-ul se incarca
__attribute__((constructor)) static void init() {
    Class gc = objc_getClass("GameController");
    if (gc) HookMethod(gc, @selector(Awake), (void*)my_GameController_Awake, (void**)&orig_GameController_Awake);
    
    Class pc = objc_getClass("PlayerController");
    if (pc) HookMethod(pc, @selector(Awake), (void*)my_PlayerController_Awake, (void**)&orig_PlayerController_Awake);
}
