module source.app;

//@safe:
import foxid;
import source.dasher;
import source.screen;

import jmisc;

version(unittest)
    import unit_threaded;

import jmisc;

immutable g_stepSize = 24;

/+
	Create our first scene
+/
final class RockDashScene : Scene
{
	import foxid.sdl;

	private Font fontgame;
	
	this() @trusted {
		name = "RockDashScene";

        auto fileName = "assets/screen.txt";
        import std.file, std.string;
        auto data = readText(fileName).split('\n');
        auto p = Vec(0,0);
        foreach(lineNum, line; data) {
            foreach(s; line) {
				add(new Piece(p, s));
                p.x += g_stepSize;
            }
            p.x = 0;
            p.y += g_stepSize;
        }

		fontgame = loader.loadFont("assets/arcade_classic.ttf",14);
		add(new Dasher());
		//add(new Screen("assets/screen.txt"));
	}

	override void draw(Display graph) @safe {
		graph.drawText("Hello Rock Dash fan!", fontgame, Color(255,180,0), Vec(0,0));
	}
}

version(unittest) {
} else {
	int main(string[] args)
	{
		// game setup
		Game game = new Game(640, 480, "* Rock Dash *");
		window.background = Color(0,0,0);

		/+
			Add to the scene in the manager.
		+/
		sceneManager.add(new RockDashScene());

		/+
			We put the very first added scene active
		+/
		sceneManager.inbegin();

		game.handle();

		return 0;
	}
}
