module source.screen;

import foxid;

import source.app;

final class Piece : Instance {

    this(Vec pos, char c) @safe {
        import std.string : format;
        //import std.stdio : writeln;

        name = format("piece%02s,%02s", pos.x / g_stepSize, pos.y / g_stepSize);
        //writeln(name);

        position = pos;

        Animation piece = new Animation();
        piece.strip("assets/rockdash5.png", Vec((c == '0' ? 0 : 24),0), 24,24);

        ofsprite.animation = piece;
        ofsprite.isAnim = true;
    }
}
