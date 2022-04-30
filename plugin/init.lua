vim.cmd("command! BCLaunch lua require('build_config.launch').launch()")

vim.cmd("command! BCConanInstall lua require('build_config.conan').install()")
vim.cmd("command! BCConanCreate lua require('build_config.conan').create()")

vim.cmd("command! BCCMakeConfigure lua require('build_config.cmake').configure()")
vim.cmd("command! BCCMakeBuild lua require('build_config.cmake').build()")
vim.cmd("command! BCCMakeInstall lua require('build_config.cmake').install()")
vim.cmd("command! BCCMakeClean lua require('build_config.cmake').clean()")
vim.cmd("command! BCCMakeLinkCompileCommands lua require('build_config.cmake').link_compile_commands()")

vim.cmd([[
    function! BuildRun()
        execute 'BCCMakeBuild'
        execute 'BCLaunch'
    endfunction

    command! BCCMakeBuildLaunch call BuildRun()
]])

vim.cmd("command! BCPipInstallRequirements lua require('build_config.python').pip_install_requirements()")
vim.cmd("command! BCPythonRun lua require('build_config.python').run()")

vim.cmd("command! BCFlutterDoctor lua require('build_config.flutter').doctor()")
vim.cmd("command! BCFlutterDevices lua require('build_config.flutter').devices()")
vim.cmd("command! BCFlutterRun lua require('build_config.flutter').run()")
vim.cmd("command! BCFlutterBuild lua require('build_config.flutter').build()")
vim.cmd("command! BCFlutterTest lua require('build_config.flutter').test()")
vim.cmd("command! BCFlutterClean lua require('build_config.flutter').clean()")
vim.cmd("command! BCFlutterPubGet lua require('build_config.flutter').pub_get()")
vim.cmd("command! BCFlutterPubUpgrade lua require('build_config.flutter').pub_upgrade()")

vim.cmd("command! BCCargoRun lua require('build_config.cargo').run()")
vim.cmd("command! BCCargoBuild lua require('build_config.cargo').build()")
vim.cmd("command! BCCargoInstall lua require('build_config.cargo').install()")
vim.cmd("command! BCCargoClean lua require('build_config.cargo').clean()")

vim.cmd("command! BCBuildDevcontainer lua require('build_config.devcontainer').build_container()")
vim.cmd("command! BCLaunchDevcontainer lua require('build_config.devcontainer').launch_container()")
vim.cmd("command! BCStopDevcontainer lua require('build_config.devcontainer').stop_container()")

vim.cmd("command! BCApplyKeymaps lua require('build_config.keymaps').apply_keymaps()")
