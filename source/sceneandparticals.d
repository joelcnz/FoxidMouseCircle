module source.sceneandparticals;

@safe:
import foxid;

version(unittest)
    import unit_threaded;

import jmisc;

import source.base, source.collect;

/+
	Create our first scene
+/
class MyScene : Scene
{
	Partical[] ps;
	Collect[] cols;
	Sprite spr;
	import foxid.sdl;
	SDL_Surface* image;

	ref auto getParticals() { return ps; }

	/+
		Circle position.
	+/
	Partical mouse_circle;

	void initSprite() @system {
		spr = new Sprite();
		import std.file : exists;
		import std.string : toStringz;
		import foxid.sdl;

		immutable fileName = "../Res/hello_world.bmp";
		assert(fileName.exists);
		image = SDL_LoadBMP( fileName.toStringz );
		assert(image);
		SDL_FreeSurface(image);
		assert(! image);
	}

	override void init() {
		mouse_circle = new Partical(Vector(0,0));
		mouse_circle.size = mouse_circle_size;

		import std;
		
		foreach(i; num_of_chain_objects.iota) {
			ps ~= new Partical(Vector(uniform(0, 640), uniform(0, 480)));
		}
		foreach(i; num_of_cuddle_objects.iota) {
			cols ~= new Collect(Vector(uniform(0, 640), uniform(0, 480)), uniform(0, size_max));
		}
	}

	/+
		Event handler

		- foxid.scene.Scene.event(Event)
	+/
	override void event(Event event)
	{
		/+
			The position of the circle is equal to 
			the coordinates of the mouse.
		+/
		mouse_circle.pos = event.getMousePosition();

	}

	override void step() {
		foreach(i, p; ps)
			p.update(i != ps.length - 1 ? ps[i + 1] : mouse_circle);
		foreach (Collect c; cols) {
			c.update(mouse_circle, cols);
		}
	}

	/+
		Rendering something in the scene

		- foxid.scene.Scene.draw(Display)
	+/
	override void draw(Display graph)
	{
		foreach(p; ps)
			p.draw(graph);

		foreach(c; cols)
			c.draw(graph);

		/+
			Draw a circle.

			- foxid.display
		+/
		graph.drawCircle(mouse_circle.pos, mouse_circle.size, Color("#FF0000"), true);
	}

}

version(none)
@("Play")
unittest {
	
	Game game = new Game(640, 480, "Solid Circles Animated - Test");
	render.background = Color("#EE7C3F");

	foxscene.add(new MyScene());

	foxscene.inbegin();

	Partical[] ps;
	ps.length = 10;
	ps.length.shouldEqual(10);

	game.handle();
}

@("Between1")
unittest {
	int a = 9;

	a.shouldBeBetween(1,10);
}

@("Between2")
unittest {
	int a = 1;

	a.shouldBeBetween(1,10);
}

@("Between3")
unittest {
	int a = 5;

	a.shouldBeBetween(1,10);
}


int adder(int i, int j) { return i + j; }

@("Horse")
unittest  {
	adder(2, 3).shouldEqual(5);
}

@("Cannon")
unittest {
	Partical[] ps;

	immutable count = 200;

	ps.length = count;
	assert(ps.length == 200);
}

class Partical {
	static int currentID;
	int id;
	Vector pos;
	int size;

	this(Vector pos) {
		id = currentID;
		currentID += 1;
		this.pos = pos;

		globel_size += (bigger ? size_step : -size_step);
		size = globel_size;
		if (size >= size_max)
			bigger = false;
		else if (size <= size_min)
			bigger = true;
	}

	void update(Partical leader) {
		if (distance(leader.pos.x, leader.pos.y, pos.x, pos.y) > (leader.size + size)) { //gap_distance) {
			float dx, dy;
			xyaim(dx, dy, getAngle(pos.x, pos.y, leader.pos.x, leader.pos.y));
			pos.x += dx * move_step;
			pos.y += dy * move_step;
		}
	}

	auto getPos() {
		return pos;
	}

	void draw(Display graph) {
		graph.drawCircle(pos, size, Color(255,255,0, 128), true);
	}
}
