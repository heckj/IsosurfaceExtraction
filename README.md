# Isosurface Extraction

Implementations and examples of Isosurface Extraction algorithms (marching cubes, surface nets, dual contouring)

Some of the files included in this project are copies of public implementations of these algorithms, and are under their own licenses.

## Marching Cubes

Paul Bourke's original document: [Polygonising a scalaar field](http://paulbourke.net/geometry/polygonise/) is a fantastic explanation. 
I also found Boris the Brave's [Marching Cubes Tutorial](https://www.boristhebrave.com/2018/04/15/marching-cubes-tutorial/) to be a very accessible version.

Original C implementation:
- http://paulbourke.net/geometry/polygonise/

JavaScript implementation:
- https://github.com/mikolalysenko/mikolalysenko.github.com/blob/master/Isosurface/js/marchingcubes.js

Python implementation:
- https://github.com/BorisTheBrave/mc-dc/blob/master/marching_cubes_3d.py

The swift implementation is meant to be independent of [SceneKit](http://developer.apple.com/documentation/scenekit/) or [RealityKit](http://developer.apple.com/documentation/realitykit/). 
Each of which have slightly different API interfaces for providing the raw meshes for 3D objects. 
