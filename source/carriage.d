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
	// Not sure I need id
	static int currentID;
	int id;

	Vec pos; // position
	int size; // Radius (I think)

	public:

	const auto getPos() { return pos; }

	const auto getSize() { return size; }

	void setSize(int size0) { size = size0; }

	void setPos(Vec pos0) { pos = pos0; }

	/// init given space, set size
	this(Vec pos) {
		id = currentID;
		currentID += 1;
		this.pos = pos;

		// each consecutive size gets bigger and bigger, then smaller and smaller
		globel_size += (bigger ? size_step : -size_step);
		size = globel_size;
		if (size >= size_max)
			bigger = false;
		else if (size <= size_min)
			bigger = true;
	}

	/++
	follow leader
	move away from on top of collecters
	+/
	void update(Carriage leader, Cuddle[] cuds) {
		float dx, dy;
		if (distance(leader.getPos.x, leader.getPos.y, pos.x, pos.y) > (leader.size + size)) { //gap_distance) {
			xyaim(dx, dy, getAngle(pos.x, pos.y, leader.getPos.x, leader.getPos.y));
			pos.x += dx * move_step;
			pos.y += dy * move_step;
		}

		version(none)
			foreach(const c; train) {
				if (c !is leader && distance(c.getPos.x, c.getPos.y, pos.x, pos.y) < c.getSize + size) {
					xyaim(dx, dy, getAngle(pos.x, pos.y, c.getPos.x, c.getPos.y));
					pos.x -= dx * 1;
					pos.y -= dy * 1;
				}
			}

        foreach(const cu; cuds) {
			if (distance(cu.getPos.x, cu.getPos.y, pos.x, pos.y) < cu.getSize + size) {
				xyaim(dx, dy, getAngle(pos.x, pos.y, cu.getPos.x, cu.getPos.y));
				pos.x -= dx * 1;
				pos.y -= dy * 1;
			}
        }
	}

	void draw(Display graph) {
		graph.drawCircle(pos, size, Color(255,255,0, 128), true);
	}
}
