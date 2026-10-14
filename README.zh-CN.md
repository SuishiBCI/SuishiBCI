# SuishiBCI

[English](README.md) | **简体中文**

**SuishiBCI** 是一款用于 [EEGLAB](https://sccn.ucsd.edu/eeglab/) 的数据导入插件，可将脑电采集系统记录的 **BDF/BDF+** 格式数据导入 EEGLAB，便于后续分析。

每个 `.bdf` 文件导入后对应一个连续的 EEG 数据集（`EEG.trials = 1`）；数据集名称（`EEG.setname`）取自文件名（不含扩展名）。如果文件包含 BDF+ 注释信息，插件会将其导入 `EEG.event`。

项目仓库：[https://github.com/SuishiBCI/SuishiBCI](https://github.com/SuishiBCI/SuishiBCI)

---

## 运行环境

- [EEGLAB](https://sccn.ucsd.edu/eeglab/)
- **MATLAB R2021a 或更高版本**（64 位）
- 对应操作系统的**预编译 MEX 文件**（大多数用户无需自行编译）：
  - **Windows：**`private/SuishiBCI_bdf.mexw64`
  - **Linux：**`private/SuishiBCI_bdf.mexa64`（已在 MATLAB R2024a、g++-11 环境下编译及测试）

EEGLAB 用于提供图形菜单和绘图功能。如果仅通过命令行测试数据导入功能，可以只使用 `pop_SuishiBCI` 和对应的 MEX 文件，而不启动 EEGLAB。

> **平台说明：**当前仓库提供 Windows 和 Linux 64 位的预编译 MEX 文件，未提供 macOS 版本。

---

## 安装方法

1. 下载或克隆本仓库，将整个 `SuishiBCI` 文件夹放入 EEGLAB 的 `plugins/` 目录：

   ```text
   <eeglab>/plugins/SuishiBCI/
   ```

2. 确认 `private/` 目录中存在与你的操作系统匹配的 MEX 文件：

   | 平台 | MEX 文件 |
   |---|---|
   | Windows 64 位 | `SuishiBCI_bdf.mexw64` |
   | Linux 64 位 | `SuishiBCI_bdf.mexa64` |

3. 重新启动 MATLAB 并运行 EEGLAB；如果 EEGLAB 已打开，也可在 MATLAB 命令窗口执行：

   ```matlab
   eeglab redraw
   ```

若对应平台的预编译 MEX 文件已存在于 `private/` 目录中，则无需自行编译。

---

## 使用方法

### 通过 EEGLAB 菜单导入

在 EEGLAB 主界面中依次选择：

**File → Import data → From SuishiBCI data (.bdf)**

选择待导入的 `.bdf` 文件即可。文件选择窗口会记住**上一次成功导入**时使用的文件夹；该路径保存在当前用户的 MATLAB 首选项目录下。取消文件选择不会更改已记住的路径。

### 通过 MATLAB 命令行导入

`pop_SuishiBCI` 的参数使用方式与 `pop_loadset` 类似，可以传入完整文件路径，或分别指定带扩展名的文件名与所在目录。

```matlab
% 打开文件选择对话框
EEG = pop_SuishiBCI;

% 使用完整文件路径
EEG = pop_SuishiBCI('C:\path\to\data\recording.bdf');

% 分别指定文件名和目录
EEG = pop_SuishiBCI('recording.bdf', 'C:\path\to\data');
```

批量导入多个文件（`filelist` 为包含各文件完整路径的元胞数组）：

```matlab
for i = 1:numel(filelist)
    EEG = pop_SuishiBCI(filelist{i});
    % 在此处理当前 EEG 数据
end
```

如果使用 `fileparts` 分离文件路径，请获取三个输出，并在传入文件名时保留扩展名：

```matlab
[fp, fn, ext] = fileparts('C:\path\to\recording.bdf');
EEG = pop_SuishiBCI([fn ext], fp);
```

导入后，可继续使用 EEGLAB 的标准功能进行滤波、波形显示、独立成分分析（ICA）等处理。与其他 `pop_` 函数一样，通过菜单执行的导入操作会记录在 EEGLAB 命令历史中。

**注意：**每次调用 `pop_SuishiBCI` 导入一个文件，并返回一个相应的 `EEG` 结构。如果要加载多个文件，请分别调用该函数。

---

## 示例演示

仓库的 `sample_data/` 目录中提供了一个示例 BDF 文件。其来源及使用说明见 [`sample_data/README.txt`](sample_data/README.txt)。

### 在 EEGLAB 中运行演示

如果已经知道 EEGLAB 的安装目录，可执行：

```matlab
run(fullfile(eeglabPath, 'plugins', 'SuishiBCI', 'demo', 'demo_SuishiBCI.m'));
```

其中 `eeglabPath` 为 EEGLAB 安装目录的路径变量。

也可以将 `SuishiBCI/demo` 文件夹添加到 MATLAB 路径，然后运行：

```matlab
demo_SuishiBCI
```

### 仅通过命令行测试导入

```matlab
addpath('/path/to/SuishiBCI');
EEG = pop_SuishiBCI('/path/to/SuishiBCI/sample_data/demo_recording.bdf');
fprintf('nbchan=%d srate=%.1f\n', EEG.nbchan, EEG.srate);
```

在没有桌面环境的 Linux 系统中，可通过 `matlab -nodesktop -nosplash -batch "..."` 执行命令。仅当 EEGLAB 可用时，演示程序才会调用 `pop_eegplot` 显示波形。

示例数据包含 `1`、`2`、`4` 三种演示性事件标记，具体含义请参阅 [`sample_data/README.txt`](sample_data/README.txt)。

---

## 示例数据说明

| 项目 | 说明 |
|---|---|
| 文件 | `sample_data/demo_recording.bdf`（约 2.8 MB） |
| 数据来源 | 一段经过匿名化处理的脑机接口运动想象（MI）测试数据 |
| 时长 | 约 30 秒 |
| 通道数及采样率 | 32 通道，1000 Hz |
| 事件标记 | `1`、`2`、`4`（设备特定编码，并非通用标准事件体系） |
| 公开使用 | 已获准在本公开仓库中提供 |

更多说明请查看 [`sample_data/README.txt`](sample_data/README.txt)。

---

## MEX 编译（开发者）

底层 MEX 源代码位于配套工程的 `mex/MEX_BDF_RW/` 目录中，主要包括 `pop_loadTUNEXONDT.cpp` 和 `edflib/`。编译完成后，需将生成的 MEX 文件命名为 `SuishiBCI_bdf.mex*`（扩展名依操作系统而定），并放入插件的 `private/` 目录。

### Windows

可使用 Visual Studio 工程文件 `MEX_BDF_RW.vcxproj` 编译，也可在已配置支持的 C++ 编译器的 MATLAB 环境中执行：

```matlab
mex -output SuishiBCI_bdf pop_loadTUNEXONDT.cpp
```

输出文件为 `SuishiBCI_bdf.mexw64`。

### Linux

请使用与 MATLAB 版本兼容的 g++ 编译器。在默认 g++ 版本较新的 Ubuntu 系统中，可以使用 `g++-11`，以降低 MEX 与 MATLAB 自带 `libstdc++` 之间的兼容性问题。

```bash
sudo apt install gcc-11 g++-11
cd /path/to/mex/MEX_BDF_RW
matlab -nodesktop -nosplash -batch build_mex_linux
cp SuishiBCI_bdf.mexa64 /path/to/SuishiBCI/private/
```

`build_mex_linux.m` 将 `CC` 和 `CXX` 分别设为 `gcc-11`、`g++-11`，并使用编译选项 `CXXFLAGS='-std=c++11 -fPIC'`。

如果加载 MEX 时出现 `GLIBCXX_3.4.32 not found`，请尝试使用 `g++-11` 重新编译，而不是直接使用系统默认的新版 g++。

> **开发者注意：**上述源码及构建脚本位于配套工程，并不一定包含在本仓库中；普通用户可直接使用已发布的预编译 MEX 文件。

---

## 项目目录结构

```text
SuishiBCI/
├── eegplugin_SuishiBCI.m       # EEGLAB 插件入口及菜单注册
├── pop_SuishiBCI.m             # BDF/BDF+ 数据导入接口
├── private/
│   ├── SuishiBCI_bdf.mexw64    # Windows 64 位 BDF/BDF+ 读取程序
│   ├── SuishiBCI_bdf.mexa64    # Linux 64 位 BDF/BDF+ 读取程序
│   └── README.txt              # MEX 编译说明
├── sample_data/
│   ├── demo_recording.bdf      # 示例 BDF 数据（约 30 秒）
│   └── README.txt              # 示例数据来源及使用说明
├── demo/
│   └── demo_SuishiBCI.m        # 快速导入演示
├── README.md                   # 英文文档
├── README.zh-CN.md             # 中文文档
└── LICENSE                     # 许可证
```

---

## 常见问题

| 问题 | 解决方法 |
|---|---|
| EEGLAB 中没有出现插件菜单 | 确认插件文件夹位于 `eeglab/plugins/SuishiBCI/`，然后执行 `eeglab redraw`。 |
| EEGLAB 启动后菜单项显示为灰色 | 更新至最新插件版本。导入菜单使用 `startup:on`，无需先加载 EEG 数据集。 |
| 找不到 MEX 文件 | 检查 `private/` 中是否有对应系统的 `.mexw64`（Windows）或 `.mexa64`（Linux）文件，并确认使用的是 64 位 MATLAB。 |
| Linux 提示 `GLIBCXX_3.4.32 not found` | 尝试使用 `g++-11` 重新编译 MEX，详见“[MEX 编译](#mex-编译开发者)”。 |
| 提示找不到 BDF 文件 | 确认文件名包含 `.bdf` 扩展名；可使用完整路径，或使用 `fileparts` 得到的 `[fn ext]` 与 `fp`，注意不要颠倒参数顺序。 |
| 文件导入失败 | 确认文件是有效的 BDF/BDF+ 格式；可尝试使用 [EDFbrowser](https://www.teuniz.net/edfbrowser/) 打开该文件进行检查。 |
| 想重置文件选择窗口的默认目录 | 删除 MATLAB `prefdir` 目录中的 `SuishiBCI_lastdir.mat`，或从目标目录成功导入一次文件。 |
| 找不到示例数据 | 确认 `sample_data/demo_recording.bdf` 存在，并且下载了完整仓库或插件包。 |
| 找不到 `demo_SuishiBCI` | 将 `SuishiBCI/demo` 加入 MATLAB 路径，或使用 `run(.../demo/demo_SuishiBCI.m)` 执行。 |

---

## 许可证

本项目的许可条款请参见 [LICENSE](LICENSE)。
