//#set value not work
module source.scene;

@safe:
import foxid;
import foxid.gui;

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
	Slider mouseSizeSlider,
		cuddleSizeSlider,
		carriageSizeSlider;

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
		size_min = size_step;
		global_size = size_min - size_step;

		mouse_circle = new Carriage();
		mouse_circle.setSize = mouse_circle_size;

		float textHpos = 140, hStep = 20;

		mouseSizeSlider = new Slider();
		mouseSizeSlider.position = Vec(10, 1 * hStep);
		//mouseSizeSlider.value = mouse_circle_size; //#set value not work
		auto mouseSliderText = new TextBox();
		mouseSliderText.font = loader.loadFont("../../Res/sans.ttf",14);
		mouseSliderText.position = Vec(textHpos, 1 * hStep);
		mouseSliderText.placeholder = "Pointer size";

		carriageSizeSlider = new Slider();
		carriageSizeSlider.position = Vec(10, 2 * hStep);
		auto carriageSliderText = new TextBox();
		carriageSliderText.position = Vec(textHpos, 2 * hStep);
		carriageSliderText.font = mouseSliderText.font;
		carriageSliderText.placeholder = "Train Size";

		cuddleSizeSlider = new Slider();
		cuddleSizeSlider.position = Vec(10, 3 * hStep);
		auto cuddleSliderText = new TextBox();
		cuddleSliderText.position = Vec(textHpos, 3 * hStep);
		cuddleSliderText.font = mouseSliderText.font;
		cuddleSliderText.placeholder = "Cuddles Size";

		add([mouseSizeSlider, mouseSliderText,
			carriageSizeSlider, carriageSliderText,
			cuddleSizeSlider, cuddleSliderText]);


/+
		TextBox tb = new TextBox();
		tb.font = loader.loadFont("../../Res/sans.ttf",14);
		tb.placeholder = "Input ..";
		tb.position = Vec(32,32);
+/
		import std.range : iota;
		import std.random : uniform;
		
		foreach(i; num_of_chain_objects.iota) {
			train ~= new Carriage(Vec(uniform(0, 640), uniform(0, 480)));
		}
		foreach(i; num_of_cuddle_objects.iota) {
			cuds ~= new Cuddle(Vec(uniform(0, 640), uniform(0, 480)), uniform(size_min, size_max));
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
		if (mouse_circle.getSize != mouseSizeSlider.value) {
			mouse_circle_size = mouseSizeSlider.value;
			mouse_circle.setSize = mouse_circle_size;
		}

		if (train.length && train[0].getSize != carriageSizeSlider.value) {
			foreach(ref ca; train)
				ca.setSize = carriageSizeSlider.value;
		}

		if (cuds.length && cuds[0].getSize != cuddleSizeSlider.value) {
			foreach(ref cu; cuds)
				cu.setSize = cuddleSizeSlider.value;
		}

		foreach(i, ca; train)
			ca.update(i != train.length - 1 ? train[i + 1] : mouse_circle, cuds);
		foreach(cu; cuds) {
			cu.update(mouse_circle, cuds, train);
		}
	}

	/+
		Rendering something in the scene

		- foxid.scene.Scene.draw(Display)
	+/
	override void draw(Display graph)
	{
		if (train.length && cuds.length) {
			import std.range : iota;
			import std.string : split;
			immutable caColStep = 255 / train[0].getSize;
			immutable cuColStep = 255 / cuds[0].getSize;
			float ca2 = caColStep;
			float cu2 = cuColStep;
			float cas = train[0].getSize,
				cus = cuds[0].getSize;
			do {
				ca2 += caColStep;
				cu2 += cuColStep;
				if (ca2 > -1)
					foreach(p; train)
						p.draw(graph, cas, cast(ubyte)ca2);

				if (cu2 > -1)
					foreach(c; cuds)
						c.draw(graph, cus, cast(ubyte)cu2);
				
				cas -= 1;
				cus -= 1;
			} while(! (cas < 1 && cus < 1));
		} // if both have at lessed one object

		/+
			Draw a circle.

			- foxid.display
		+/
		graph.drawCircle(mouse_circle.getPos, mouse_circle.getSize, Color("#AA0000"), false);
		graph.drawCircle(mouse_circle.getPos, mouse_circle.getSize - 1, Color("#FF0000"), true);
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
