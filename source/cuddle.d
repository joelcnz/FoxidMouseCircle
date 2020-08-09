module source.cuddle;

@safe:
import std;

import jmisc;

import foxid;

import source.carriage;

class Cuddle {
    private:
    Vec pos;
    float size;

    public:
	const getPos() {
		return pos;
	}

	void setSize(float size0) { size = size0; }

    const getSize() {
        return size;
    }

    this(Vec pos, float size) {
        this.pos = pos;
        this.size = size;
    }

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

	void draw(Display graph, float size, ubyte c) {
		graph.drawCircle(pos, size, Color(0,c,c, 128), size > 2 ? false : true); //true);
	}
}
