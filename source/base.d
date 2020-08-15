module source.base;

public import std.stdio;

float mouse_circle_size = 60;
int num_of_chain_objects = 30;
int num_of_cuddle_objects = 20;
int num_of_posts = 50;
float move_step = 5;
float size_step = 3;
float size_max = 10;
float size_min;
float global_size;
bool bigger = true;
float gap_distance = 7;
float post_size = 7;
AniState g_aniState;
ProgVersion g_progVersion;
int pauseTimeMax = 100;
int pauseTime;

enum ProgVersion {follow, homing}
enum AniState {still, homing_in, following, pause}
enum HomingSetUp {centre, spread}

shared static this() {
    pauseTime = pauseTimeMax;
}