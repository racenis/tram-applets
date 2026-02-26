CXX      = g++
CXXFLAGS = -O0 -Wall -std=c++20 -I../../../tram-sdk/src -I../../../tram-sdk/libraries -I../../../tram-sdk/libraries/glad
LDFLAGS  = -shared -static-libstdc++ -static-libgcc

TARGET = wrapper.dll

LIBS = ../../../tram-sdk/libtramsdk.a ../../../tram-sdk/libraries/binaries/win64/liblua.a

OBJS = cwrapper.o uiwrapper.o

$(TARGET): $(OBJS) $(LIBS)
	$(CXX) $(LDFLAGS) -o $@ $(OBJS) $(LIBS) -lopengl32 -lgdi32

cwrapper.o: cwrapper.cpp
	$(CXX) $(CXXFLAGS) -c cwrapper.cpp -o cwrapper.o

uiwrapper.o: uiwrapper.cpp
	$(CXX) $(CXXFLAGS) -c uiwrapper.cpp -o uiwrapper.o

clean:
	del $(OBJS) $(TARGET)