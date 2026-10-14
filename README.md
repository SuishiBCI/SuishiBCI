# SuiEEG_load

EEGLAB plugin to import **BDF/BDF+** recordings from modern EEG systems into EEGLAB.

Each `.bdf` file is loaded as one continuous dataset (`EEG.trials = 1`). The dataset name (`EEG.setname`) is taken from the file name (without extension). BDF+ annotations are imported into `EEG.event` when present.

Repository: [https://github.com/brainwatcher/SuiEEG_load](https://github.com/brainwatcher/SuiEEG_load)

---

## Requirements

- [EEGLAB](https://sccn.ucsd.edu/eeglab/)
- **MATLAB R2021a or later** (64-bit)
- **Precompiled MEX** (no compile step for most users):
  - **Windows:** `private/suieeg_load_bdf.mexw64`
  - **Linux:** `private/suieeg_load_bdf.mexa64` (built/tested with MATLAB R2024a, g++-11)

EEGLAB is required for the menu and plotting, but **not** for a command-line import test (`pop_SuiEEG_load` + MEX only).

---

## Installation

1. Copy the entire `SuiEEG_load` folder into your EEGLAB `plugins/` directory:

   ```text
   <eeglab>/plugins/SuiEEG_load/
   ```

2. Confirm the MEX for your platform is present under `private/`:

   | Platform | File |
   |----------|------|
   | Windows 64-bit | `suieeg_load_bdf.mexw64` |
   | Linux 64-bit | `suieeg_load_bdf.mexa64` |

3. Restart MATLAB and start EEGLAB, or run:

   ```matlab
   eeglab redraw
   ```

No compilation is required if the matching precompiled MEX is already in `private/`.

---

## Usage

**Menu:** File > Import data > **From SuiEEG BDF (.bdf)**

The file dialog opens in the folder used for the **last successful import** (stored per user under the MATLAB preferences directory). Canceling the dialog does not change the remembered folder.

**Command line** (same calling style as `pop_loadset`: filename with extension, then directory):

```matlab
EEG = pop_SuiEEG_load;                                              % file dialog
EEG = pop_SuiEEG_load('C:\path\to\data\recording.bdf');             % full path, one argument
EEG = pop_SuiEEG_load('recording.bdf', 'C:\path\to\data');        % filename + directory
```

Batch import (loop over full paths):

```matlab
for i = 1:numel(filelist)
    EEG = pop_SuiEEG_load(filelist{i});
    % ... process EEG ...
end
```

If you split paths with `fileparts`, use three outputs and keep the extension on the name:

```matlab
[fp, fn, ext] = fileparts('C:\path\to\recording.bdf');
EEG = pop_SuiEEG_load([fn ext], fp);
```

After import, use standard EEGLAB tools for filtering, plotting, ICA, and so on. Menu actions are recorded in the EEGLAB command history like other `pop_` functions.

To load several files, call `pop_SuiEEG_load` once per file (one `EEG` structure per file).

---

## Demo

A bundled sample BDF is included under `sample_data/` (see [sample_data/README.txt](sample_data/README.txt) for provenance).

**With EEGLAB (GUI):**

```matlab
run(fullfile(eeglabPath, 'plugins', 'SuiEEG_load', 'demo', 'demo_SuiEEG_load.m'));
```

Or add `.../SuiEEG_load/demo` to the path and run `demo_SuiEEG_load`.

**Command line only (no EEGLAB GUI):**

```matlab
addpath('/path/to/SuiEEG_load');
EEG = pop_SuiEEG_load('/path/to/SuiEEG_load/sample_data/demo_recording.bdf');
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

Source lives in the companion tree `mex/MEX_BDF_RW/` (`pop_loadTUNEXONDT.cpp` + `edflib/`). Copy the built file into `private/` as `suieeg_load_bdf.mex*` (name must match).

### Windows

Build with Visual Studio (`MEX_BDF_RW.vcxproj`) or MATLAB:

```matlab
mex -output suieeg_load_bdf pop_loadTUNEXONDT.cpp
```

Output: `suieeg_load_bdf.mexw64`

### Linux

Use a **MATLAB-supported g++** on the same machine. On Ubuntu with a very new default `g++`, install **g++-11** so the MEX links against symbols compatible with MATLAB's bundled `libstdc++`:

```bash
sudo apt install gcc-11 g++-11
cd /path/to/mex/MEX_BDF_RW
matlab -nodesktop -nosplash -batch build_mex_linux
cp suieeg_load_bdf.mexa64 /path/to/SuiEEG_load/private/
```

`build_mex_linux.m` sets `CC`/`CXX` to `gcc-11`/`g++-11` and `CXXFLAGS='-std=c++11 -fPIC'`.

If load fails with `GLIBCXX_3.4.32 not found`, rebuild with `g++-11` (not the system default `g++`).

---

## Folder layout

```text
SuiEEG_load/
  eegplugin_SuiEEG_load.m       plugin entry (EEGLAB menu)
  pop_SuiEEG_load.m             import wrapper
  private/
    suieeg_load_bdf.mexw64      BDF/BDF+ reader (Windows 64-bit)
    suieeg_load_bdf.mexa64      BDF/BDF+ reader (Linux 64-bit)
    README.txt                  MEX build notes
  sample_data/
    demo_recording.bdf          bundled demo BDF (~30 s)
    README.txt                  sample provenance / license
  demo/
    demo_SuiEEG_load.m          quick import demo
  README.md
  LICENSE
```

---

## Troubleshooting

| Issue | What to check |
|-------|----------------|
| Menu item missing | Folder is under `eeglab/plugins/SuiEEG_load/`; run `eeglab redraw` |
| Menu grayed out at startup | Update to latest plugin; menu uses `startup:on` for import without a loaded dataset |
| MEX not found | `private/suieeg_load_bdf.mexw64` (Windows) or `.mexa64` (Linux) exists; 64-bit MATLAB |
| `GLIBCXX_3.4.32 not found` (Linux) | Rebuild MEX with `g++-11`; see **Building the MEX** |
| File not found | `filename` must include `.bdf`; use full path or `[fn ext], fp` from `fileparts` (not swapped) |
| Import fails | File is valid BDF/BDF+; try opening the same file in [EDFbrowser](https://www.teuniz.net/edfbrowser/) |
| Reset file dialog folder | Delete `SuiEEG_load_lastdir.mat` in your MATLAB `prefdir`, or import once from the desired folder |
| Demo sample not found | Confirm `sample_data/demo_recording.bdf` is present (shipped with the repository) |
| `demo_SuiEEG_load` not found | Add `.../SuiEEG_load/demo` to the path, or `run(.../demo/demo_SuiEEG_load.m)` |

---

## License

See [LICENSE](LICENSE).
