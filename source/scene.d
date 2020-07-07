module source.scene;

@safe:
import foxid;

version(unittest)
    import unit_threaded;

import jmisc;

import source.base, source.carriage, source.cuddle;

/+
	Create our first scene
+/
class MyScene : Scene
{
	Carriage[] train;
	Cuddle[] cuds;
	Sprite spr;
	import foxid.sdl;
	SDL_Surface* image;

	/+
		Circle position.
	+/
	Carriage mouse_circle;

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
		mouse_circle = new Carriage(Vec(0,0));
		mouse_circle.setSize = mouse_circle_size;

		import std;
		
		foreach(i; num_of_chain_objects.iota) {
			train ~= new Carriage(Vec(uniform(0, 640), uniform(0, 480)));
		}
		foreach(i; num_of_cuddle_objects.iota) {
			cuds ~= new Cuddle(Vec(uniform(0, 640), uniform(0, 480)), uniform(0, size_max));
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
		mouse_circle.setPos = event.getMousePosition();

	}

	override void step() {
		foreach(i, p; train)
			p.update(i != train.length - 1 ? train[i + 1] : mouse_circle, cuds);
		foreach (Cuddle c; cuds) {
			c.update(mouse_circle, cuds, train);
		}
	}

	/+
		Rendering something in the scene

		- foxid.scene.Scene.draw(Display)
	+/
	override void draw(Display graph)
	{
		foreach(p; train)
			p.draw(graph);

		foreach(c; cuds)
			c.draw(graph);

		/+
			Draw a circle.

			- foxid.display
		+/
		graph.drawCircle(mouse_circle.getPos, mouse_circle.getSize, Color("#FF0000"), true);
	}

}

version(none)
@("Play")
unittest {
	
	Game game = new Game(640, 480, "Solid Circles Animated - Test");
	render.background = Color("#EE7C3F");

	foxscene.add(new MyScene());

	foxscene.inbegin();

	Carriage[] ps;
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
	Carriage[] ps;

	immutable count = 200;

	ps.length = count;
	assert(ps.length == 200);
}
