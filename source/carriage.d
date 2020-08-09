module source.carriage;

@safe:
import foxid;

import jmisc;

import source.base, source.cuddle;

/++
	Part of train collection. Each object follows the one other object (the first follows the mouse pointer)
+/
class Carriage {
	private:
	Vec pos; // position
	float size; // Radius (I think)

	public:

	const getPos() { return pos; }

	const getSize() { return size; }

	void setSize(float size0) { size = size0; }

	void setPos(Vec pos0) { pos = pos0; }

	/// init given space, set size
	this(Vec pos = Vec(0,0)) {
		this.pos = pos;

		// each consecutive size gets bigger and bigger, then smaller and smaller
		global_size += (bigger ? size_step : -size_step);
		size = global_size;
		if (size >= size_max)
			bigger = false;
		else if (size <= size_min)
			bigger = true;
	}

	/++
	follow leader

	move away from on top of collecters

	Params:
		leader  = mouse location
		cuds = cuddlers
	+/
	void update(Carriage leader, Cuddle[] cuds,) {
		float dx, dy;

		// Head for pointer
		if (distance(leader.getPos.x, leader.getPos.y, pos.x, pos.y) > (leader.size + size)) {
			xyaim(dx, dy, getAngle(pos.x, pos.y, leader.getPos.x, leader.getPos.y));
			pos.x += dx * move_step;
			pos.y += dy * move_step;
		}

		// Move off
        foreach(const cu; cuds) {
			if (distance(cu.getPos.x, cu.getPos.y, pos.x, pos.y) < cu.getSize + size) {
				xyaim(dx, dy, getAngle(pos.x, pos.y, cu.getPos.x, cu.getPos.y));
				pos.x -= dx * 1;
				pos.y -= dy * 1;
			}
        }

		version(none)
			// Move off train carriages
			foreach(const c; train) {
				if (c !is leader && distance(c.getPos.x, c.getPos.y, pos.x, pos.y) < c.getSize + size) {
					xyaim(dx, dy, getAngle(pos.x, pos.y, c.getPos.x, c.getPos.y));
					pos.x -= dx * 1;
					pos.y -= dy * 1;
				}
			}
	}

	/++
	Draw solid circle
	+/
	void draw(Display graph, float size, ubyte c) {
		//graph.drawCircle(pos, size, Color(255,255,0, 128), true);
		graph.drawCircle(pos, size, Color(c,c,0, 128), size > 2 ? false : true); //true);
	}
}
