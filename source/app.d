module source.app;

//@safe:
import foxid;

import source.sceneandparticals;

import bindbc.openal;

import jmisc;

void soundSetup() @system {
	/*
	This version attempts to load the OpenAL shared library using well-known variations
	of the library name for the host system.
	*/
	ALSupport ret = loadOpenAL();
	if(ret != ALSupport.al11) {
		// Handle error. For most use cases, its reasonable to use the the error handling API in
		// bindbc-loader to retrieve error messages and then abort. If necessary, it's  possible
		// to determine the root cause via the return value:
		"ret != ALSupport.al11".gh;

		if(ret == ALSupport.noLibrary) {
			// GLFW shared library failed to load
			"ret == ALSupport.noLibrary".gh;
		}
		else if(ALSupport.badLibrary) {
			// One or more symbols failed to load. 
			"ALSupport.badLibrary".gh;
		}
		return;
	} else
		"supported".gh;

	// Initialize Open AL
	auto device = alcOpenDevice(null);
	// open default device
	if (device !is null) {
		auto context=alcCreateContext(device,null); // create context
		if (context !is null) {
			alcMakeContextCurrent(context); // set active context
			
			float[3] listenerPos = [0,0,0];
			alListener3f(AL_POSITION, listenerPos[0], listenerPos[1], listenerPos[2]);

			float listenerAngle = 0.5;

			import std.math : sin, cos;
			float[6] directionvect;
			directionvect[0] = cast(float) sin(listenerAngle);
			directionvect[1] = 0;
			directionvect[2] = cast(float) cos(listenerAngle);
			directionvect[3] = 0;
			directionvect[4] = 1;
			directionvect[5] = 0;
			alListenerfv(AL_ORIENTATION, directionvect.ptr);

			static void list_audio_devices(ALCchar* devices)
			{
				ALCchar* device = devices, next = devices + 1;
				size_t len = 0;

				import std;

				size_t strlen(ALCchar* s) {
					size_t n;
					while(s[n] != '\0') {
						n += 1;
					}
					return n;
				}

				write("Devices list:\n");
				write("----------\n");
				while (device && *device != '\0' && next && *next != '\0') {
					len = strlen(device);
					printf("%s\n", device[0 .. len].ptr);
					device += (len + 1);
					next += (len + 2);
				}
				write("----------\n");
			}

			list_audio_devices(cast(ALCchar*)alcGetString(null, ALC_DEVICE_SPECIFIER));

			ALfloat* listenerOri = [ 0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f ].ptr;

			alListener3f(AL_POSITION, 0, 0, 1.0f);
			// check for errors
			alListener3f(AL_VELOCITY, 0, 0, 0);
			// check for errors
			alListenerfv(AL_ORIENTATION, listenerOri);
			// check for errors

			ALuint source;


			alGenSources(cast(ALuint)1, &source);
			// check for errors

			alSourcef(source, AL_PITCH, 1);
			// check for errors
			alSourcef(source, AL_GAIN, 1);
			// check for errors
			alSource3f(source, AL_POSITION, 0, 0, 0);
			// check for errors
			alSource3f(source, AL_VELOCITY, 0, 0, 0);
			// check for errors
			alSourcei(source, AL_LOOPING, AL_FALSE);
			// check for errors

			ALuint buffer;

			alGenBuffers(cast(ALuint)1, &buffer);
			// check for errors

/+
			auto fileName = "2ingthemorning.wav";
			ALsizei size, freq;
			ALenum format;
			ALvoid* data;
			ALboolean loop = AL_FALSE;

			//alutLoadWAVFile(fileName.ptr, &format, &data, &size, &freq, &loop);
			// check for errors
+/
			import core.stdc.stdio;
			import core.stdc.stdlib;
		}
	}
}

version(unittest) {
} else {
	int main(string[] args)
	{
		soundSetup;

		Game game = new Game(640, 480, "Solid Circles Animated - Test");
		render.background = Color("#EE7C3F");

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