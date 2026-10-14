# SuishiBCI

EEGLAB plugin to import **BDF/BDF+** recordings from modern EEG systems into EEGLAB.

Each `.bdf` file is loaded as one continuous dataset (`EEG.trials = 1`). The dataset name (`EEG.setname`) is taken from the file name (without extension). BDF+ annotations are imported into `EEG.event` when present.

Repository: [https://github.com/SuishiBCI/SuishiBCI](https://github.com/SuishiBCI/SuishiBCI)

---

## Requirements

- [EEGLAB](https://sccn.ucsd.edu/eeglab/)
- **MATLAB R2021a or later** (64-bit)
- **Precompiled MEX** (no compile step for most users):
  - **Windows:** `private/SuishiBCI_bdf.mexw64`
  - **Linux:** `private/SuishiBCI_bdf.mexa64` (built/tested with MATLAB R2024a, g++-11)

EEGLAB is required for the menu and plotting, but **not** for a command-line import test (`pop_SuishiBCI` + MEX only).

---

## Installation

1. Copy the entire `SuishiBCI` folder into your EEGLAB `plugins/` directory:

   ```text
   <eeglab>/plugins/SuishiBCI/
   ```

2. Confirm the MEX for your platform is present under `private/`:

   | Platform | File |
   |----------|------|
   | Windows 64-bit | `SuishiBCI_bdf.mexw64` |
   | Linux 64-bit | `SuishiBCI_bdf.mexa64` |

3. Restart MATLAB and start EEGLAB, or run:

   ```matlab
   eeglab redraw
   ```

No compilation is required if the matching precompiled MEX is already in `private/`.

---

## Usage

**Menu:** File > Import data > **From SuishiBCI data (.bdf)**

The file dialog opens in the folder used for the **last successful import** (stored per user under the MATLAB preferences directory). Canceling the dialog does not change the remembered folder.

**Command line** (same calling style as `pop_loadset`: filename with extension, then directory):

```matlab
EEG = pop_SuishiBCI;                                              % file dialog
EEG = pop_SuishiBCI('C:\path\to\data\recording.bdf');             % full path, one argument
EEG = pop_SuishiBCI('recording.bdf', 'C:\path\to\data');        % filename + directory
```

Batch import (loop over full paths):

```matlab
for i = 1:numel(filelist)
    EEG = pop_SuishiBCI(filelist{i});
    % ... process EEG ...
end
```

If you split paths with `fileparts`, use three outputs and keep the extension on the name:

```matlab
[fp, fn, ext] = fileparts('C:\path\to\recording.bdf');
EEG = pop_SuishiBCI([fn ext], fp);
```

After import, use standard EEGLAB tools for filtering, plotting, ICA, and so on. Menu actions are recorded in the EEGLAB command history like other `pop_` functions.

To load several files, call `pop_SuishiBCI` once per file (one `EEG` structure per file).

---

## Demo

A bundled sample BDF is included under `sample_data/` (see [sample_data/README.txt](sample_data/README.txt) for provenance).

**With EEGLAB (GUI):**

```matlab
run(fullfile(eeglabPath, 'plugins', 'SuishiBCI', 'demo', 'demo_SuishiBCI.m'));
```

Or add `.../SuishiBCI/demo` to the path and run `demo_SuishiBCI`.

**Command line only (no EEGLAB GUI):**

```matlab
addpath('/path/to/SuishiBCI');
EEG = pop_SuishiBCI('/path/to/SuishiBCI/sample_data/demo_recording.bdf');
fprintf('nbchan=%d srate=%.1f\n', EEG.nbchan, EEG.srate);
```

On Linux without a desktop session, use `matlab -nodesktop -nosplash -batch "..."`. The demo opens `pop_eegplot` only if EEGLAB is available.

The sample includes illustrative event markers (`1`, `2`, `4`); see `sample_data/README.txt` for details.

---

## Sample data

| Item | Value |
|------|-------|
| File | `sample_data/demo_recording.bdf` (~2.8 MB) |
| Source | Anonymous excerpt from a BCI motor-imagery (MI) test |
| Duration | ~30 s |
| Channels / rate | 32 ch @ 1000 Hz |
| Markers | `1`, `2`, `4` (device-specific; not a standard public ontology) |
| Sharing | Cleared for use in this public repository |

Full notes: [sample_data/README.txt](sample_data/README.txt).

---

## Building the MEX (developers)

Source lives in the companion tree `mex/MEX_BDF_RW/` (`pop_loadTUNEXONDT.cpp` + `edflib/`). Copy the built file into `private/` as `SuishiBCI_bdf.mex*` (name must match).

### Windows

Build with Visual Studio (`MEX_BDF_RW.vcxproj`) or MATLAB:

```matlab
mex -output SuishiBCI_bdf pop_loadTUNEXONDT.cpp
```

Output: `SuishiBCI_bdf.mexw64`

### Linux

Use a **MATLAB-supported g++** on the same machine. On Ubuntu with a very new default `g++`, install **g++-11** so the MEX links against symbols compatible with MATLAB's bundled `libstdc++`:

```bash
sudo apt install gcc-11 g++-11
cd /path/to/mex/MEX_BDF_RW
matlab -nodesktop -nosplash -batch build_mex_linux
cp SuishiBCI_bdf.mexa64 /path/to/SuishiBCI/private/
```

`build_mex_linux.m` sets `CC`/`CXX` to `gcc-11`/`g++-11` and `CXXFLAGS='-std=c++11 -fPIC'`.

If load fails with `GLIBCXX_3.4.32 not found`, rebuild with `g++-11` (not the system default `g++`).

---

## Folder layout

```text
SuishiBCI/
  eegplugin_SuishiBCI.m       plugin entry (EEGLAB menu)
  pop_SuishiBCI.m             import wrapper
  private/
    SuishiBCI_bdf.mexw64      BDF/BDF+ reader (Windows 64-bit)
    SuishiBCI_bdf.mexa64      BDF/BDF+ reader (Linux 64-bit)
    README.txt                  MEX build notes
  sample_data/
    demo_recording.bdf          bundled demo BDF (~30 s)
    README.txt                  sample provenance / license
  demo/
    demo_SuishiBCI.m          quick import demo
  README.md
  LICENSE
```

---

## Troubleshooting

| Issue | What to check |
|-------|----------------|
| Menu item missing | Folder is under `eeglab/plugins/SuishiBCI/`; run `eeglab redraw` |
| Menu grayed out at startup | Update to latest plugin; menu uses `startup:on` for import without a loaded dataset |
| MEX not found | `private/SuishiBCI_bdf.mexw64` (Windows) or `.mexa64` (Linux) exists; 64-bit MATLAB |
| `GLIBCXX_3.4.32 not found` (Linux) | Rebuild MEX with `g++-11`; see **Building the MEX** |
| File not found | `filename` must include `.bdf`; use full path or `[fn ext], fp` from `fileparts` (not swapped) |
| Import fails | File is valid BDF/BDF+; try opening the same file in [EDFbrowser](https://www.teuniz.net/edfbrowser/) |
| Reset file dialog folder | Delete `SuishiBCI_lastdir.mat` in your MATLAB `prefdir`, or import once from the desired folder |
| Demo sample not found | Confirm `sample_data/demo_recording.bdf` is present (shipped with the repository) |
| `demo_SuishiBCI` not found | Add `.../SuishiBCI/demo` to the path, or `run(.../demo/demo_SuishiBCI.m)` |

---

## License

See [LICENSE](LICENSE).
