module source.dasher;

import foxid;

import source.app;

final class Dasher : Instance {
    this() @trusted {
        name = "Dasher";

        Animation dirsDasher = new Animation();
        dirsDasher.strip("assets/rockdash5.png", Vec(2.5 * 24,0), 24,24);

        ofsprite.animation = dirsDasher;
        ofsprite.isAnim = true;
        
        position = Vec(5 * g_stepSize, 5 * g_stepSize);

        //shape = ShapeMulti([ShapeRectangle(Vec(0,0), Vec(16,16))]);

        shape = ShapeMulti([
			//ShapeRectangle(Vec(5*24,0),Vec(5*24,24)),
			ShapeRectangle(Vec(7*24,0),Vec(7*24 + 24,24)),
			//ShapeRectangle(Vec(7*24,0),Vec(7*24,24)),
			//ShapeRectangle(Vec(8*24,0),Vec(8*24,24))
        ]);
    }

    override void event(Event event) @safe {
        switch(event.getKeyDown) {
            default: break;
            case Key.right:
                position.x += 24;
            break;
            case Key.left:
                position.x -= 24;
            break;
            case Key.up:
                position.y -= 24;
            break;
            case Key.down:
                position.y += 24;
            break;
        }
    }

	override void eventDestroy() @safe
	{
		ofsprite.animation.free();
	}
}
