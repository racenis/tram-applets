CXX      = g++
CXXFLAGS = -O0 -Wall -std=c++20 -I../../../tram-sdk/src -I../../../tram-sdk/libraries -I../../../tram-sdk/libraries/glad
LDFLAGS  = -shared -static-libstdc++ -static-libgcc

TARGET = wrapper.dll

LIBS = ../../../tram-sdk/libtramsdk.a ../../../tram-sdk/libraries/binaries/win64/liblua.a

OBJS = cwrapper.o uiwrapper.o resource.o material.o model.o animation.o entitycomponent.o animationcomponent.o rendercomponent.o meshcomponent.o meshtools.o

$(TARGET): $(OBJS) $(LIBS)
	$(CXX) $(LDFLAGS) -o $@ $(OBJS) $(LIBS) -lopengl32 -lgdi32

resource.o: resource.cpp
	$(CXX) $(CXXFLAGS) -c resource.cpp -o resource.o
material.o: material.cpp
	$(CXX) $(CXXFLAGS) -c material.cpp -o material.o
model.o: model.cpp
	$(CXX) $(CXXFLAGS) -c model.cpp -o model.o
animation.o: animation.cpp
	$(CXX) $(CXXFLAGS) -c animation.cpp -o animation.o
entitycomponent.o: entitycomponent.cpp
	$(CXX) $(CXXFLAGS) -c entitycomponent.cpp -o entitycomponent.o
rendercomponent.o: rendercomponent.cpp
	$(CXX) $(CXXFLAGS) -c rendercomponent.cpp -o rendercomponent.o
meshcomponent.o: meshcomponent.cpp
	$(CXX) $(CXXFLAGS) -c meshcomponent.cpp -o meshcomponent.o
meshtools.o: meshtools.cpp
	$(CXX) $(CXXFLAGS) -c meshtools.cpp -o meshtools.o
	
cwrapper.o: cwrapper.cpp
	$(CXX) $(CXXFLAGS) -c cwrapper.cpp -o cwrapper.o

uiwrapper.o: uiwrapper.cpp
	$(CXX) $(CXXFLAGS) -c uiwrapper.cpp -o uiwrapper.o

clean:
	del $(OBJS) $(TARGET)