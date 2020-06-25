module source.collect;

@safe:
import std;

import jmisc;

import foxid;

import source.sceneandparticals;

class Collect {
    Vector pos;
    int size;

    this(Vector pos, int size) {
        this.pos = pos;
        this.size = size;
    }

    void update(Partical m, Collect[] cols) {
        float dx, dy;

        xyaim(dx, dy, getAngle(pos.x, pos.y, m.pos.x, m.pos.y));
        pos.x += dx * 1;
        pos.y += dy * 1;

        if (distance(m.pos.x, m.pos.y, pos.x, pos.y) < m.size + size) {
            xyaim(dx, dy, getAngle(pos.x, pos.y, m.pos.x, m.pos.y));
            pos.x -= dx * 2;
            pos.y -= dy * 2;
        }

        foreach(const c; cols) {
            if  (this !is c) {
                if (distance(c.pos.x, c.pos.y, pos.x, pos.y) < c.size + size) {
                    xyaim(dx, dy, getAngle(pos.x, pos.y, c.pos.x, c.pos.y));
                    pos.x -= dx * 1;
                    pos.y -= dy * 1;
                }
            }
        }
    }

	void draw(Display graph) {
		graph.drawCircle(pos, size, Color(0,255,255, 128), true);
	}
}
