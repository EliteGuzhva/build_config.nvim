# build_config.nvim

One configuration file to rule them all!

## Usage

Create `.build_config.json` in the root of your project.

### Config reference

```json
{
    // "launch"
    // Here you can configure how to run executables.
    // This example creates a command:
    //   ./pre_script.sh ./main --arg value
    // , which runs in `launch.cwd` directory.
    "launch": {
        "cwd": "bin",                        // working directory
        "exe": "main",                       // executable filename
        "before_script": "./pre_script.sh",  // script to run as a prefix
        "args": [                            // program arguments
            "--arg",
            "value"
        ]
    },
    // "python"
    // Python project configuration.
    "python": {
        "cwd": ".",           // working directory
        "exe": "python",      // python executable
        "venv": "venv",       // path to virtualenv directory
        "script": "main.py",  // script to run
        "args": [             // script arguments
            "--arg",
            "value"
        ]
    },
    // "cmake"
    // CMake project configuration.
    "cmake": {
        "exe": "cmake",                   // cmake executable
        "build_type": "Debug",            // project build type (Release, Debug, etc.)
        "export_compile_commands": true,  // use -DCMAKE_EXPORT_COMPILE_COMMANDS=ON flag
        "generator": "Ninja",             // generator (Makefiles, Ninja, etc.)
        "generate_options": [             // flags to pass to CMake
            "-DMY_OPTION=VALUE"   
        ],
        "build_options": [                // flags to pass to build program (make, cl, etc.)
            "--j8"
        ],
        "install_prefix": "./install",    // installation folder
        "target": "all"                   // cmake target
    },
    // "conan"
    // Conan package manager configuration.
    "conan": {
        "exe": "conan",                    // conan executable
        "install_folder": "build",         // installation folder (where to put all generated files)
        "build": "missing",                // --build option
        "path": ".",                       // path to conanfile[.py/.txt]
        "reference": "my-package/1.2.3@",  // package reference (when calling `conan.create`)
        "args": [                          // additional conan arguments
            "--keep-source"
        ],
    },
    // "flutter"
    // Flutter project configuration.
    "flutter": {
        "exe": "flutter",           // flutter executable
        "device": "macos",          // target device id
        "build_type": "release",    // `flutter run` build type
        "target": "lib/main.dart",  // target file to run
        "build_variant": "apk",     // subcommand for `flutter build`
        "args": [                   // additional flutter arguments
            "--verbose"
        ],
    },
    // "cargo"
    // Cargo (rust) project configuration.
    "cargo": {
        "exe": "cargo",              // cargo executable
        "bin": "src/main.rs",        // binary to run
        "install_dir": "./install",  // installation directory
        "args": [                    // additional cargo arguments
            "--verbose"
        ],
    },
    // "keymaps"
    // Configure keymaps for build_config.nvim commands.
    // Provided keymaps are not default (only for demonstration purpose).
    "keymaps": {
        "launch": {
            "launch": "<C-r>"
        },
        "python": {
            "run": "<leader>pr",
            "pip_install_requirements": "<leader>pi"
        },
        "cmake": {
            "configure": "<leader>cc",
            "build": "<leader>cb",
            "install": "<leader>ci",
            "clean": "<leader>cx",
            "link_compile_commands": "<leader>cl"
        },
        "conan": {
            "install": "<leader>cp",
            "create": "<leader>co"
        },
        "flutter": {
            "doctor": "<leader>fh",
            "devices": "<leader>fd",
            "run": "<leader>fr",
            "build": "<leader>fb",
            "test": "<leader>ft",
            "clean": "<leader>fc",
            "pub_get": "<leader>fg",
            "pub_upgrade": "<leader>fu"
        },
        // Devcontainer options are configured in .devcontainer/devcontainer.json.
        // Syntax is the same as in VSCode version (but not all options are available yet).
        // Devcontainer automatically stops on quitting Nvim.
        "devcontainer": {
            "build_container": "<leader>db",
            "launch_container": "<leader>dl",
            "stop_container": "<leader>ds"
        },
    },
}
```

### Nvim commands

```vim
BCLaunch                    " launch.launch

BCPipInstallRequirements    " python.pip_install_requirements
BCPythonRun                 " python.run

BCCMakeConfigure            " cmake.configure
BCCMakeBuild                " cmake.build
BCCMakeInstall              " cmake.install
BCCMakeClean                " cmake.clean
BCCMakeLinkCompileCommands  " cmake.link_compile_commands

BCConanInstall              " conan.install
BCConanCreate               " conan.create

BCFlutterDoctor             " flutter.doctor
BCFlutterDevices            " flutter.devices
BCFlutterRun                " flutter.run
BCFlutterBuild              " flutter.build
BCFlutterTest               " flutter.test
BCFlutterClean              " flutter.clean
BCFlutterPubGet             " flutter.pub_get
BCFlutterPubUpgrade         " flutter.pub_upgrade

BCCargoRun                  " cargo.run
BCCargoBuild                " cargo.build
BCCargoInstall              " cargo.install
BCCargoClean                " cargo.clean

BCBuildDevcontainer         " devcontainer.build_container
BCLaunchDevcontainer        " devcontainer.launch_container
BCStopDevcontainer          " devcontainer.stop_container

BCApplyKeymaps              " keymaps.apply_keymaps
```
