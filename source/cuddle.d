module source.cuddle;

@safe:
import std;

import jmisc;

import foxid;

import source.carriage;

class Cuddle {
    private:
    Vec pos;
    int size;

    public:

	const auto getPos() {
		return pos;
	}

    const auto getSize() {
        return size;
    }

    this(Vec pos, int size) {
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
            if  (this !is cu) {
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

	void draw(Display graph) {
		graph.drawCircle(pos, size, Color(0,255,255, 128), true);
	}
}
