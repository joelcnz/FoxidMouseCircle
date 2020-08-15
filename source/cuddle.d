module source.cuddle;

@safe:
import std;

import jmisc;

import foxid;

import source.base;
import source.carriage;

class Cuddle {
    private:
    Vec pos,
        target,
        dir;
    float size;
    float r,g,b;

    public:
	const getPos() {
		return pos;
	}
    const getTargPos() {
        return target;
    }

	void setSize(float size0) { size = size0; }
    void setTarget(Vec pos) { target = pos; }
    void setDir(Vec vec) { dir = vec; }

    const getSize() {
        return size;
    }

    this(Vec pos, float size) {
        this.pos = pos;
        this.size = size;
    }

    this(Vec pos, float size, ubyte r, ubyte g, ubyte b) {
        this(pos, size);
        this.r = r;
        this.g = g;
        this.b = b;
    }

    // prog version follow
    void update(Carriage pointer, Cuddle[] cuds, Carriage[] train) {
        float dx, dy;

        xyaim(dx, dy, getAngle(pos.x, pos.y, pointer.getPos.x, pointer.getPos.y));
        pos.x += dx * 1;
        pos.y += dy * 1;

        if (distance(pointer.getPos.x, pointer.getPos.y, pos.x, pos.y) < pointer.getSize + size) {
            xyaim(dx, dy, getAngle(pos.x, pos.y, pointer.getPos.x, pointer.getPos.y));
            pos.x -= dx * 2;
            pos.y -= dy * 2;
        }

        foreach(const cu; cuds) {
            if (this !is cu) {
                if (distance(cu.getPos.x, cu.getPos.y, pos.x, pos.y) < cu.size + size) {
                    xyaim(dx, dy, getAngle(pos.x, pos.y, cu.getPos.x, cu.getPos.y));
                    pos.x -= dx * 1;
                    pos.y -= dy * 1;
                }
            }
        }

        foreach(const ca; train) {
            if (distance(ca.getPos.x, ca.getPos.y, pos.x, pos.y) < ca.getSize + size) {
                xyaim(dx, dy, getAngle(pos.x, pos.y, ca.getPos.x, ca.getPos.y));
                pos.x -= dx * 1;
                pos.y -= dy * 1;
            }
        }
    }

    // homing
    void update() {
        import std.math;

        pos.x += dir.x;
        pos.y += dir.y;
        if (abs(pos.x - target.x) < 0.05 &&
            abs(pos.y - target.y) < 0.05) {
            pos = target;
            dir = Vec(0, 0);
            g_aniState = AniState.pause;
            //g_progVersion = ProgVersion.follow;
        }
    }

	void draw(Display graph, float size, ubyte percent) {
		//graph.drawCircle(pos, size, Color((r == 0 ? 1 + r : r) / percent,(g == 0 ? 1 + g : g) / percent,(b == 0 ? 1 + b : b) / percent, 128), size > 2 ? false : true);
        graph.drawCircle(pos, size, Color(progressFraction(256, percent), 128), size > 2 ? false : true);
	}
}
