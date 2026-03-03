#include "meshtools.h"

#include <extensions/meshtools/primitives.h>

using namespace tram;

void sdk_ext_meshtools_make_cube_sphere(void* mesh, int subdivisions, float radius) {
	Ext::Meshtools::MakeCubeSphere(*(MeshComponent*)mesh, subdivisions, radius);
}