module source.app;

//@safe:
import foxid;

import source.scene;

import jmisc;

version(unittest) {
} else {
	int main(string[] args)
	{
		// game setup
		Game game = new Game(640, 480, "Solid Circles Animated - Test");
		window.background = Color("#EE7C3F");

		/+
			Add to the scene in the manager.
		+/
		foxscene.add(new MyScene());

		/+
			We put the very first added scene active
		+/
		foxscene.inbegin();

		game.handle();

		return 0;
	}
}
