Sample data for demo_SuishiBCI.m
==================================

File
----
  demo_recording.bdf  (~2.8 MB, ~30 s)

Source
------
  Anonymous excerpt from a BCI motor-imagery (MI) test recording.
  Trimmed to ~30 s for repository use.

Markers
-------
  Includes BDF+ annotations with labels 1, 2, and 4.
  These are device-specific codes, not a standard public ontology.
  After import, inspect EEG.event in MATLAB or use EEGLAB event tools.

License / sharing
-----------------
  Cleared for inclusion in this public repository as a demonstration file.

Usage
-----
  From MATLAB (with EEGLAB or the plugin on the path):

    demo_SuishiBCI

  Or load directly:

    EEG = pop_SuishiBCI('demo_recording.bdf', '<path>/SuishiBCI/sample_data');

See also
--------
  ../README.md          project overview and installation
  ../demo/demo_SuishiBCI.m

Replacing this file
-------------------
  Keep the name demo_recording.bdf, or update demo/demo_SuishiBCI.m
  and document changes here.
