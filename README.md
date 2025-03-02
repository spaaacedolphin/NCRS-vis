# NCRS-vis

NCRS-vis is a visualization program for .ncrs files.
https://spacedolphin.net/ncrs/

## Open this project in Godot's editor

- Prerequisite : Godot with large world coordinates enabled

By default, Godot uses single-precision(32-bit) floats for vectors.
Because NCRS uses double-precision(64-bit) floats for vectors, we need to enable large world coordinates.
https://docs.godotengine.org/en/stable/tutorials/physics/large_world_coordinates.html#enabling-large-world-coordinates

1. Clone this repository:
	```bash
	git clone https://github.com/spaaacedolphin/NCRS-vis.git
	```
2. Download starmap_2020_8k_gal.exr from https://svs.gsfc.nasa.gov/4851/#media_group_319122
